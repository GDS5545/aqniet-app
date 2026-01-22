import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'lock_service.dart';

class SetPinScreen extends StatefulWidget {
  final LockService lockService;
  const SetPinScreen({super.key, required this.lockService});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  String? firstPin;
  String? error;
  bool busy = false;

  // Выбери длину PIN (4 или 6)
  final int pinLength = 4;

  @override
  Widget build(BuildContext context) {
    final title = firstPin == null ? "Установите PIN" : "Повторите PIN";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstPin == null
                      ? "Введите $pinLength цифры"
                      : "Введите PIN ещё раз",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Pinput(
                  length: pinLength,
                  obscureText: true,
                  enabled: !busy,
                  onCompleted: (pin) async {
                    setState(() {
                      error = null;
                      busy = true;
                    });

                    if (firstPin == null) {
                      firstPin = pin;
                      setState(() => busy = false);
                      return;
                    }

                    if (pin != firstPin) {
                      firstPin = null;
                      setState(() {
                        busy = false;
                        error = "PIN не совпал. Попробуйте снова.";
                      });
                      return;
                    }

                    await widget.lockService.setPin(pin);
                    if (!mounted) return;
                    Navigator.of(context).pop(true);
                  },
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Отмена"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
