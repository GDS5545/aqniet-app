import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockService {
  final _storage = const FlutterSecureStorage();

  static const _kEnabled = 'applock_enabled';
  static const _kPinHash = 'applock_pin_hash';
  static const _kPinLen = 'applock_pin_len';

  Future<bool> isEnabled() async => (await _storage.read(key: _kEnabled)) == '1';

  Future<void> enable(bool value) async {
    await _storage.write(key: _kEnabled, value: value ? '1' : '0');
  }

  Future<bool> hasPin() async => (await _storage.read(key: _kPinHash)) != null;

  Future<int> pinLength() async =>
      int.tryParse(await _storage.read(key: _kPinLen) ?? '') ?? 4;

  Future<void> setPin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _storage.write(key: _kPinHash, value: hash);
    await _storage.write(key: _kPinLen, value: pin.length.toString());
    await enable(true);
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await _storage.read(key: _kPinHash);
    if (saved == null) return false;
    final hash = sha256.convert(utf8.encode(pin)).toString();
    return hash == saved;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _kPinHash);
    await _storage.delete(key: _kPinLen);
    await enable(false);
  }
}
