import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class TaxInvoiceScreen extends StatelessWidget {
  const TaxInvoiceScreen({super.key});

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
          'HadeedGo',
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
            color: AppColors.primary,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative Industrial Accent
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 96,
                  height: 4,
                  color: AppColors.primaryContainer,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'الفاتورة الضريبية',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'إيصال رقمي',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.secondary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(color: AppColors.surfaceVariant),
                  ),

                  // Invoice Summary Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryField(
                          'رقم الفاتورة',
                          'HG-INV-99821',
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryField('التاريخ', '15 أكتوبر 2023'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الحالة',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'مدفوعة',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Bill To Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: AppColors.secondary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'فاتورة إلى',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'شركة المقاولات الحديثة',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'م. أحمد محمود',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.onSurfaceVariant,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Text(
                          'المنطقة الصناعية، القاهرة، مصر',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.onSurfaceVariant,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Items Table
                  const Text(
                    'المنتجات',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.surfaceVariant),
                  ),
                  _buildItemRow(
                    title: 'حديد تسليح 12 مم',
                    subtitle: 'عز الدخيلة - فئة أ',
                    quantity: '5 طن',
                    price: '35,000 ج.م / طن',
                    subtotal: '175,000 ج.م',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.surfaceVariant),
                  ),
                  _buildItemRow(
                    title: 'حديد تسليح 16 مم',
                    subtitle: 'بشاي للصلب',
                    quantity: '2 طن',
                    price: '34,500 ج.م / طن',
                    subtotal: '69,000 ج.م',
                  ),
                  const SizedBox(height: 32),

                  // Financial Breakdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildPriceRow(
                          'المجموع الفرعي',
                          '244,000 ج.م',
                          isBold: false,
                        ),
                        const SizedBox(height: 12),
                        _buildPriceRow(
                          'ضريبة القيمة المضافة (15%)',
                          '36,600 ج.م',
                          isBold: false,
                        ),
                        const SizedBox(height: 12),
                        _buildPriceRow(
                          'رسوم التوصيل',
                          '1,500 ج.م',
                          isBold: false,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(color: AppColors.surfaceVariant),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              child: Text(
                                'الإجمالي',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  '282,100 ج.م',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryContainer,
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
                  const SizedBox(height: 32),

                  // Payment Info & QR Code
                  const Divider(color: AppColors.surfaceVariant),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'طريقة الدفع',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.credit_card,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Visa **** 4589',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                    fontFamily: 'Tajawal',
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.qr_code_2,
                                size: 80,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'امسح للتحقق الرقمي',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
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
      ),
    );
  }

  Widget _buildSummaryField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow({
    required String title,
    required String subtitle,
    required String quantity,
    required String price,
    required String subtotal,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المجموع الفرعي',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                subtotal,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? AppColors.onSurface : AppColors.secondary,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }
}
