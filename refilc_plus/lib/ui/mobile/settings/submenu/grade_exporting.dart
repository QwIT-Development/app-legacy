// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/providers/third_party_provider.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_kreta_api/models/grade.dart';
import 'package:refilc_kreta_api/providers/grade_provider.dart';
import 'package:refilc_kreta_api/providers/share_provider.dart';
import 'package:refilc_mobile_ui/common/dot.dart';
import 'package:refilc_mobile_ui/common/panel/panel_button.dart';
import 'package:refilc_mobile_ui/common/splitted_panel/splitted_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc_mobile_ui/screens/settings/settings_screen.i18n.dart';
import 'package:refilc_plus/models/premium_scopes.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/upsell.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refilc_mobile_ui/common/chips/new_chip.dart';

class MenuGradeExporting extends StatelessWidget {
  const MenuGradeExporting({
    super.key,
    this.borderRadius = const BorderRadius.vertical(
        top: Radius.circular(4.0), bottom: Radius.circular(4.0)),
  });

  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return PanelButton(
      onPressed: () async {
        // if (!Provider.of<PlusProvider>(context, listen: false)
        //     .hasScope(PremiumScopes.calendarSync)) {
        //   return PlusLockedFeaturePopup.show(
        //       context: context, feature: PremiumFeature.calendarSync);
        // }

        // Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
        //     builder: (context) => const CalendarSyncScreen()));
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: const Text("Figyelem!"),
        //     content: const Text(
        //         "Az exportált jegyek jelenleg még nem megtekinthetők a reFilc-ben, csak te magad tudod átnézni őket JSON formátumban. A jövőben ez a funkció bővülni fog, és a jegyeket meg is tekintheted majd a reFilc felületén."),
        //     actions: [
        //       // TextButton(
        //       //   child: const Text(
        //       //     "Vissza",
        //       //     style: TextStyle(fontWeight: FontWeight.w500),
        //       //   ),
        //       //   onPressed: () {
        //       //     Navigator.of(context).pop();
        //       //   },
        //       // ),
        //       TextButton(
        //         child: const Text(
        //           "Tovább",
        //           style: TextStyle(fontWeight: FontWeight.w500),
        //         ),
        //         onPressed: () {
        //           Navigator.of(context).pop();

        Provider.of<SettingsProvider>(context, listen: false).update(
          unseenNewFeatures: List.from(
            Provider.of<SettingsProvider>(context, listen: false)
                .unseenNewFeatures
              ..remove('grade_exporting'),
          ),
        );
        // Provider.of<SettingsProvider>(context, listen: false).update(
        //   unseenNewFeatures: ['grade_exporting'],
        // );

        if (!Provider.of<PlusProvider>(context, listen: false)
            .hasScope(PremiumScopes.gradeExporting)) {
          return PlusLockedFeaturePopup.show(
              context: context, feature: PremiumFeature.gradeExporting);
        }

        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => const GradeExportingScreen()));
        //         },
        //       ),
        //     ],
        //   ),
        // );
      },
      title: Text(
        "grade_exporting".i18n,
        style: TextStyle(
          color: AppColors.of(context).text.withOpacity(.95),
        ),
      ),
      leading: Icon(
        Icons.toll_rounded,
        size: 22.0,
        color: AppColors.of(context).text.withOpacity(.95),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (Provider.of<SettingsProvider>(context)
              .unseenNewFeatures
              .contains('grade_exporting'))
            const NewChip(),
          Icon(
            FeatherIcons.chevronRight,
            size: 22.0,
            color: AppColors.of(context).text.withOpacity(0.95),
          )
        ],
      ),
      borderRadius: borderRadius,
    );
  }
}

class GradeExportingScreen extends StatefulWidget {
  const GradeExportingScreen({super.key});

  @override
  CalendarSyncScreenState createState() => CalendarSyncScreenState();
}

