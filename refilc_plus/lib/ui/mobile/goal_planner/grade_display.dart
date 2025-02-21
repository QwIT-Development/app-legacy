import 'package:refilc/models/settings.dart';
import 'package:refilc_plus/ui/mobile/goal_planner/goal_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GradeDisplay extends StatelessWidget {
  const GradeDisplay({super.key, required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gradeColor(grade, settings).withOpacity(.3),
      ),
      child: Center(
        child: Text(
          grade.toInt().toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: gradeColor(grade, settings),
          ),
        ),
      ),
    );
  }
}
