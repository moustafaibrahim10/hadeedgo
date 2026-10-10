import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class DeliveryMethodScreen extends StatefulWidget {
  const DeliveryMethodScreen({super.key});

  @override
  State<DeliveryMethodScreen> createState() => _DeliveryMethodScreenState();
}

class _DeliveryMethodScreenState extends State<DeliveryMethodScreen> {
  String _selectedMethod = 'delivery'; // 'delivery' or 'pickup'

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
          'طريقة الاستلام',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurface,
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
              top: 24,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Options
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionCard(
                        id: 'delivery',
                        title: 'التوصيل إلى الموقع',
                        subtitle:
                            'نقوم بتوصيل الحديد إلى موقعك عبر أسطولنا المعتمد',
                        icon: Icons.local_shipping_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOptionCard(
                        id: 'pickup',
                        title: 'الاستلام من المصنع',
                        subtitle:
                            'يمكنك إرسال شاحناتك الخاصة للاستلام من بوابة المصنع مباشرة',
                        icon: Icons.factory_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Details Section
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedMethod == 'delivery'
                      ? _buildDeliveryDetails()
                      : _buildPickupDetails(),
                ),
              ],
            ),
          ),
          // Bottom Action Bar
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
                    color: Colors.white.withValues(alpha: 0.7),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'الإجمالي (شامل ضريبة القيمة المضافة)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '١٢٥,٤٠٠ ج.م',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => context.push(
                          '/secure-payment',
                        ), // navigate to next step
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'متابعة للدفع',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceContainerLowest
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant.withValues(alpha: 0.3),
            width: isSelected ? 2 : 0.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryContainer,
                    size: 24,
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primaryContainer,
                    size: 24,
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 8),
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
    );
  }

  Widget _buildDeliveryDetails() {
    return Column(
      key: const ValueKey('delivery'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل التوصيل',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Dropdown
              const Text(
                'موقع التسليم',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: 'مشروع العاصمة الإدارية - القطعة ٤٢',
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.onSurfaceVariant,
                          ),
                          style: const TextStyle(
                            fontSize: 17,
                            color: AppColors.onSurface,
                            fontFamily: 'Tajawal',
                          ),
                          items:
                              <String>[
                                'مشروع العاصمة الإدارية - القطعة ٤٢',
                                'موقع التجمع الخامس',
                                'إضافة موقع جديد...',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Date Picker
              const Text(
                'تاريخ التوصيل المفضل',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        '2024-05-20',
                        style: TextStyle(
                          fontSize: 17,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPickupDetails() {
    return Column(
      key: const ValueKey('pickup'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تفاصيل الاستلام',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أقرب مصنع لك',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 192,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                  color: AppColors.surfaceContainerHighest,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/photos/png/onboarding2.png', // Placeholder for map
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface.withValues(alpha: 0.9),
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.outlineVariant.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.factory_outlined,
                                  color: AppColors.primaryContainer,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'مصنع حديد عز - السادات',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Auth Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تصريح التحميل',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'سيتم إرسال كود الاستلام (QR Code) وتصريح الدخول للمصنع بعد إتمام الدفع. يرجى تزويد السائق بالكود لتسهيل عملية الدخول.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
