import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "custom_app_icon": "Custom App Icon",
          "app_icons": "App Icons",
          "basic": "Basic",
          "seasonal": "Seasonal",
          "special": "Special",
          "other": "Other",
        },
        "hu_hu": {
          "custom_app_icon": "Alkalmazásikon",
          "app_icons": "Alkalmazásikonok",
          "basic": "Egyszerű",
          "seasonal": "Szezonális",
          "special": "Különleges",
          "other": "Egyéb",
        },
        "de_de": {
          "custom_app_icon": "App-Symbol",
          "app_icons": "App-Symbole",
          "basic": "Basic",
          "seasonal": "Saisonal",
          "special": "Besonders",
          "other": "Andere",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
