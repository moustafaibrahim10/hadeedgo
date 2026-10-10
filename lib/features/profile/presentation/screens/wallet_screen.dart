import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'محفظتي',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurfaceVariant,
          ),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
            height: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF131B2E), Color(0xFF233144)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Ambient Orbs
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryContainer.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ).blurred(sigma: 40),
                    ),
                    Positioned(
                      bottom: -40,
                      left: -40,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.tertiaryContainer.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ).blurred(sigma: 40),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الرصيد المتاح',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.surfaceContainerHighest
                                  .withValues(alpha: 0.8),
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Text(
                                '45,250.00',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ج.م',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.surfaceContainerHighest
                                      .withValues(alpha: 0.8),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 18,
                                  ),
                                  label: const Text('شحن المحفظة'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryContainer,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 18,
                                  ),
                                  label: const Text('سحب الرصيد'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                    side: BorderSide(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Transaction History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجل العمليات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTransactionItem(
              icon: Icons.add,
              title: 'شحن رصيد',
              subtitle: '١٢ مايو ٢٠٢٤ • فيزا تنتهي بـ ٤٢١١',
              amount: '+ ٥,٠٠٠ ج.م',
              statusText: 'ناجحة',
              statusColor: const Color(0xFF10B981),
              isPositive: true,
            ),
            _buildTransactionItem(
              icon: Icons.shopping_bag_outlined,
              title: 'دفعة طلب #١٢٤٥',
              subtitle: '١٠ مايو ٢٠٢٤ • حديد عز ٤ طن',
              amount: '- ١٢,٥٠٠ ج.م',
              statusText: 'ناجحة',
              statusColor: const Color(0xFF10B981),
              isPositive: false,
            ),
            _buildTransactionItem(
              icon: Icons.account_balance_outlined,
              title: 'سحب رصيد',
              subtitle: '٠٨ مايو ٢٠٢٤ • البنك الأهلي المصري',
              amount: '- ٢,٠٠٠ ج.م',
              statusText: 'قيد المعالجة',
              statusColor: const Color(0xFFF59E0B),
              isPositive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required String statusText,
    required Color statusColor,
    required bool isPositive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.onSurfaceVariant,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? AppColors.primary : AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension BlurredWidget on Widget {
  Widget blurred({double sigma = 10}) {
    return ImageFilterWidget(sigma: sigma, child: this);
  }
}

class ImageFilterWidget extends StatelessWidget {
  final double sigma;
  final Widget child;
  const ImageFilterWidget({
    super.key,
    required this.sigma,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: child,
    );
  }
}
