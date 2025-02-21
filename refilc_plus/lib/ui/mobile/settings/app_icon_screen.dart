import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/panel/panel.dart';
// import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_plus/helpers/app_icon_helper.dart';
// import 'package:refilc_plus/models/premium_scopes.dart';
// import 'package:refilc_plus/providers/plus_provider.dart';
// import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'app_icon_screen.i18n.dart';

class PremiumCustomAppIconMenu extends StatelessWidget {
  const PremiumCustomAppIconMenu({super.key, required this.settings});

  final SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    // return PanelButton(
    //   onPressed: () {
    //     if (!Provider.of<PlusProvider>(context, listen: false)
    //         .hasScope(PremiumScopes.changeAppIcon)) {
    //       PlusLockedFeaturePopup.show(
    //           context: context, feature: PremiumFeature.appiconchange);
    //       return;
    //     }

    //     Navigator.of(context, rootNavigator: true).push(
    //       CupertinoPageRoute(builder: (context) => const ModifyAppIcon()),
    //     );
    //   },
    //   title: Text('custom_app_icon'.i18n),
    //   leading: const Icon(FeatherIcons.edit),
    // );
    return const SizedBox(
      width: 0,
      height: 0,
    );
  }
}

class ModifyAppIcon extends StatefulWidget {
  const ModifyAppIcon({super.key});

  @override
  State<ModifyAppIcon> createState() => _ModifyAppIconState();
}

class _ModifyAppIconState extends State<ModifyAppIcon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SettingsProvider settings;

  @override
  Widget build(BuildContext context) {
    settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(color: AppColors.of(context).text),
          title: Text(
            "app_icons".i18n,
            style: TextStyle(color: AppColors.of(context).text),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Panel(
                  title: Text("basic".i18n),
                  child: Column(
                    children: [
                      AppIconItem(
                        iconName: 'refilc_default',
                        iconPath: 'assets/launch_icons/refilc_default.png',
                        displayName: 'reFilc Default',
                        description: 'Az alapértelmezett ikon.',
                        selected: settings.appIcon == 'refilc_default',
                        selectCallback: () async {
                          await AppIconHelper.setAppIcon('refilc_default');
                          settings.update(appIcon: 'refilc_default');
                        },
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16.0),
                // Panel(
                //   title: Text("seasonal".i18n),
                //   child: Column(
                //     children: [
                //       // AppIconItem(
                //       //   iconName: 'refilc_default',
                //       //   iconPath: 'assets/launch_icons/refilc_default.png',
                //       //   displayName: 'reFilc Default',
                //       //   description: 'Az alapértelmezett ikon.',
                //       //   selected: true,
                //       //   selectCallback: () {},
                //       // ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 16.0),
                Panel(
                  title: Text("special".i18n),
                  child: Column(
                    children: [
                      AppIconItem(
                        iconName: 'refilc_overcomplicated',
                        iconPath:
                            'assets/launch_icons/refilc_overcomplicated.png',
                        displayName: 'Overcomplicated',
                        // description: 'Egy túlkomplikált ikon.',
                        selected: settings.appIcon == 'refilc_overcomplicated',
                        selectCallback: () async {
                          await AppIconHelper.setAppIcon(
                              'refilc_overcomplicated');
                          settings.update(appIcon: 'refilc_overcomplicated');
                        },
                      ),
                      AppIconItem(
                        iconName: 'refilc_concept',
                        iconPath: 'assets/launch_icons/refilc_concept.png',
                        displayName: 'Modern Concept',
                        // description: 'Egy modernebb, letisztultabb ikon.',
                        selected: settings.appIcon == 'refilc_concept',
                        selectCallback: () async {
                          await AppIconHelper.setAppIcon('refilc_concept');
                          settings.update(appIcon: 'refilc_concept');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Panel(
                  title: Text("other".i18n),
                  child: Column(
                    children: [
                      AppIconItem(
                        iconName: 'refilc_pride',
                        iconPath: 'assets/launch_icons/refilc_pride.png',
                        displayName: 'Pride',
                        // description: '',
                        selected: settings.appIcon == 'refilc_pride',
                        selectCallback: () async {
                          await AppIconHelper.setAppIcon('refilc_pride');
                          settings.update(appIcon: 'refilc_pride');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class AppIconItem extends StatelessWidget {
  const AppIconItem({
    super.key,
    required this.iconName,
    required this.iconPath,
    required this.displayName,
    this.description,
    required this.selected,
    required this.selectCallback,
  });

  final String iconName;
  final String iconPath;
  final String displayName;
  final String? description;
  final bool selected;
  final void Function() selectCallback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 32.0,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      visualDensity: VisualDensity.compact,
      onTap: () {},
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: AssetImage(iconPath),
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: InkWell(
        onTap: selectCallback,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: description == null ? 3.2 : 1.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (description != null)
              Text(
                description!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: AppColors.of(context).text.withOpacity(.75),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
      trailing: selected
          ? Icon(
              FeatherIcons.checkCircle,
              color: Theme.of(context).colorScheme.primary,
            )
          : const SizedBox(),
    );
  }
}
