import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class SecurePaymentScreen extends StatefulWidget {
  const SecurePaymentScreen({super.key});

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen> {
  String _selectedPaymentMethod = 'card'; // 'card' or 'wallet'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الدفع المؤمن',
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
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Trust Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondaryContainer),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock,
                        color: AppColors.onSecondaryContainer,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'دفع آمن ومضمون',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSecondaryContainer,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'مبلغ الطلب محمي ومحجوز لحين تأكيد استلام الشحنة ومطابقتها للمواصفات.',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.onSecondaryContainer
                                    .withValues(alpha: 0.9),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Order Verification Card
                _buildGlassCard(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'تفاصيل الطلب',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryFixed,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'رقم #8924',
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
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: AppColors.surfaceVariant,
                          height: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              'المنتج',
                              'حديد تسليح 12مم',
                              null,
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              'المصنع',
                              'حديد عز',
                              Icons.verified,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem('الكمية', '50 طن', null),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              'موقع التسليم',
                              'القاهرة الجديدة، التجمع الخامس',
                              null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Methods
                const Text(
                  'طريقة الدفع',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 16),
                _buildPaymentMethodOption(
                  id: 'card',
                  title: 'بطاقة بنكية',
                  subtitle: 'خصم مباشر أو ائتمان',
                  icon: Icons.credit_card_outlined,
                ),
                const SizedBox(height: 8),
                _buildPaymentMethodOption(
                  id: 'wallet',
                  title: 'محفظة إلكترونية',
                  subtitle: 'فودافون كاش، اتصالات كاش',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 24),

                // Price Breakdown
                _buildGlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'ملخص الدفع',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPriceRow('قيمة الحديد (50 طن)', '1,950,000 ج.م'),
                      const SizedBox(height: 12),
                      _buildPriceRow('رسوم النقل', '15,000 ج.م'),
                      const SizedBox(height: 12),
                      _buildPriceRow(
                        'ضريبة القيمة المضافة (14%)',
                        '275,100 ج.م',
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'رسوم الحماية (HadeedGo)',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.onSurfaceVariant,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '0 ج.م',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.onSurface,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryFixed,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'مجاناً',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(
                          color: AppColors.surfaceVariant,
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الإجمالي',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          const Text(
                            '2,240,100 ج.م',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: 'Tajawal',
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

          // Fixed Bottom CTA
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: MediaQuery.paddingOf(context).bottom + 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push('/checkout-confirmation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'تأكيد الدفع',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
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

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
      ),
      child: child,
    );
  }

  Widget _buildDetailItem(String label, String value, IconData? icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
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
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Icon(icon, color: AppColors.onSurfaceVariant, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.onSurfaceVariant,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}
