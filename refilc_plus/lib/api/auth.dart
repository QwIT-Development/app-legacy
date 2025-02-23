import 'dart:async';

import 'package:refilc/models/settings.dart';

class PremiumAuth {
  final SettingsProvider _settings;

  PremiumAuth({required SettingsProvider settings}) : _settings = settings;

  initAuth({required String product, required String paymentProvider}) {
  }

  Future<bool> finishAuth(String sessionId) async {
    await _settings.update(plusSessionId: "", premiumScopes: ["refilc.plus.*"]);
    return false;
  }

  Future<bool> refreshAuth(
      {bool removePremium = false, bool reactivate = false}) async {
    await _settings.update(
      premiumAccessToken: "",
      premiumScopes: ["refilc.plus.*"],
      premiumLogin: "",
      plusSessionId: "",
    );
    return false;
  }
}
