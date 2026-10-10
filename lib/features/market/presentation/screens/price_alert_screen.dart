import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class PriceAlertScreen extends StatelessWidget {
  const PriceAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent, // Background will be transparent to show previous screen if pushed as dialog/opaque=false
      body: Stack(
        children: [
          // Blurred background (if opaque route, this provides the blur)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: AppColors.onBackground.withValues(alpha: 0.2),
              ),
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      margin: const EdgeInsets.only(bottom: 24),
                    ),

                    // Icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.trending_up,
                          color: AppColors.error,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Text
                    const Text(
                      'تحديث في سعر السوق',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'تم تحديث سعر الطن من المصنع بناءً على تقلبات السوق الحالية.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.onSurfaceVariant,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Price Comparison Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.4,
                          ),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Old Price
                          Column(
                            children: [
                              const Text(
                                'السعر القديم',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurfaceVariant,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '٤٥,٠٠٠ ج.م',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontFamily: 'Tajawal',
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),

                          // Arrow
                          const Icon(
                            Icons.arrow_back, // RTL arrow_right_alt equivalent
                            color: AppColors.outlineVariant,
                          ),

                          // New Price
                          const Column(
                            children: [
                              Text(
                                'السعر الجديد',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryContainer,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '٤٦,٣٠٠ ج.م',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryContainer,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Actions
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تحديث السعر والمتابعة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check_circle, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.tertiary,
                        minimumSize: const Size(double.infinity, 54),
                        side: BorderSide(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إلغاء الصنف',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
