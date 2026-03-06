import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const MethodChannel _channel = MethodChannel('app.firka/liveactivity');

  /// Callback token rotation esetén (iOS APNs új tokent ad ki).
  static void Function(String pushToken, String deviceId, String bundleId)? onTokenUpdated;

  /// Callback ha a user dismiss-eli a Live Activity-t (swipe left).
  static void Function()? onActivityDismissed;

  static void _setupMethodCallListener() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'liveActivityTokenUpdated') {
        final args = call.arguments as Map?;
        if (args != null && onTokenUpdated != null) {
          onTokenUpdated!(
            args['pushToken'] as String? ?? '',
            args['deviceId'] as String? ?? '',
            args['bundleId'] as String? ?? '',
          );
        }
      } else if (call.method == 'liveActivityDismissed') {
        debugPrint("Live Activity dismissed by user");
        onActivityDismissed?.call();
      }
    });
  }

  /// Létrehozza a Live Activity-t és visszaadja az APNs push tokent,
  /// a device ID-t (Keychain UUID) és a bundle ID-t.
  static Future<Map<String, String>?> createLiveActivity(
      Map<String, dynamic> activityData) async {
    if (Platform.isIOS) {
      _setupMethodCallListener();
      try {
        debugPrint("creating live activity...");
        final result = await _channel.invokeMethod<Map>(
            'createLiveActivity', activityData);
        if (result == null) return null;
        return {
          'pushToken': result['pushToken'] as String? ?? '',
          'deviceId': result['deviceId'] as String? ?? '',
          'bundleId': result['bundleId'] as String? ?? '',
        };
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity létrehozásakor: ${e.message}");
      }
    }
    return null;
  }

  static Future<void> updateLiveActivity(
      Map<String, dynamic> activityData) async {
    if (Platform.isIOS) {
      try {
        debugPrint("updating live activity...");
        await _channel.invokeMethod('updateLiveActivity', activityData);
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity frissítésekor: ${e.message}");
      }
    }
  }

  static Future<void> endLiveActivity() async {
    if (Platform.isIOS) {
      try {
        debugPrint("ending live activity...");
        await _channel.invokeMethod('endLiveActivity');
      } on PlatformException catch (e) {
        debugPrint("Hiba történt a Live Activity befejezésekor: ${e.message}");
      }
    }
  }
}
