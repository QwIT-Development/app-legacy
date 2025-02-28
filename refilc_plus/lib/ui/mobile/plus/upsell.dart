import 'package:flutter_svg/svg.dart';
import 'package:refilc_mobile_ui/common/bottom_sheet_menu/rounded_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'plus_things.i18n.dart';

enum PremiumFeature {
  // old things
  gradestats,
  customcolors,
  profile,
  iconpack,
  subjectrename,
  weeklytimetable,
  widget,
  // new things
  moreAccounts, // cap, (ink, sponge)
  betaReleases, // cap
  welcomeMessage, // cap
  selfNotes, // cap
  gradeCalculation, // ink
  liveActivity, // ink
  timetableNotes, // ink
  iconChange, // sponge
  fontChange, // sponge
  goalPlanner, // sponge
  gradeRarities,
  calendarSync,
  gradeExporting, // basic
}

enum PremiumFeatureLevel {
  old,
  cap,
  ink,
  sponge,
  // new new new
  basic,
  gold,
}

const Map<PremiumFeature, PremiumFeatureLevel> _featureLevels = {
  // old things
  PremiumFeature.gradestats: PremiumFeatureLevel.old,
  PremiumFeature.customcolors: PremiumFeatureLevel.old,
  PremiumFeature.profile: PremiumFeatureLevel.old,
  PremiumFeature.iconpack: PremiumFeatureLevel.old,
  PremiumFeature.subjectrename: PremiumFeatureLevel.old,
  PremiumFeature.weeklytimetable: PremiumFeatureLevel.old,
  PremiumFeature.widget: PremiumFeatureLevel.old,
  // new things
  PremiumFeature.moreAccounts: PremiumFeatureLevel.basic,
  PremiumFeature.betaReleases: PremiumFeatureLevel.basic,
  PremiumFeature.welcomeMessage: PremiumFeatureLevel.basic,
  PremiumFeature.selfNotes: PremiumFeatureLevel.basic,
  PremiumFeature.gradeCalculation: PremiumFeatureLevel.basic,
  PremiumFeature.liveActivity: PremiumFeatureLevel.gold,
  PremiumFeature.timetableNotes: PremiumFeatureLevel.gold,
  PremiumFeature.iconChange: PremiumFeatureLevel.gold,
  PremiumFeature.fontChange: PremiumFeatureLevel.gold,
  PremiumFeature.goalPlanner: PremiumFeatureLevel.gold,
  PremiumFeature.gradeRarities: PremiumFeatureLevel.basic,
  PremiumFeature.calendarSync: PremiumFeatureLevel.gold,
  PremiumFeature.gradeExporting: PremiumFeatureLevel.basic,
};

// const Map<PremiumFeature, String> _featureAssets = {
//   // old
//   PremiumFeature.gradestats: "assets/images/premium_stats_showcase.png",
//   PremiumFeature.customcolors: "assets/images/premium_theme_showcase.png",
//   PremiumFeature.profile: "assets/images/premium_nickname_showcase.png",
//   PremiumFeature.weeklytimetable:
//       "assets/images/premium_timetable_showcase.png",
//   // PremiumFeature.goalplanner: "assets/images/premium_goal_showcase.png",
//   PremiumFeature.widget: "assets/images/premium_widget_showcase.png",
//   // new
//   PremiumFeature.moreAccounts: "assets/images/premium_banner/more_accounts.png",
//   PremiumFeature.betaReleases: "assets/images/premium_banner/beta_releases.png",
//   PremiumFeature.welcomeMessage:
//       "assets/images/premium_banner/welcome_message.png",
//   PremiumFeature.selfNotes: "assets/images/premium_banner/self_notes.png",
//   PremiumFeature.gradeCalculation:
//       "assets/images/premium_banner/grade_calc.png",
//   PremiumFeature.liveActivity: "assets/images/premium_banner/live_activity.png",
//   PremiumFeature.timetableNotes:
//       "assets/images/premium_banner/timetable_notes.png",
//   PremiumFeature.iconChange: "assets/images/premium_banner/app_icon.png",
//   PremiumFeature.fontChange: "assets/images/premium_banner/font.png",
//   PremiumFeature.goalPlanner: "assets/images/premium_banner/goal_planner.png",

//   PremiumFeature.gradeRarities:
//       "assets/images/premium_banner/grade_rarities.png",
//   PremiumFeature.calendarSync: "assets/images/premium_banner/calendar_sync.png",
// };

