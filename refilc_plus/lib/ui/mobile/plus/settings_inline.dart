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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_helper.dart';

class PlusSettingsInline extends StatelessWidget {
  const PlusSettingsInline({super.key});

  @override
  Widget build(BuildContext context) {
    final String plusTier = Provider.of<PlusProvider>(context)
            .hasScope(PremiumScopes.tierGold)
        ? 'gold'
        : (Provider.of<PlusProvider>(context).hasScope(PremiumScopes.tierBasic)
            ? 'basic'
            : 'none');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: () {
          if (plusTier == 'none') {
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) {
                  // return empty container
                  return Container();
            }));
          } else {
            SettingsHelper.plusOptions(context);
          }
        },
        child: Container(),
      ),
    );
  }
}
