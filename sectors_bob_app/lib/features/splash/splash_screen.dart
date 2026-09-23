import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_logo.dart';
import '../../services/providers.dart';

/// The opening screen. Shows the BOB logo on the teal canvas for a short beat,
/// then routes to onboarding, or straight to Home when a user is already
/// signed in on the mock.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), _goNext);
  }

  void _goNext() {
    if (!mounted) {
      return;
    }
    // Synchronous session read. The mock does not persist a session, so this is
    // null on a cold start and we route to onboarding. A real backend that
    // restores a session here would send a returning user straight to Home.
    final bool hasUser = ref.read(authServiceProvider).currentUser() != null;
    context.go(hasUser ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const AppLogo(size: 72),
            const SizedBox(height: 28),
            Text(
              'Analisis saham, dalam bahasa manusia',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textOnTeal2,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
