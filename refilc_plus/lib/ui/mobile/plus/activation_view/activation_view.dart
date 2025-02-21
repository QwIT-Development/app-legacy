import 'package:animations/animations.dart';
import 'package:refilc/theme/colors/colors.dart';
import 'package:refilc_plus/providers/plus_provider.dart';
import 'package:refilc_plus/ui/mobile/plus/activation_view/activation_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:refilc_plus/ui/mobile/plus/plus_things.i18n.dart';

class PremiumActivationView extends StatefulWidget {
  const PremiumActivationView({
    super.key,
    required this.product,
    required this.paymentProvider,
  });

  final String product;
  final String paymentProvider;

  @override
  State<PremiumActivationView> createState() => _PremiumActivationViewState();
}

class _PremiumActivationViewState extends State<PremiumActivationView>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  bool activated = false;

  @override
  void initState() {
    super.initState();
    context.read<PlusProvider>().auth.initAuth(
        product: widget.product, paymentProvider: widget.paymentProvider);

    animation =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final premium = context.watch<PlusProvider>();

    if (premium.hasPremium && !activated) {
      activated = true;
      animation.forward();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future.delayed(const Duration(seconds: 5)).then((value) {
          if (mounted) {
            // pop the anim
            Navigator.of(context).pop();
            // pop the plus view
            Navigator.of(context).pop();
            // show alert to save code
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "copy_code_asap".i18n,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.of(context).text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: AppColors.of(context).background,
              ),
            );
          }
        });
      });
    }

    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
            SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: Colors.transparent,
          child: child,
        ),
        child: premium.hasPremium
            ? Center(
                child: SizedBox(
                  width: 400,
                  child: Lottie.network(
                    "https://assets2.lottiefiles.com/packages/lf20_wkebwzpz.json",
                    controller: animation,
                  ),
                ),
              )
            : const SafeArea(child: ActivationDashboard()),
      ),
    );
  }
}
