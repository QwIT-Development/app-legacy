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
