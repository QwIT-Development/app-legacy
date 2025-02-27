import 'package:flutter/material.dart';

enum AccentColor {
  filc,
  blue,
  green,
  lime,
  yellow,
  orange,
  red,
  pink,
  purple,
  none,
  ogfilc,
  adaptive,
  custom
}

Map<AccentColor, Color> accentColorMap = {
  AccentColor.filc: const Color(0xFFA7DC22),
  AccentColor.blue: Colors.blue.shade300,
  AccentColor.green: Colors.green.shade400,
  AccentColor.lime: Colors.lightGreen.shade400,
  AccentColor.yellow: Colors.orange.shade300,
  AccentColor.orange: Colors.deepOrange.shade300,
  AccentColor.red: Colors.red.shade300,
  AccentColor.pink: Colors.pink.shade300,
  AccentColor.purple: Colors.purple.shade300,
  //AccentColor.none: Colors.black,
  AccentColor.ogfilc: const Color(0xff20AC9B),
  AccentColor.adaptive: const Color(0xFFA7DC22),
  AccentColor.custom: const Color(0xFFA7DC22),
};

// new v5 things
Map<AccentColor, Color> lightPrimary = {
  AccentColor.filc: const Color(0xFF394C0A), //
};
Map<AccentColor, Color> lightSecondary = {
  AccentColor.filc: const Color(0xCC394C0A), //
};
Map<AccentColor, Color> lightTeritary = {
  AccentColor.filc: const Color(0x80394C0A), //
};
Map<AccentColor, Color> lightIcon = {
  AccentColor.filc: const Color(0xFF0A2456),
};
Map<AccentColor, Color> lightAccent = {
  AccentColor.filc: const Color(0xFFA7DC22), //
};
Map<AccentColor, Color> lightBgDarkened = {
  AccentColor.filc: const Color(0xFFFAFFF0), //
};
Map<AccentColor, Color> lightBtnSecStrk = {
  AccentColor.filc: const Color(0xFFCEDBF5),
};
Map<AccentColor, Color> lightBg = {
  AccentColor.filc: const Color(0xFFF3FBDE), //
};
Map<AccentColor, Color> lightCard = {
  AccentColor.filc: const Color(0xFFF3FBDE), //
};
Map<AccentColor, Color> lightBtnSec = {
  AccentColor.filc: const Color(0xFFFEFFFD), //
};

Map<AccentColor, Color> darkPrimary = {
  AccentColor.filc: const Color(0xFFEAF7CC), //
};
Map<AccentColor, Color> darkSecondary = {
  AccentColor.filc: const Color(0xB3EAF7CC), //
};
Map<AccentColor, Color> darkTeritary = {
  AccentColor.filc: const Color(0x80EAF7CC), //
};
Map<AccentColor, Color> darkIcon = {
  AccentColor.filc: const Color(0xFFBAD1FF),
};
Map<AccentColor, Color> darkAccent = {
  AccentColor.filc: const Color(0xFFA7DC22), //
};
Map<AccentColor, Color> darkBgDarkened = {
  AccentColor.filc: const Color(0xFF0D1202), //
};
Map<AccentColor, Color> darkBtnSecStrk = {
  AccentColor.filc: const Color(0xFF1C2230),
};
Map<AccentColor, Color> darkBg = {
  AccentColor.filc: const Color(0xFF141905), //
};
Map<AccentColor, Color> darkCard = {
  AccentColor.filc: const Color(0xFF141905), //
};
Map<AccentColor, Color> darkBtnSec = {
  AccentColor.filc: const Color(0xFF20290B), //
};
