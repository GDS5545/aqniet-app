import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'lock_service.dart';

class LockScreen extends StatefulWidget {
  final LockService lockService;
  const LockScreen({super.key, required this.lockService});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String? error;
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Введите PIN",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                FutureBuilder<int>(
                  future: widget.lockService.pinLength(),
                  builder: (_, snap) {
                    final len = snap.data ?? 4;
                    return Pinput(
                      length: len,
                      obscureText: true,
                      enabled: !busy,
                      onCompleted: (pin) async {
                        setState(() {
                          busy = true;
                          error = null;
                        });

                        final ok = await widget.lockService.verifyPin(pin);
                        if (!mounted) return;

                        if (ok) {
                          Navigator.of(context).pop(true);
                        } else {
                          setState(() {
                            busy = false;
                            error = "Неверный PIN";
                          });
                        }
                      },
                    );
                  },
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(error!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