const Map<PremiumFeature, String> _featureTitles = {
  // old shit
  PremiumFeature.gradestats: "Találtál egy prémium funkciót.",
  PremiumFeature.customcolors: "Több személyre szabás kell?",
  PremiumFeature.profile: "Nem tetszik a neved?",
  PremiumFeature.iconpack: "Jobban tetszettek a régi ikonok?",
  PremiumFeature.subjectrename:
      "Sokáig tart elolvasni, hogy \"Földrajz természettudomány\"?",
  PremiumFeature.weeklytimetable: "Szeretnéd egyszerre az egész hetet látni?",
  // PremiumFeature.goalplanner: "Kövesd a céljaidat, sok-sok statisztikával.",
  PremiumFeature.widget: "Órák a kezdőképernyőd kényelméből.",
  // new shit
  PremiumFeature.moreAccounts: "u_title_1",
  PremiumFeature.betaReleases: "u_title_2",
  PremiumFeature.welcomeMessage: "u_title_3",
  PremiumFeature.selfNotes: "u_title_4",
  PremiumFeature.gradeCalculation: "u_title_5",
  PremiumFeature.liveActivity: "u_title_6",
  PremiumFeature.timetableNotes: "u_title_7",
  PremiumFeature.iconChange: "u_title_8",
  PremiumFeature.fontChange: "u_title_9",
  PremiumFeature.goalPlanner: "u_title_10",
  PremiumFeature.gradeRarities: "u_title_11",
  PremiumFeature.calendarSync: "u_title_12",
  PremiumFeature.gradeExporting: "u_title_13",
};

const Map<PremiumFeature, String> _featureDescriptions = {
  // old
  PremiumFeature.gradestats:
      "Támogass Kupak szinten, hogy több statisztikát láthass. ",
  PremiumFeature.customcolors:
      "Támogass Kupak szinten, és szabd személyre az elemek, a háttér, és a panelek színeit.",
  PremiumFeature.profile:
      "Kupak szinten változtathatod a nevedet, sőt, akár a profilképedet is.",
  PremiumFeature.iconpack:
      "Támogass Kupak szinten, hogy ikon témát választhass.",
  PremiumFeature.subjectrename:
      "Támogass Kupak szinten, hogy átnevezhesd Föcire.",
  PremiumFeature.weeklytimetable:
      "Támogass Tinta szinten a heti órarend funkcióért.",
  // PremiumFeature.goalplanner: "A célkövetéshez támogass Tinta szinten.",
  PremiumFeature.widget:
      "Támogass Tinta szinten, és helyezz egy widgetet a kezdőképernyődre.",
  // new
  PremiumFeature.moreAccounts: "u_desc_1",
  PremiumFeature.betaReleases: "u_desc_2",
  PremiumFeature.welcomeMessage: "u_desc_3",
  PremiumFeature.selfNotes: "u_desc_4",
  PremiumFeature.gradeCalculation: "u_desc_5",
  PremiumFeature.liveActivity: "u_desc_6",
  PremiumFeature.timetableNotes: "u_desc_7",
  PremiumFeature.iconChange: "u_desc_8",
  PremiumFeature.fontChange: "u_desc_9",
  PremiumFeature.goalPlanner: "u_desc_10",
  PremiumFeature.gradeRarities: "u_desc_11",
  PremiumFeature.calendarSync: "u_desc_12",
  PremiumFeature.gradeExporting: "u_desc_13",
};

// class PremiumLockedFeatureUpsell extends StatelessWidget {
//   const PremiumLockedFeatureUpsell({super.key, required this.feature});

//   static void show(
//           {required BuildContext context, required PremiumFeature feature}) =>
//       showRoundedModalBottomSheet(context,
//           child: PremiumLockedFeatureUpsell(feature: feature));

//   final PremiumFeature feature;

//   IconData _getIcon() => _featureLevels[feature] == PremiumFeatureLevel.cap
//       ? FilcIcons.kupak
//       : _featureLevels[feature] == PremiumFeatureLevel.ink
//           ? FilcIcons.tinta
//           : FilcIcons.tinta;
//   Color _getColor(BuildContext context) =>
//       _featureLevels[feature] == PremiumFeatureLevel.gold
//           ? const Color(0xFFC89B08)
//           : Theme.of(context).brightness == Brightness.light
//               ? const Color(0xff691A9B)
//               : const Color(0xffA66FC8);
//   String? _getAsset() => _featureAssets[feature];
//   String _getTitle() => _featureTitles[feature]!;
//   String _getDescription() => _featureDescriptions[feature]!;

