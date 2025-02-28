import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ActivationDashboard extends StatefulWidget {
  const ActivationDashboard({super.key});

  @override
  State<ActivationDashboard> createState() => _ActivationDashboardState();
}

class _ActivationDashboardState extends State<ActivationDashboard> {
  bool manualActivationLoading = false;

  Future<void> onManualActivation() async {
    final data = await Clipboard.getData("text/plain");
    if (data == null || data.text == null || data.text == "") {
      return;
    }
    setState(() {
      manualActivationLoading = true;
    });
    final result =
        // ignore: use_build_context_synchronously
        await context
            .read<PlusProvider>()
            .auth
            .finishAuth(data.text!);
    setState(() {
      manualActivationLoading = false;
    });

    if (!result && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Sikertelen aktiválás. Kérlek próbáld újra később!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Center(
            child: Image.asset(
              "assets/icons/ic_rounded.png",
              height: 64.0,
            ),
          ),
          const SizedBox(height: 32.0),
          const Text(
            "Válassz fizetési módot, majd folytasd a fizetést a Stripe felületén, hogy aktiváld az előfizetésed.",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
          ),
          // const SizedBox(height: 12.0),
          // Card(
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(14.0)),
          //   child: const Padding(
          //     padding: EdgeInsets.all(16.0),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Row(
          //           children: [
          //             Icon(FeatherIcons.alertTriangle,
          //                 size: 20.0, color: Colors.orange),
          //             SizedBox(width: 12.0),
          //             Text(
          //               "Figyelem!",
          //               style: TextStyle(
          //                   fontSize: 18.0, fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //         SizedBox(height: 6.0),
          //         Text(
          //           "Az automatikus visszairányítás az alkalmazásba nem mindig működik. Ebben az esetben kérjük nyomd meg lent a \"Manuális aktiválás\" gombot!",
          //           style: TextStyle(fontSize: 16.0),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FeatherIcons.alertTriangle,
                          size: 20.0, color: Colors.orange),
                      SizedBox(width: 12.0),
                      Text(
                        "Figyelem!",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Text(
                    "Az aktiválás azonnal történik, amint kifizetted a szolgáltatás díját. A szolgáltatás automatikusan megújul, lemondásra a beállításokban lesz lehetőséget.",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ha fizetés után a Stripe nem irányít vissza az alkalmazásba automatikusan, aktiválhatod a támogatásod a munkamenet azonosítóval, melyet kimásolhatsz a hibás URL \"session_id\" paraméteréből.",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6.0),
                  Center(
                    child: TextButton.icon(
                      onPressed: onManualActivation,
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.secondary),
                        overlayColor: WidgetStatePropertyAll(Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(.1)),
                      ),
                      icon: manualActivationLoading
                          ? const SizedBox(
                              height: 16.0,
                              width: 16.0,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(FeatherIcons.key, size: 20.0),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Aktiválás azonosítóval",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  foregroundColor:
                      WidgetStatePropertyAll(AppColors.of(context).text),
                  overlayColor: WidgetStatePropertyAll(
                      AppColors.of(context).text.withOpacity(.1)),
                ),
                icon: const Icon(FeatherIcons.arrowLeft, size: 20.0),
                label: const Text(
                  "Vissza",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
