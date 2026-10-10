import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const OnboardingIndicator({
    required this.itemCount,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primaryContainer
                : const Color(0xFFBEC6E0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
