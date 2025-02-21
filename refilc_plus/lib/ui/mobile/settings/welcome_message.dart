import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:provider/provider.dart';
import 'package:i18n_extension/i18n_extension.dart';

// ignore: must_be_immutable
class WelcomeMessagePanelButton extends StatelessWidget {
  late SettingsProvider settingsProvider;
  late UserProvider user;

  WelcomeMessagePanelButton(this.settingsProvider, this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    String finalName = ((user.nickname ?? '') != ''
            ? user.nickname
            : (user.displayName ?? '') != ''
                ? user.displayName
                : 'János') ??
        'János';

    return PanelButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => WelcomeMessageEditor(settingsProvider));
      },
      title: Text(
        "welcome_msg".i18n,
        style: TextStyle(
          color: AppColors.of(context).text.withOpacity(.95),
        ),
      ),
      leading: Icon(
        FeatherIcons.smile,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(.95),
      ),
      trailing: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Text(
          settingsProvider.welcomeMessage.replaceAll(' ', '') != ''
              ? localizeFill(
                  settingsProvider.welcomeMessage,
                  [finalName],
                )
              : 'default'.i18n,
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.end,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WelcomeMessageEditor extends StatefulWidget {
  late SettingsProvider settingsProvider;

  WelcomeMessageEditor(this.settingsProvider, {super.key});

  @override
  State<WelcomeMessageEditor> createState() => _WelcomeMessageEditorState();
}

class _WelcomeMessageEditorState extends State<WelcomeMessageEditor> {
  final _welcomeMsg = TextEditingController();

  @override
  void initState() {
    super.initState();
    _welcomeMsg.text =
        widget.settingsProvider.welcomeMessage.replaceAll('%s', '%name%');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("edit_welcome_msg".i18n),
      content: TextField(
        controller: _welcomeMsg,
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text('welcome_msg'.i18n),
          suffixIcon: IconButton(
            icon: const Icon(FeatherIcons.x),
            onPressed: () {
              setState(() {
                _welcomeMsg.text = "";
              });
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "cancel".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        TextButton(
          child: Text(
            "done".i18n,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          onPressed: () {
            // var trimmed = _welcomeMsg.text.trim();

            // var defLen = trimmed.length;
            // var replacedLen = trimmed.replaceAll('%s', '').length;

            // if (defLen - 2 > replacedLen) {
            //   print('fuck yourself rn');
            // }
            var finalText = _welcomeMsg.text
                .trim()
                .replaceFirst('%name%', '\$s')
                .replaceFirst('%user%', '\$s')
                .replaceFirst('%username%', '\$s')
                .replaceFirst('%me%', '\$s')
                .replaceFirst('%profile%', '\$s')
                .replaceAll('%', '')
                .replaceFirst('\$s', '%s');
            // .replaceAll('\$s', 's');

            if (!Provider.of<PlusProvider>(context, listen: false)
                    .hasScope(PremiumScopes.welcomeMessage) &&
                finalText.replaceAll(' ', '') != '') {
              PlusLockedFeaturePopup.show(
                  context: context, feature: PremiumFeature.welcomeMessage);
              return;
            }

            widget.settingsProvider
                .update(welcomeMessage: finalText, store: true);
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
