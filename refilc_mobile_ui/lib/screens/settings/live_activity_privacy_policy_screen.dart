import 'package:flutter/material.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';

class LiveActivityPrivacyPolicyScreen extends StatelessWidget {
  const LiveActivityPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: colors.text),
        title: Text(
          "la_pp_title".i18n,
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bodyText("la_pp_intro".i18n, colors),
            const SizedBox(height: 24.0),

            _sectionTitle("la_pp_what_title".i18n, colors),
            const SizedBox(height: 8.0),
            _bodyText("la_pp_what_intro".i18n, colors),
            const SizedBox(height: 12.0),
            _bulletList([
              "la_pp_d1".i18n,
              "la_pp_d2".i18n,
              "la_pp_d3".i18n,
              "la_pp_d4".i18n,
              "la_pp_d5".i18n,
              "la_pp_d6".i18n,
              "la_pp_d7".i18n,
            ], colors),
            const SizedBox(height: 16.0),

            _bodyText("la_pp_timetable_intro".i18n, colors),
            const SizedBox(height: 12.0),
            _bulletList([
              "la_pp_t1".i18n,
              "la_pp_t2".i18n,
              "la_pp_t3".i18n,
              "la_pp_t4".i18n,
              "la_pp_t5".i18n,
              "la_pp_t6".i18n,
              "la_pp_t7".i18n,
            ], colors),
            const SizedBox(height: 16.0),

            _bodyText("la_pp_notifications_intro".i18n, colors),
            const SizedBox(height: 12.0),
            _bulletList([
              "la_pp_n1".i18n,
              "la_pp_n2".i18n,
              "la_pp_n3".i18n,
              "la_pp_n4".i18n,
              "la_pp_n5".i18n,
            ], colors),
            const SizedBox(height: 24.0),

            _sectionTitle("la_pp_purpose_title".i18n, colors),
            const SizedBox(height: 8.0),
            _bodyText("la_pp_purpose_intro".i18n, colors),
            const SizedBox(height: 12.0),
            _bulletList([
              "la_pp_p1".i18n,
              "la_pp_p2".i18n,
              "la_pp_p3".i18n,
              "la_pp_p4".i18n,
            ], colors),
            const SizedBox(height: 12.0),
            _bodyText("la_pp_no_third_party".i18n, colors),
            const SizedBox(height: 24.0),

            _sectionTitle("la_pp_rights_title".i18n, colors),
            const SizedBox(height: 8.0),
            _bodyText("la_pp_rights_intro".i18n, colors),
            const SizedBox(height: 12.0),
            _bulletList([
              "la_pp_r1".i18n,
              "la_pp_r2".i18n,
              "la_pp_r3".i18n,
              "la_pp_r4".i18n,
            ], colors),
            const SizedBox(height: 32.0),

            Text(
              "la_pp_updated".i18n,
              style: TextStyle(
                fontSize: 12.0,
                color: colors.text.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              "la_pp_contact".i18n,
              style: TextStyle(
                fontSize: 12.0,
                color: colors.text.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ThemeAppColors colors) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: colors.text,
      ),
    );
  }

  Widget _bodyText(String text, ThemeAppColors colors) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        color: colors.text.withValues(alpha: 0.7),
        height: 1.5,
      ),
    );
  }

  Widget _bulletList(List<String> items, ThemeAppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: colors.text.withValues(alpha: 0.7),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: colors.text.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
