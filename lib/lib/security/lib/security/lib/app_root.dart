import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'security/lock_service.dart';
import 'security/lock_screen.dart';
import 'security/set_pin_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  final lock = LockService();

  bool _unlocked = false;
  bool _needRelock = true;

  Timer? _idleTimer;

  // ✅ Выбери таймаут:
  final Duration idleTimeout = const Duration(seconds: 30);
  // final Duration idleTimeout = const Duration(minutes: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startGuard();
    _resetIdleTimer();
  }

  void _resetIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(idleTimeout, () {
      _needRelock = true;
      if (mounted) setState(() => _unlocked = false);
    });
  }

  Future<void> _startGuard() async {
    // 1) Если PIN ещё не установлен — предлагаем установить
    final hasPin = await lock.hasPin();
    if (!hasPin) {
      final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => SetPinScreen(lockService: lock)),
          ) ??
          false;

      // Если человек отменил — не включаем блокировку
      if (!created) {
        await lock.enable(false);
        setState(() {
          _unlocked = true;
          _needRelock = false;
        });
        return;
      }
    }

    // 2) Если блокировка включена — просим PIN
    final enabled = await lock.isEnabled();
    if (!enabled) {
      setState(() {
        _unlocked = true;
        _needRelock = false;
      });
      return;
    }

    await _guard();
  }

  Future<void> _guard() async {
    if (!_needRelock && _unlocked) return;

    setState(() => _unlocked = false);

    final ok = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => LockScreen(lockService: lock)),
        ) ??
        false;

    if (!mounted) return;

    setState(() {
      _unlocked = ok;
      _needRelock = !ok;
    });

    if (ok) _resetIdleTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ✅ Блок при сворачивании СРАЗУ
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _needRelock = true;
      _idleTimer?.cancel();
    }

    // ✅ При возврате — попросить PIN
    if (state == AppLifecycleState.resumed) {
      _guard();
      _resetIdleTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Любое касание — сброс idle таймера
    return Listener(
      onPointerDown: (_) => _resetIdleTimer(),
      child: MaterialApp(
        home: _unlocked ? const WebHome() : const LockCurtain(),
      ),
    );
  }
}

class LockCurtain extends StatelessWidget {
  const LockCurtain({super.key});
  @override
  Widget build(BuildContext context) {
    // “шторка”, чтобы контент не светился
    return const Scaffold(body: SizedBox.expand());
  }
}

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://uchet.zdravunion.kz/account/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
