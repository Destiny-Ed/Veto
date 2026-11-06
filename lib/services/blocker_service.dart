import 'package:flutter/services.dart';

class BlockerService {
  static const _channel = MethodChannel('com.destinyed.veto/blocker');

  // Common trading app package names / bundle IDs
  static const Map<String, String> knownApps = {
    'MetaTrader 5': 'net.metaquotes.metatrader5',
    'TradingView': 'com.tradingview.tradingviewapp',
    'cTrader': 'com.spotware.ct',
    'Thinkorswim': 'com.tdameritrade.thinkorswim',
    'MetaTrader 4': 'net.metaquotes.metatrader4',
  };

  static Future<void> lockApps(List<String> appNames) async {
    final packages = appNames.map((name) => knownApps[name] ?? name).toList();
    try {
      await _channel.invokeMethod('lockApps', {'packages': packages});
    } on PlatformException catch (e) {
      print('Lock failed: ${e.message}');
    }
  }

  static Future<void> unlockApps(List<String> appNames) async {
    final packages = appNames.map((name) => knownApps[name] ?? name).toList();
    try {
      await _channel.invokeMethod('unlockApps', {'packages': packages});
    } on PlatformException catch (e) {
      print('Unlock failed: ${e.message}');
    }
  }

  static Future<bool> requestPermissions() async {
    try {
      final result = await _channel.invokeMethod('requestPermissions');
      return result == true;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> isAccessibilityEnabled() async {
    try {
      final result = await _channel.invokeMethod('isAccessibilityEnabled');
      return result == true;
    } catch (_) {
      return false;
    }
  }
}
