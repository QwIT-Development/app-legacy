import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';

class LiveActivityConsentDialog extends StatelessWidget {
  const LiveActivityConsentDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const LiveActivityConsentDialog(),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 32.0),
      child: Material(
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  "live_activity_consent_title".i18n,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    "live_activity_consent_body".i18n,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _respond(context, false),
                      child: Text("live_activity_decline".i18n),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _respond(context, true),
                      child: Text("live_activity_accept".i18n),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _respond(BuildContext context, bool accepted) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final unseen =
        List<String>.from(settings.unseenNewFeatures);
    unseen.remove('live_activity_consent');
    settings.update(
      liveActivityEnabled: accepted,
      unseenNewFeatures: unseen,
    );
    Navigator.of(context).pop();
  }
}
