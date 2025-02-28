import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'plus_things.i18n.dart';
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
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: plusTier == 'gold'
                  ? const AssetImage('assets/images/btn_plus_gold.png')
                  : const AssetImage('assets/images/btn_plus_standard.png'),
              fit: BoxFit.fitWidth,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 2.0,
                  ),
                  Image.asset(
                    plusTier == 'gold'
                        ? 'assets/images/plus_tier_ink.png'
                        : 'assets/images/plus_tier_cap.png',
                    width: 23.0,
                    height: 23.0,
                  ),
                  const SizedBox(
                    width: 14.0,
                  ),
                  Text(
                    'reFilc+',
                    style: TextStyle(
                      color: plusTier == 'gold'
                          ? const Color(0xFF341C01)
                          : const Color(0xFF150D4E),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                plusTier == 'none' ? '0.99 €' : 'subscriber'.i18n,
                style: const TextStyle(
                  color: Color(0xFF150D4E),
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
