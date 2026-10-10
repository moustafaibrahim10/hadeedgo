import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class SupplierAlternativesScreen extends StatelessWidget {
  const SupplierAlternativesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent for modal effect
      body: Stack(
        children: [
          // Blurred background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
              ),
            ),
          ),

          // Centered Modal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 450),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'المصنع الحالي غير قادر على تلبية الكمية',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'عذراً، المنتج الذي طلبته غير متوفر بالكمية المطلوبة حالياً.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.onSurfaceVariant,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Out of Stock Product
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.matrix([
                                      0.2126,
                                      0.7152,
                                      0.0722,
                                      0,
                                      0,
                                      0.2126,
                                      0.7152,
                                      0.0722,
                                      0,
                                      0,
                                      0.2126,
                                      0.7152,
                                      0.0722,
                                      0,
                                      0,
                                      0,
                                      0,
                                      0,
                                      1,
                                      0,
                                    ]),
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                        'assets/photos/png/onboarding3.png', // Temporary placeholder
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: AppColors.surface.withValues(
                                    alpha: 0.8,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.block,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'حديد عز - ١٢ مم',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                    fontFamily: 'Tajawal',
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColors.error,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'غير متوفر حالياً',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'الكمية: ٥٠ طن',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.onSurfaceVariant,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: AppColors.surfaceVariant),
                    ),

                    // Recommendation Section
                    const Text(
                      'نقترح عليك البدء مع مورد بديل موثوق بنفس المواصفات:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 16),

                    // Alternative Mill Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -16,
                            top: -16,
                            bottom: -16,
                            child: Container(
                              width: 4,
                              color: AppColors.primary,
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHigh,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.outlineVariant
                                            .withValues(alpha: 0.2),
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/photos/png/onboarding1.png', // Temporary placeholder
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Text(
                                              'حديد العشري',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.onSurface,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.verified,
                                              color: AppColors.primary,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: AppColors.primaryContainer,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '٤.٨ (١٢٠ تقييم)',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.tertiary,
                                                fontFamily: 'Tajawal',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'نفس المواصفات',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(color: AppColors.surfaceVariant),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'السعر للطن',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      const Text(
                                        '٤٨,٥٠٠ ج.م',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'جاهز للتسليم',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.onSurfaceVariant,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      Text(
                                        'خلال ٢٤ ساعة',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.green[700],
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تبديل المورد والمتابعة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20), // RTL arrow
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text(
                        'إلغاء الطلب',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
