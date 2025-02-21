import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:refilc/api/client.dart';
import 'package:refilc/models/settings.dart';
import 'package:flutter/foundation.dart';
import 'package:refilc_plus/models/premium_result.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
// import 'package:home_widget/home_widget.dart';

class PremiumAuth {
  final SettingsProvider _settings;
  StreamSubscription? _sub;

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
