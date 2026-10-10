import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/bouncing_dot.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.97,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _finishSplash();
  }

  Future<void> _finishSplash() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state.status == AuthStatus.loading) {
      await authCubit.stream.firstWhere(
        (state) => state.status != AuthStatus.loading,
      );
    }
    if (!mounted) return;

    context.go(
      authCubit.state.status == AuthStatus.authenticated
          ? '/home'
          : '/onboarding',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/photos/png/logo.png',
                        width: 256,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 48),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BouncingDot(delay: 0),
                          SizedBox(width: 10),
                          BouncingDot(delay: 0.15),
                          SizedBox(width: 10),
                          BouncingDot(delay: 0.3),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.splashTagline,
                        style: TextStyle(
                          color: Color(0xFF5A4136),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
