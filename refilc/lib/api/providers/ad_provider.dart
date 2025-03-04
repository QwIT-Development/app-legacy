/*
    Firka legacy (formely "refilc"), the unofficial client for e-Kréta
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

import 'package:refilc/models/ad.dart';
import 'package:flutter/material.dart';

class AdProvider extends ChangeNotifier {
  // private
  late List<Ad> _ads;
  bool get available => _ads.isNotEmpty;

  // public
  List<Ad> get ads => _ads;

  AdProvider({
    List<Ad> initialAds = const [],
    required BuildContext context,
  }) {
    _ads = List.castFrom(initialAds);
  }

  Future<void> fetch() async {
    _ads = [];
    _ads.sort((a, b) => -a.date.compareTo(b.date));

    // check for new ads
    if (_ads.isNotEmpty) {
      notifyListeners();
    }
  }
}
