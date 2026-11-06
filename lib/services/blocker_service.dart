import 'package:flutter/services.dart';

class BlockerService {
  static const _channel = MethodChannel('com.destinyed.veto/blocker');

  static Future<void> lockApps(List<String> packages) async {
    try {
      await _channel.invokeMethod('lockApps', {'packages': packages});
    } catch (e) {
      // Platform not implemented yet or permission missing
      print('Lock failed: $e');
    }
  }

  static Future<void> unlockApps(List<String> packages) async {
    try {
      await _channel.invokeMethod('unlockApps', {'packages': packages});
    } catch (e) {
      print('Unlock failed: $e');
    }
  }

  static Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestPermissions');
      return result == true;
    } catch (e) {
      return false;
    }
  }
}
