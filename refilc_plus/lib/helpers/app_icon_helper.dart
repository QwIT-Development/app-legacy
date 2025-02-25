import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

class AppIconHelper {
  // static const _channel = MethodChannel('app_icon');

  static Future<void> setAppIcon(String iconName) async {
    try {
      if (await FlutterDynamicIconPlus.supportsAlternateIcons) {
        // await FlutterDynamicIconPlus.setAlternateIconName(iconName: "icon_new");
        if (kDebugMode) {
          print("successfully changed app icon");
        }
        return;
      }
    } on PlatformException {
      if (kDebugMode) {
        print("failed to change icon");
      }
    } catch (e) {
      // ha nem megy hat nem megy
    }
    // if (Platform.isIOS) {
    //   // change icon on ios
    //   try {
    //     if (await FlutterDynamicIcon.supportsAlternateIcons) {
    //       await _channel.invokeMethod('changeIcon', iconName);
    //       // await FlutterDynamicIcon.setApplicationIconBadgeNumber(0); we don't need this rn, but we will
    //       await FlutterDynamicIcon.setAlternateIconName(iconName);
    //     }
    //   } on PlatformException catch (e) {
    //     if (kDebugMode) {
    //       print('Failed to change app icon: ${e.message}');
    //     }
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('Ha nem megy, hat nem megy');
    //     }
    //   }
    // } else if (Platform.isAndroid) {
    //   // change icon on android
    //   // ignore: no_leading_underscores_for_local_identifiers
    //   final _androidDynamicIconPlugin = AndroidDynamicIcon();
    //   await _androidDynamicIconPlugin.changeIcon(
    //     bundleId: 'app.firka.legacy',
    //     isNewIcon: iconName != 'refilc_default' ? true : false,
    //     iconName: iconName != 'refilc_default' ? iconName : '',
    //     iconNames: [
    //       'refilc_default',
    //       'refilc_overcomplicated',
    //       'refilc_concept',
    //       'refilc_pride',
    //     ],
    //   );
    // } else {
    //   // ha nem megy hát nem megy
    // }
  }
}
