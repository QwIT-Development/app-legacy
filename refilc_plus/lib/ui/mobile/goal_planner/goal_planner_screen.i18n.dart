import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "goal_planner_title": "Goal Planning",
          "set_a_goal": "Your Goal",
          "select_subject": "Subject",
          "pick_route": "Pick a Route",
          "track_it": "Track it!",
          "recommended": "Recommended",
          "fastest": "Fastest",
          "unsolvable": "Unsolvable :(",
          "unreachable": "Unreachable :(",
          "reached": "Already reached! :D",
          // new plan popup
          "goalplan_title": "Goal Planning",
          "goalplan_subtitle": "Enter the average you want to achieve!",
          "goalplan_plans_title": "Choose the route",
          "goalplan_plans_subtitle":
              "You can achieve your goal with these tickets, choose one that you like the most! You can change this later.",
          "show_my_ways": "Show me my options!",
        },
        "hu_hu": {
          "goal_planner_title": "Cél követés",
          "set_a_goal": "Kitűzött cél",
          "select_subject": "Tantárgy",
          "pick_route": "Válassz egy utat",
          "track_it": "Követés!",
          "recommended": "Ajánlott",
          "fastest": "Leggyorsabb",
          "unsolvable": "Megoldhatatlan :(",
          "unreachable": "Elérhetetlen :(",
          "reached": "Már elérted! :D",
          // new plan popup
          "goalplan_title": "Cél kitűzése",
          "goalplan_subtitle": "Add meg az elérni kívánt átlagot!",
          "goalplan_plans_title": "Válaszd ki az utat",
          "goalplan_plans_subtitle":
              "Ezekkel a jegyekkel érheted el a célodat, válassz egyet, ami a legjobban tetszik! Ezt később változtathatod.",
          "show_my_ways": "Mutasd a lehetőségeimet!",
        },
        "de_de": {
          "goal_planner_title": "Zielplanung",
          "set_a_goal": "Dein Ziel",
          "select_subject": "Thema",
          "pick_route": "Wähle einen Weg",
          "track_it": "Verfolge es!",
          "recommended": "Empfohlen",
          "fastest": "Am schnellsten",
          "unsolvable": "Unlösbar :(",
          "unreachable": "Unerreichbar :(",
          "reached": "Bereits erreicht! :D",
          // new plan popup
          "goalplan_title": "Zielplanung",
          "goalplan_subtitle":
              "Geben Sie den Durchschnitt ein, den Sie erreichen möchten!",
          "goalplan_plans_title": "Wählen Sie die Route",
          "goalplan_plans_subtitle":
              "Sie können Ihr Ziel mit diesen Tickets erreichen. Wählen Sie eines aus, das Ihnen am besten gefällt! Sie können dies später ändern.",
          "show_my_ways": "Zeigen Sie mir meine Optionen!",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
