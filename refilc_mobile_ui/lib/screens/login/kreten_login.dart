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

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KretenLoginWidget extends StatefulWidget {
  const KretenLoginWidget({super.key, required this.onLogin});

  // final String selectedSchool;
  final void Function(String code) onLogin;

  @override
  State<KretenLoginWidget> createState() => _KretenLoginWidgetState();
}

class _KretenLoginWidgetState extends State<KretenLoginWidget>
    with TickerProviderStateMixin {
  late final WebViewController controller;
  late AnimationController _animationController;
  var loadingPercentage = 0;
  var currentUrl = '';
  bool _hasFadedIn = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _hasTimedOut = false;
  Timer? _timeoutTimer;

  static const _loginUrl =
      'https://idp.e-kreta.hu/connect/authorize?prompt=login&nonce=wylCrqT4oN6PPgQn2yQB0euKei9nJeZ6_ffJ-VpSKZU&response_type=code&code_challenge_method=S256&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&code_challenge=HByZRRnPGb-Ko_wTI7ibIba1HQ6lor0ws4bcgReuYSQ&redirect_uri=https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect&client_id=kreta-ellenorzo-student-mobile-ios&state=refilc_student_mobile';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, // Use the TickerProviderStateMixin
      duration: const Duration(milliseconds: 350),
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (n) async {
          if (n.url.startsWith('https://mobil.e-kreta.hu')) {
            setState(() {
              loadingPercentage = 0;
              currentUrl = n.url;
            });

            // final String instituteCode = widget.selectedSchool;
            // if (!n.url.startsWith(
            //     'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=')) {
            //   return;
            // }

            List<String> requiredThings = n.url
                .replaceAll(
                    'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=',
                    '')
                .replaceAll(
                    '&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&state=refilc_student_mobile&session_state=',
                    ':')
                .split(':');

            String code = requiredThings[0];
            // String sessionState = requiredThings[1];

            widget.onLogin(code);
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   Navigator.of(context).pop();
            // });
            // Navigator.of(context).pop();

            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
        onPageStarted: (url) async {
          // setState(() {
          //   loadingPercentage = 0;
          //   currentUrl = url;
          // });

          // // final String instituteCode = widget.selectedSchool;
          // if (!url.startsWith(
          //     'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=')) {
          //   return;
          // }

          // List<String> requiredThings = url
          //     .replaceAll(
          //         'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=',
          //         '')
          //     .replaceAll(
          //         '&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&state=refilc_student_mobile&session_state=',
          //         ':')
          //     .split(':');

          // String code = requiredThings[0];
          // // String sessionState = requiredThings[1];

          // widget.onLogin(code);
          // // Future.delayed(const Duration(milliseconds: 500), () {
          // //   Navigator.of(context).pop();
          // // });
          // // Navigator.of(context).pop();
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          _timeoutTimer?.cancel();
          setState(() {
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (error) {
          _timeoutTimer?.cancel();
          setState(() {
            _hasError = true;
            _errorMessage = error.description;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(_loginUrl), // &institute_code=${widget.selectedSchool}
      );

    _startTimeoutTimer();
  }

  void _startTimeoutTimer() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (mounted && loadingPercentage < 100 && !_hasError) {
        setState(() {
          _hasTimedOut = true;
        });
      }
    });
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _hasTimedOut = false;
      loadingPercentage = 0;
      _hasFadedIn = false;
    });
    _animationController.reset();
    controller.loadRequest(Uri.parse(_loginUrl));
    _startTimeoutTimer();
  }

  // Future<void> loadLoginUrl() async {
  //   String nonceStr = await Provider.of<KretaClient>(context, listen: false)
  //         .getAPI(KretaAPI.nonce, json: false);

  //     Nonce nonce = getNonce(nonceStr, );
  // }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    // Step 3: Dispose of the animation controller
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error UI if there was a web resource error or a timeout
    if (_hasError || _hasTimedOut) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'A bejelentkezesi oldal nem toltheto be',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Probald ujra'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Vissza'),
              ),
            ],
          ),
        ),
      );
    }

    // Trigger the fade-in animation only once when loading reaches 100%
    if (loadingPercentage == 100 && !_hasFadedIn) {
      _animationController.forward(); // Play the animation
      _hasFadedIn =
          true; // Set the flag to true, so the animation is not replayed
    }

    return Stack(
      children: [
        // Webview that will be displayed only when the loading is 100%
        if (loadingPercentage == 100)
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeIn,
              ),
            ),
            child: WebViewWidget(
              controller: controller,
            ),
          ),

        // Show the CircularProgressIndicator while loading is not 100%
        if (loadingPercentage < 100)
          Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: loadingPercentage / 100.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, double value, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value, // Smoothly animates the progress
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