class CalendarSyncScreenState extends State<GradeExportingScreen>
    with SingleTickerProviderStateMixin {
  late SettingsProvider settingsProvider;
  late UserProvider user;
  late ShareProvider shareProvider;
  late ThirdPartyProvider thirdPartyProvider;

  late AnimationController _hideContainersController;

  @override
  void initState() {
    super.initState();

    shareProvider = Provider.of<ShareProvider>(context, listen: false);

    _hideContainersController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    settingsProvider = Provider.of<SettingsProvider>(context);
    user = Provider.of<UserProvider>(context);
    thirdPartyProvider = Provider.of<ThirdPartyProvider>(context);

    return AnimatedBuilder(
      animation: _hideContainersController,
      builder: (context, child) => Opacity(
        opacity: 1 - _hideContainersController.value,
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButton(color: AppColors.of(context).text),
            title: Text(
              "grade_exporting".i18n,
              style: TextStyle(color: AppColors.of(context).text),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                children: [
                  // choose export method
                  Column(
                    children: [
                      SplittedPanel(
                        title: Text('export_method'.i18n),
                        padding: EdgeInsets.zero,
                        cardPadding: const EdgeInsets.all(4.0),
                        isSeparated: true,
                        children: [
                          PanelButton(
                            onPressed: () async {
                              // get all grades
                              List<Grade> grades = Provider.of<GradeProvider>(
                                      context,
                                      listen: false)
                                  .grades;

                              // gmake a list of grades in json format
                              List<Map<dynamic, dynamic>> gradesList = [
                                for (Grade grade in grades)
                                  // {
                                  //   '"subject"': '"${grade.subject.name}"',
                                  //   '"value"': grade.value.value,
                                  //   '"value_name"':
                                  //       '"${grade.value.valueName}"',
                                  //   '"date"':
                                  //       '"${grade.date.toIso8601String()}"',
                                  //   '"weight"': grade.value.weight,
                                  //   '"type"': '"${grade.type.name}"',
                                  //   '"description"': '"${grade.description}"',
                                  //   '"teacher"': '"${grade.teacher.name}"',
                                  // }
                                  grade.json ?? {},
                              ];

                              // convert list to json file
                              final directory = await getTemporaryDirectory();

                              File file = File('${directory.path}/grades.json');
                              file.writeAsStringSync(
                                jsonEncode(gradesList),
                              );

                              // convert json to bytes
                              final jsonBytes = file.readAsBytesSync();

                              // get current study year
                              final now = DateTime.now();
                              String studyYearStr = '';
                              if (now.month <= 8) {
                                studyYearStr = '${now.year - 1}_${now.year}';
                              } else {
                                studyYearStr = '${now.year}_${now.year + 1}';
                              }

                              // open the share popup with the json file
                              Share.shareXFiles(
                                [
                                  XFile.fromData(
                                    jsonBytes,
                                    name: 'refilc_grades_$studyYearStr',
                                    mimeType: 'application/json',
                                  ),
                                ],
                                subject:
                                    'reFilc Jegyek - ${studyYearStr.replaceAll('_', '/')}',
                              );
                            },
                            title: Text(
                              'JSON',
                              style: TextStyle(
                                color:
                                    AppColors.of(context).text.withOpacity(.95),
                              ),
                            ),
                            // leading: Image.asset(
                            //   'assets/images/ext_logo/google.png',
                            //   width: 24.0,
                            //   height: 24.0,
                            // ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                              bottom: Radius.circular(12),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 10.0,
                      // ),
                      // const Text(
                      //     "Az exportált jegyek jelenleg még nem megtekinthetők a reFilc-ben, csak te magad tudod átnézni őket JSON formátumban. A jövőben ez a funkció bővülni fog, és a jegyeket meg is tekintheted majd a reFilc felületén."),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getCalendarList() {
    // List<Widget> widgets = thirdPartyProvider.googleCalendars
    //     .map(
    //       (e) => Container(
    //         margin: const EdgeInsets.only(bottom: 3.0),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: Theme.of(context).colorScheme.primary.withOpacity(.25),
    //             width: 1.0,
    //           ),
    //           borderRadius: BorderRadius.circular(12.0),
    //         ),
    //         child: PanelButton(
    //           onPressed: () async {
    //             print((e.backgroundColor ?? '#000000').replaceAll('#', '0x'));
    //             setState(() {});
    //           },
    //           title: Text(
    //             e.summary ?? 'no_title'.i18n,
    //             style: TextStyle(
    //               color: AppColors.of(context).text.withOpacity(.95),
    //             ),
    //           ),
    //           leading: Dot(
    //             color: colorFromHex(
    //                   e.backgroundColor ?? '#000',
    //                 ) ??
    //                 Colors.black,
    //           ),
    //           borderRadius: const BorderRadius.vertical(
    //             top: Radius.circular(12),
    //             bottom: Radius.circular(12),
    //           ),
    //         ),
    //       ),
    //     )
    //     .toList();

    List<Widget> widgets = [];

    widgets.add(
      Container(
        margin: const EdgeInsets.only(bottom: 3.0),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Theme.of(context).colorScheme.primary.withOpacity(.25),
          //   width: 1.0,
          // ),
          color: AppColors.of(context).highlight,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: PanelButton(
          onPressed: null,
          // onPressed: () async {
          //   // thirdPartyProvider.pushTimetable(context, timetable);
          //   setState(() {});
          // },
          title: Text(
            'reFilc - Órarend',
            style: TextStyle(
              color: AppColors.of(context).text.withOpacity(.95),
            ),
          ),
          // leading: Icon(
          //   FeatherIcons.plus,
          //   size: 20.0,
          //   color: AppColors.of(context).text.withOpacity(0.75),
          // ),
          leading: Dot(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(12),
          ),
        ),
      ),
    );

    return widgets;
  }
}
