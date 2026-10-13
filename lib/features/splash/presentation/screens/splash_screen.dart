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
    with TickerProviderStateMixin {
  // Controller للدخول (مرة واحدة)
  late final AnimationController _introController;
  // Controller للنبض المستمر
  late final AnimationController _pulseController;
  // Controller للخروج
  late final AnimationController _exitController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _glowFade;
  late final Animation<double> _dotsFade;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _pulse;
  late final Animation<double> _exitFade;
  late final Animation<double> _exitScale;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    // اللوجو: fade + scale بنطة
    _logoFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );

    // الهالة
    _glowFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    );

    // الدوت
    _dotsFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.5, 0.75, curve: Curves.easeOut),
    );

    // التاج لاين: fade + slide up
    _taglineFade = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );
    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.65, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // نبض خفيف مستمر
    _pulse = Tween<double>(begin: 0.98, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // الخروج
    _exitFade = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitScale = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _introController.forward();
    _finishSplash();
  }

  Future<void> _finishSplash() async {
    await Future<void>.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    if (authCubit.state.status == AuthStatus.loading) {
      await authCubit.stream.firstWhere(
        (state) => state.status != AuthStatus.loading,
      );
    }
    if (!mounted) return;

    // أنيميشن الخروج قبل الانتقال
    await _exitController.forward();
    if (!mounted) return;

    context.go(
      authCubit.state.status == AuthStatus.authenticated
          ? '/home'
          : '/onboarding',
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _pulseController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _introController,
          _pulseController,
          _exitController,
        ]),
        builder: (context, _) {
          return FadeTransition(
            opacity: _exitFade,
            child: Transform.scale(
              scale: _exitScale.value,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // الهالة النابضة ورا اللوجو
                    Opacity(
                      opacity: _glowFade.value,
                      child: Transform.scale(
                        scale: _pulse.value * 1.1,
                        child: Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.18),
                                AppColors.primary.withValues(alpha: 0.06),
                                AppColors.primary.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 28),

                        // اللوجو
                        FadeTransition(
                          opacity: _logoFade,
                          child: Transform.scale(
                            scale: _logoScale.value * _pulse.value,
                            child: Image.asset(
                              'assets/photos/png/logo.png',
                              width: 256,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // الدوت
                        FadeTransition(
                          opacity: _dotsFade,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BouncingDot(delay: 0),
                              SizedBox(width: 10),
                              BouncingDot(delay: 0.15),
                              SizedBox(width: 10),
                              BouncingDot(delay: 0.3),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // التاج لاين
                        FadeTransition(
                          opacity: _taglineFade,
                          child: SlideTransition(
                            position: _taglineSlide,
                            child: Text(
                              l10n.splashTagline,
                              style: const TextStyle(
                                color: Color(0xFF5A4136),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
