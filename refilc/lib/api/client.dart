/*
    Firka legacy (formely "refilc"), the unofficial client for e-Kréta
    Copyright (C) 2025  Firka team (QwIT development)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:refilc/models/config.dart';
import 'package:refilc/models/news.dart';
import 'package:refilc/models/release.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/models/shared_theme.dart';
import 'package:refilc_kreta_api/models/school.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class FilcAPI {
  // base url
  static const baseUrl = "https://firka.app/api/v1";

  // unused schools list
  static const schoolList = "0.0.0.0";

  // news endpoint
  static const news = "$baseUrl/news/";

  // analytics endpoint
  static const config = "$baseUrl/config/";

  // bug report endpoint, always gets sent, no matter if the user pressed the button or no
  static const reportApi = "$baseUrl/crash/legacy";

  // updates path to github
  static const releases =
      "https://api.github.com/repos/QwIT-Development/app-legacy/releases";

  // theme sharing api
  static const themeShare = "$baseUrl/theme/";
  static const themeGet = "$baseUrl/theme/";
  static const allThemes = "$themeGet/theme/";
  static const themeByID = "$themeGet/theme/";

  // i don't know why it is separated
  static const gradeColorsShare = "$baseUrl/theme/color/";
  static const gradeColorsGet = "$baseUrl/theme/color/";
  static const allGradeColors = "$gradeColorsGet/";
  static const gradeColorsByID = "$gradeColorsGet/";

  static Future<bool> checkConnectivity() async =>
      (await Connectivity().checkConnectivity())[0] != ConnectivityResult.none;

  // nem tudom nem vazar-e senkit se, de mar ertelmetlen ez
  static Future<List<School>?> getSchools() async {
    try {
      http.Response res = await http.get(Uri.parse(schoolList));

      if (res.statusCode == 200) {
        List<School> schools = (jsonDecode(res.body) as List)
            .cast<Map>()
            .map((json) => School.fromJson(json))
            .toList();
        return schools;
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSchools: $error $stacktrace");
    }
    return null;
  }

  static Future<Config?> getConfig(SettingsProvider settings) async {
    final userAgent = SettingsProvider.defaultSettings().config.userAgent;

    Map<String, String> headers = {
      "x-filc-id": settings.xFilcId,
      "user-agent": userAgent,
      // platform things
      "rf-platform":
          settings.analyticsEnabled ? Platform.operatingSystem : "unknown",
      "rf-platform-version": settings.analyticsEnabled
          ? Platform.operatingSystemVersion
          : "unknown",
      "rf-app-version":
          const String.fromEnvironment("APPVER", defaultValue: "?"),
      "rf-uinid": settings.xFilcId,
    };

    log("[CONFIG] x-filc-id: \"${settings.xFilcId}\"");
    log("[CONFIG] user-agent: \"$userAgent\"");

    try {
      http.Response res = await http.get(Uri.parse(config), headers: headers);

      if (res.statusCode == 200) {
        if (kDebugMode) {
          print(jsonDecode(res.body));
        }
        return Config.fromJson(jsonDecode(res.body));
      } else if (res.statusCode == 429) {
        res = await http.get(Uri.parse(config));
        if (res.statusCode == 200) return Config.fromJson(jsonDecode(res.body));
      }
      throw "HTTP ${res.statusCode}: ${res.body}";
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getConfig: $error $stacktrace");
    }
    return null;
  }

  static Future<List<News>?> getNews() async {
    try {
      http.Response res = await http.get(Uri.parse(news));

      if (res.statusCode == 200) {
        String utf8Body = utf8.decode(res.bodyBytes);
        return (jsonDecode(utf8Body) as List)
            .cast<Map>()
            .map((e) => News.fromJson(e))
            .toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getNews: $error $stacktrace");
    }
    return null;
  }

  static Future<List<Release>?> getReleases() async {
    try {
      http.Response res = await http.get(Uri.parse(releases));

      if (res.statusCode == 200) {
        return (jsonDecode(utf8.decode(res.bodyBytes)) as List)
            .cast<Map>()
            .map((e) => Release.fromJson(e))
            .toList();
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getReleases: $error $stacktrace");
    }
    return null;
  }

  static Future<http.StreamedResponse?> downloadRelease(
      ReleaseDownload release) {
    try {
      var client = http.Client();
      var request = http.Request('GET', Uri.parse(release.url));
      return client.send(request);
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.downloadRelease: $error $stacktrace");
      return Future.value(null);
    }
  }

  static Future<void> sendReport(ErrorReport report) async {
    try {
      Map body = {
        "os": report.os,
        "version": report.version,
        "error": report.error,
        "stack_trace": report.stack,
      };

      var client = http.Client();

      http.Response res = await client.post(
        Uri.parse(reportApi),
        body: body,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (res.statusCode != 200) {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.sendReport: $error $stacktrace");
    }
  }

  // sharing
  static Future<int> addSharedTheme(SharedTheme theme) async {
    try {
      theme.json.remove('json');
      theme.json['is_public'] = theme.isPublic.toString();
      theme.json['background_color'] = theme.backgroundColor.value.toString();
      theme.json['panels_color'] = theme.panelsColor.value.toString();
      theme.json['accent_color'] = theme.accentColor.value.toString();
      theme.json['icon_color'] = theme.iconColor.value.toString();
      theme.json['shadow_effect'] = theme.shadowEffect.toString();

      // set theme mode or remove if unneccessary
      switch (theme.themeMode) {
        case ThemeMode.dark:
          theme.json['theme_mode'] = 'dark';
          break;
        case ThemeMode.light:
          theme.json['theme_mode'] = 'light';
          break;
        default:
          theme.json.remove('theme_mode');
          break;
      }

      // set linked grade colors
      theme.json['grade_colors_id'] = theme.gradeColors.id;

      http.Response res = await http.post(
        Uri.parse(themeShare),
        body: theme.json,
        // why tf would you urlencode a json, u want to parse it 2 times or what?
        headers: {'Content-Type': 'application/json'},
      );

      // if (res.statusCode != 201) {
      //   throw "HTTP ${res.statusCode}: ${res.body}";
      // }

      if (res.statusCode == 201) {
        log('Shared theme successfully with ID: ${theme.id}');
      }

      return res.statusCode;
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.addSharedTheme: $error $stacktrace");

      return 696;
    }
  }

  static Future<Map?> getSharedTheme(String id) async {
    try {
      http.Response res = await http.get(Uri.parse(themeByID + id));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map);
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSharedTheme: $error $stacktrace");
    }
    return null;
  }

  static Future<List?> getAllSharedThemes(int count) async {
    try {
      http.Response res = await http.get(Uri.parse(allThemes));

      if (res.statusCode == 200) {
        return (jsonDecode(utf8.decode(res.bodyBytes)) as List);
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getAllSharedThemes: $error $stacktrace");
      // return empty array if error
      return [];
    }
  }

  static Future<int> addSharedGradeColors(SharedGradeColors gradeColors) async {
    try {
      gradeColors.json.remove('json');
      gradeColors.json['is_public'] = gradeColors.isPublic.toString();
      gradeColors.json['five_color'] = gradeColors.fiveColor.value.toString();
      gradeColors.json['four_color'] = gradeColors.fourColor.value.toString();
      gradeColors.json['three_color'] = gradeColors.threeColor.value.toString();
      gradeColors.json['two_color'] = gradeColors.twoColor.value.toString();
      gradeColors.json['one_color'] = gradeColors.oneColor.value.toString();

      http.Response res = await http.post(
        Uri.parse(gradeColorsShare),
        body: gradeColors.json,
        headers: {'Content-Type': 'application/json'},
      );

      // if (res.statusCode != 201) {
      //   throw "HTTP ${res.statusCode}: ${res.body}";
      // }

      if (res.statusCode == 201) {
        log('Shared grade colors successfully with ID: ${gradeColors.id}');
      }

      return res.statusCode;
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.addSharedGradeColors: $error $stacktrace");

      return 696;
    }
  }

  static Future<Map?> getSharedGradeColors(String id) async {
    try {
      http.Response res = await http.get(Uri.parse(gradeColorsByID + id));

      if (res.statusCode == 200) {
        return (jsonDecode(res.body) as Map);
      } else if (res.statusCode == 404) {
        return {"public_id": ""};
      } else {
        throw "HTTP ${res.statusCode}: ${res.body}";
      }
    } on Exception catch (error, stacktrace) {
      log("ERROR: FilcAPI.getSharedGradeColors: $error $stacktrace");
    }
    return null;
  }
}

class ErrorReport {
  String stack;
  String os;
  String version;
  String error;

  ErrorReport({
    required this.stack,
    required this.os,
    required this.version,
    required this.error,
  });
}
