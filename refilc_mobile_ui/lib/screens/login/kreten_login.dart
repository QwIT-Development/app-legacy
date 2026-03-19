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
  const KretenLoginWidget({super.key, required this.onLogin, this.onDemoMode});

  // final String selectedSchool;
  final void Function(String code) onLogin;
  final VoidCallback? onDemoMode;

  @override
  State<KretenLoginWidget> createState() => _KretenLoginWidgetState();
}

class _KretenLoginWidgetState extends State<KretenLoginWidget>
    with TickerProviderStateMixin {
  late final WebViewController controller;
  late AnimationController _animationController;
  var loadingPercentage = 0;
  var currentUrl = '';
  bool _initialPageLoaded = false;
  bool _hasFadedIn = false;
  bool _hasError = false;
  bool _hasTimedOut = false;
  Timer? _timeoutTimer;
  int _autoRetryCount = 0;
  static const int _maxAutoRetries = 3;
  bool _hasLoadedOnce = false;

  static const _loginUrl =
      'https://idp.e-kreta.hu/connect/authorize?prompt=login&nonce=wylCrqT4oN6PPgQn2yQB0euKei9nJeZ6_ffJ-VpSKZU&response_type=code&code_challenge_method=S256&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&code_challenge=HByZRRnPGb-Ko_wTI7ibIba1HQ6lor0ws4bcgReuYSQ&redirect_uri=https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect&client_id=kreta-ellenorzo-student-mobile-ios&state=refilc_student_mobile';

  static final Uri _redirectUri = Uri.parse(
    'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect',
  );

  bool _isRedirectUri(Uri uri) {
    return uri.scheme == _redirectUri.scheme &&
        uri.host == _redirectUri.host &&
        uri.path == _redirectUri.path;
  }

  bool _shouldIgnoreError(WebResourceError error) {
    if (error.isForMainFrame == false) {
      return true;
    }

    final String description = error.description.toLowerCase();
    return error.errorCode == -999 ||
        description.contains('cancelled') ||
        description.contains('canceled') ||
        description.contains('frame load interrupted');
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this, // Use the TickerProviderStateMixin
      duration: const Duration(milliseconds: 350),
    );

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1')
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (n) async {
          final Uri? uri = Uri.tryParse(n.url);
          if (uri != null && _isRedirectUri(uri)) {
            final String? code = uri.queryParameters['code'];
            if (code != null && code.isNotEmpty) {
              _timeoutTimer?.cancel();
              widget.onLogin(code);
              return NavigationDecision.prevent;
            }
          }

          return NavigationDecision.navigate;
        },
        onPageStarted: (url) async {
          if (!mounted) return;

          setState(() {
            currentUrl = url;
            _hasError = false;

            _hasTimedOut = false;

            if (!_initialPageLoaded) {
              loadingPercentage = 0;
            }
          });
        },
        onProgress: (progress) {
          if (!mounted) return;

          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          _timeoutTimer?.cancel();

          if (!mounted) return;

          _autoRetryCount = 0;
          _hasLoadedOnce = true;
          setState(() {
            currentUrl = url;
            _initialPageLoaded = true;
            _hasError = false;
            _hasTimedOut = false;
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (error) {
          if (_shouldIgnoreError(error)) {
            return;
          }

          _timeoutTimer?.cancel();

          if (!mounted) return;

          // Auto-retry on first errors before showing the error UI,
          // to handle transient network issues on initial load.
          if (!_hasLoadedOnce && _autoRetryCount < _maxAutoRetries) {
            _autoRetryCount++;
            Future.delayed(Duration(seconds: _autoRetryCount), () {
              if (mounted) _retryLoad();
            });
            return;
          }

          // If demo mode is available, auto-launch it instead of
          // showing an error UI (e.g. when outside Hungary).
          if (widget.onDemoMode != null) {
            widget.onDemoMode!();
            return;
          }

          setState(() {
            _hasError = true;
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
      if (mounted && !_initialPageLoaded && !_hasError) {
        if (widget.onDemoMode != null) {
          widget.onDemoMode!();
          return;
        }
        setState(() {
          _hasTimedOut = true;
        });
      }
    });
  }

  void _retryLoad() {
    setState(() {
      _hasError = false;
      _hasTimedOut = false;
      _initialPageLoaded = false;
      loadingPercentage = 0;
    });
    controller.loadRequest(Uri.parse(_loginUrl));
    _startTimeoutTimer();
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _hasTimedOut = false;
      _initialPageLoaded = false;
      loadingPercentage = 0;
      _hasFadedIn = false;
    });
    _autoRetryCount = 0;
    _hasLoadedOnce = false;
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
                Icons.wifi_off_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'A bejelentkezési oldal nem érhető el',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Az e-KRÉTA bejelentkezés csak magyarországi hálózatról érhető el. Kérjük, ellenőrizd az internetkapcsolatod.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Próbáld újra'),
              ),
              if (widget.onDemoMode != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: widget.onDemoMode,
                  child: const Text('Kipróbálom fiók nélkül'),
                ),
              ],
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
    if (_initialPageLoaded && !_hasFadedIn) {
      _animationController.forward(); // Play the animation
      _hasFadedIn =
          true; // Set the flag to true, so the animation is not replayed
    }

    return Stack(
      children: [
        Positioned.fill(
          child: FadeTransition(
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
        ),
        if (!_initialPageLoaded)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: TweenAnimationBuilder(
                  tween:
                      Tween<double>(begin: 0, end: loadingPercentage / 100.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, double value, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: value == 0 ? null : value,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
