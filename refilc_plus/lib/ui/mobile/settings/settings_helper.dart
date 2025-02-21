import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:refilc/api/providers/database_provider.dart';
import 'package:refilc/api/providers/user_provider.dart';
import 'package:refilc/models/settings.dart';
import 'package:refilc/ui/widgets/grade/grade_tile.dart';
import 'package:refilc_kreta_api/models/grade.dart';

class GradeRarityTextSetting extends StatefulWidget {
  const GradeRarityTextSetting({
    super.key,
    required this.title,
    required this.cancel,
    required this.done,
    required this.defaultRarities,
  });

  final String title;
  final String cancel;
  final String done;
  final List<String> defaultRarities;

  @override
  GradeRarityTextSettingState createState() => GradeRarityTextSettingState();
}

class GradeRarityTextSettingState extends State<GradeRarityTextSetting> {
  late SettingsProvider settings;
  late DatabaseProvider db;
  late UserProvider user;

  final _rarityText = TextEditingController();

  @override
  void initState() {
    super.initState();
    settings = Provider.of<SettingsProvider>(context, listen: false);
    db = Provider.of<DatabaseProvider>(context, listen: false);
    user = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            return ClipOval(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () async {
                    showRenameDialog(
                      title: widget.title,
                      cancel: widget.cancel,
                      done: widget.done,
                      rarities:
                          await db.userQuery.getGradeRarities(userId: user.id!),
                      gradeIndex: (index + 1).toString(),
                      defaultRarities: widget.defaultRarities,
                    );
                  },
                  child: GradeValueWidget(GradeValue(index + 1, "", "", 0),
                      fill: true, size: 36.0),
                ),
              ),
            );
          }),
        ),
      ),
    ]);
  }

  void showRenameDialog(
      {required String title,
      required String cancel,
      required String done,
      required Map<String, String> rarities,
      required String gradeIndex,
      required List<String> defaultRarities,
      required}) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setS) {
        String? rr = rarities[gradeIndex];
        rr ??= '';

        _rarityText.text = rr;

        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _rarityText,
            autofocus: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(defaultRarities[int.parse(gradeIndex) - 1]),
              suffixIcon: IconButton(
                icon: const Icon(FeatherIcons.x),
                onPressed: () {
                  setState(() {
                    _rarityText.clear();
                  });
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                cancel,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
            TextButton(
              child: Text(
                done,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                rarities[gradeIndex] = _rarityText.text;

                Provider.of<DatabaseProvider>(context, listen: false)
                    .userStore
                    .storeGradeRarities(rarities, userId: user.id!);

                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      }),
    ).then((val) {
      _rarityText.clear();
    });
  }
}
