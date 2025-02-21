import 'package:refilc/models/settings.dart';
import 'package:refilc_plus/api/auth.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:flutter/widgets.dart';

class PlusProvider extends ChangeNotifier {
  final SettingsProvider _settings;
  List<String> get scopes => _settings.premiumScopes;
  // bool hasScope(String scope) => false;
  bool hasScope(String scope) =>
      scopes.contains(scope) || scopes.contains(PremiumScopes.all);
  String get accessToken => _settings.premiumAccessToken;
  String get login => _settings.premiumLogin;
  bool get hasPremium =>
      _settings.plusSessionId != "" && _settings.premiumScopes.isNotEmpty;

  late final PremiumAuth _auth;
  PremiumAuth get auth => _auth;

  PlusProvider({required SettingsProvider settings}) : _settings = settings {
    _auth = PremiumAuth(settings: _settings);
    _settings.addListener(() {
      notifyListeners();
    });
  }

  Future<void> activate({bool removePremium = false}) async {
    await _auth.refreshAuth(removePremium: removePremium);
    notifyListeners();
  }
}
