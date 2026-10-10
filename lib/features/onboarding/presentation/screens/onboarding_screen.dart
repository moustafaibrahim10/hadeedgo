import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/onboarding_indicator.dart';

enum _OnboardingContent { welcome, compare, tracking }

class _OnboardingItem {
  final String image;
  final _OnboardingContent content;
  final bool showIcon;

  const _OnboardingItem({
    required this.image,
    required this.content,
    this.showIcon = false,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _onboardingData = const [
    _OnboardingItem(
      image: 'assets/photos/png/onboarding1.png',
      content: _OnboardingContent.welcome,
    ),
    _OnboardingItem(
      image: 'assets/photos/png/onboarding2.png',
      content: _OnboardingContent.compare,
      showIcon: true,
    ),
    _OnboardingItem(
      image: 'assets/photos/png/onboarding3.png',
      content: _OnboardingContent.tracking,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(data.image, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    l10n.skip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 34),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.75),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_onboardingData[_currentPage].showIcon) ...[
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.query_stats,
                              color: AppColors.primaryContainer,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        Text(
                          _title(l10n, _onboardingData[_currentPage].content),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF161C22),
                            fontFamily: 'Tajawal',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _subtitle(
                            l10n,
                            _onboardingData[_currentPage].content,
                          ),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF565E74),
                            fontFamily: 'Tajawal',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        OnboardingIndicator(
                          itemCount: _onboardingData.length,
                          currentIndex: _currentPage,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryContainer,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.primaryContainer
                                  .withValues(alpha: 0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _onboardingData.length - 1
                                      ? l10n.getStarted
                                      : l10n.next,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_ios),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _title(AppLocalizations l10n, _OnboardingContent content) {
    return switch (content) {
      _OnboardingContent.welcome => l10n.onboardingWelcomeTitle,
      _OnboardingContent.compare => l10n.onboardingCompareTitle,
      _OnboardingContent.tracking => l10n.onboardingTrackingTitle,
    };
  }

  String _subtitle(AppLocalizations l10n, _OnboardingContent content) {
    return switch (content) {
      _OnboardingContent.welcome => l10n.onboardingWelcomeSubtitle,
      _OnboardingContent.compare => l10n.onboardingCompareSubtitle,
      _OnboardingContent.tracking => l10n.onboardingTrackingSubtitle,
    };
  }
}
