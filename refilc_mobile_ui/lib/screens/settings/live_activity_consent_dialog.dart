import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/screens/settings/live_activity_privacy_policy_screen.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';

class LiveActivityConsentDialog extends StatelessWidget {
  const LiveActivityConsentDialog({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const LiveActivityConsentDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24.0),
              // Header: bell icon + title
              Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: theme.colorScheme.secondary,
                    size: 36.0,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    "Live Activity",
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: colors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                "la_consent_subtitle".i18n,
                style: TextStyle(
                  fontSize: 15.0,
                  color: colors.text.withValues(alpha: 0.7),
                ),
              ),

              const SizedBox(height: 20.0),

              // Privacy warning card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: colors.orange,
                      size: 22.0,
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "la_privacy_policy".i18n,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "la_privacy_warning".i18n,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: colors.orange.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24.0),

              // Intro text
              Text(
                "la_consent_intro".i18n,
                style: TextStyle(
                  fontSize: 14.0,
                  color: colors.text.withValues(alpha: 0.8),
                ),
              ),

              const SizedBox(height: 24.0),

              // Info sections
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _InfoSection(
                        icon: Icons.build_outlined,
                        iconColor: theme.colorScheme.secondary,
                        title: "la_what_data".i18n,
                        description: "la_what_data_desc".i18n,
                      ),
                      const SizedBox(height: 20.0),
                      _InfoSection(
                        icon: Icons.lock_outline,
                        iconColor: theme.colorScheme.secondary,
                        title: "la_how_protect".i18n,
                        description: "la_how_protect_desc".i18n,
                      ),
                      const SizedBox(height: 20.0),
                      _InfoSection(
                        icon: Icons.access_time,
                        iconColor: theme.colorScheme.secondary,
                        title: "la_how_long".i18n,
                        description: "la_how_long_desc".i18n,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    // Learn more
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LiveActivityPrivacyPolicyScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          side: BorderSide(
                            color: colors.text.withValues(alpha: 0.2),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "la_learn_more".i18n,
                              style: TextStyle(
                                color: colors.text.withValues(alpha: 0.8),
                                fontSize: 15.0,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Icon(
                              FeatherIcons.chevronRight,
                              size: 18.0,
                              color: colors.text.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    // Accept
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => _respond(context, true),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          backgroundColor: theme.colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          "live_activity_accept".i18n,
                          style: TextStyle(
                            color: theme.colorScheme.onSecondary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Decline
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _respond(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          side: BorderSide(
                            color: colors.text.withValues(alpha: 0.15),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          "live_activity_decline".i18n,
                          style: TextStyle(
                            color: colors.text.withValues(alpha: 0.6),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _respond(BuildContext context, bool accepted) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final unseen = List<String>.from(settings.unseenNewFeatures);
    unseen.remove('live_activity_consent');
    if (accepted) {
      settings.update(
        liveActivityEnabled: true,
        liveActivityConsentAccepted: true,
        unseenNewFeatures: unseen,
      );
    } else {
      settings.update(
        unseenNewFeatures: unseen,
      );
    }
    Navigator.of(context).pop();
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _InfoSection({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20.0),
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.5,
                  color: colors.text.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