//   @override
//   Widget build(BuildContext context) {
//     final Color color = _getColor(context);

//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title Bar
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Icon(_getIcon()),
//                 ),
//                 IconButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   icon: const Icon(Icons.close),
//                 ),
//               ],
//             ),

//             // Image showcase
//             if (_getAsset() != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Image.asset(_getAsset()!),
//               ),

//             // Dialog title
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0),
//               child: Text(
//                 _getTitle(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.0,
//                 ),
//               ),
//             ),

//             // Dialog description
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(
//                 _getDescription(),
//                 style: const TextStyle(
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),

//             // CTA button
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: TextButton(
//                   style: ButtonStyle(
//                       backgroundColor:
//                           WidgetStatePropertyAll(color.withOpacity(.25)),
//                       foregroundColor: WidgetStatePropertyAll(color),
//                       overlayColor:
//                           WidgetStatePropertyAll(color.withOpacity(.1))),
//                   onPressed: () {
//                     Navigator.of(context, rootNavigator: true)
//                         .push(MaterialPageRoute(builder: (context) {
//                       return const PlusScreen();
//                     }));
//                   },
//                   child: const Text(
//                     "Vigyél oda!",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class PlusLockedFeaturePopup extends StatelessWidget {
  const PlusLockedFeaturePopup({super.key, required this.feature});

  static void show({
    required BuildContext context,
    required PremiumFeature feature,
  }) =>
      showRoundedModalBottomSheet(
        context,
        child: PlusLockedFeaturePopup(
          feature: feature,
        ),
        showHandle: false,
      );

  final PremiumFeature feature;

  PremiumFeatureLevel? _getFeatureLevel() => _featureLevels[feature];

  // IconData _getIcon() => _featureLevels[feature] == PremiumFeatureLevel.cap
  //     ? FilcIcons.kupak
  //     : _featureLevels[feature] == PremiumFeatureLevel.ink
  //         ? FilcIcons.tinta
  //         : FilcIcons.tinta;
  // Color _getColor(BuildContext context) =>
  //     _featureLevels[feature] == PremiumFeatureLevel.gold
  //         ? const Color(0xFFC89B08)
  //         : Theme.of(context).brightness == Brightness.light
  //             ? const Color(0xff691A9B)
  //             : const Color(0xffA66FC8);
  // String? _getAsset() => _featureAssets[feature];
  String _getTitle() => _featureTitles[feature]!.i18n;
  String _getDescription() => _featureDescriptions[feature]!.i18n;

  @override
  Widget build(BuildContext context) {
    final bool isGold = _getFeatureLevel() == PremiumFeatureLevel.gold;

    return Container(
      decoration: BoxDecoration(
        color: isGold ? const Color(0xFFF7EDD9) : const Color(0xFFDCDAF7),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12.0),
        ),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            // "assets/svg/mesh_bg.svg",
            "assets/svg/cover_arts/grid.svg",
            // ignore: deprecated_member_use
            color: isGold ? const Color(0xFFf0dcb6) : const Color(0xFFbcb8f0),
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isGold
                          ? const Color(0xFF341C01)
                          : const Color(0xFF130667),
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 38.0,
                  ),
                  Image.asset(
                    'assets/images/pixel.png',
                    width: 66,
                    height: 66,
                  ),
                  const SizedBox(
                    height: 55.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF7F9FC,
                      ).withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12.0),
                        bottom: Radius.circular(6.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isGold ? 'reFilc+ Gold' : 'reFilc+',
                          style: TextStyle(
                            color: isGold
                                ? const Color(0xFFAD7637)
                                : const Color(0xFF7463E2),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          _getTitle(),
                          style: TextStyle(
                            color: isGold
                                ? const Color(0xFF341C01)
                                : const Color(0xFF150D4E),
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          _getDescription(),
                          style: TextStyle(
                            color: isGold
                                ? const Color(0xFF341C01)
                                : const Color(0xFF150D4E),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF7F9FC,
                      ).withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6.0),
                        bottom: Radius.circular(12.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A reFilc+ 0.99 €, a reFilc+ Gold 2.99 €',
                          style: TextStyle(
                            color: isGold
                                ? const Color(0xFF341C01)
                                : const Color(0xFF150D4E),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(builder: (context) {
                        return Container();
                      }));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/pixel.png'),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'subscribe'.i18n,
                            style: TextStyle(
                              color: isGold
                                  ? const Color(0xFF341C01)
                                  : const Color(0xFF150D4E),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
