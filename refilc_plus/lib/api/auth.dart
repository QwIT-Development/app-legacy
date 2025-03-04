/*
    refilc+, but more stripped and more open source
    Copyright (C) 2025  Firka team (QwIT development)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
