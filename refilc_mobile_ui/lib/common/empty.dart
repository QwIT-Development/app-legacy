import 'dart:math';

import 'package:refilc/theme/colors/colors.dart';
import 'package:flutter/material.dart';

List<String> faces = [
  "(* ^ ω ^)",
  "(´ ∀ *)",
  "(o^▽^o)",
  "(⌒▽⌒)☆",
  "(￣ω￣)",
  "(◕ω◕)",
  "(⌒ω⌒)",
  "(☆ω☆)",
  "(^ヮ^)/",
  "(^ᗢ^)",
  "(≧ω≦)",
  "(/ω＼)",
  "(//▽//)",
  "ᕕ( ᐛ )ᕗ",
  "¯\\(ツ)/¯",
  "(￣▽￣)",
  "(ᓀ ᓀ)",
  "(・・?",
  "(・ω・)ﾉ",
  "(=^･ω･^=)",
  "( =ω= )",
  "(◕ω◕✿)",
  "(✿◠ω◠)"
];

class Empty extends StatelessWidget {
  const Empty({
    super.key,
    this.subtitle,
    this.alwaysRandom = false
  });

  final String? subtitle;
  final bool alwaysRandom;

  @override
  Widget build(BuildContext context) {
    int index = alwaysRandom
    ? Random().nextInt(faces.length)
    : Random(DateTime.now().minute).nextInt(faces.length);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text.rich(
          TextSpan(
            text: faces[index],
            style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w500,
                color: AppColors.of(context).text.withValues(alpha: .75)),
            children: subtitle != null
                ? [
                    TextSpan(
                        text: "\n${subtitle!}",
                        style: TextStyle(
                            fontSize: 18.0,
                            height: 2.0,
                            color: AppColors.of(context)
                                .text
                                .withValues(alpha: .5)))
                  ]
                : [],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
