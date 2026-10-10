import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class PickupTimeScreen extends StatefulWidget {
  const PickupTimeScreen({super.key});

  @override
  State<PickupTimeScreen> createState() => _PickupTimeScreenState();
}

class _PickupTimeScreenState extends State<PickupTimeScreen> {
  String _selectedTransport = 'hadeedgo'; // 'hadeedgo' or 'private'
  int _selectedDay = 6; // Just for demo

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
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
            ),
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
                const Text(
                  'موعد الاستلام من المصنع',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 24),

                // Transportation Choice
                const Text(
                  'طريقة النقل',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTransportOption(
                        id: 'hadeedgo',
                        title: 'نقل HadeedGo',
                        icon: Icons.local_shipping,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTransportOption(
                        id: 'private',
                        title: 'سيارة خاصة',
                        icon: Icons.directions_car_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ملاحظة: قد تختلف الأسعار بناءً على خيار النقل.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary.withValues(alpha: 0.9),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Calendar View
                const Text(
                  'تاريخ الاستلام',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: AppColors.secondary,
                            ),
                            onPressed: () {},
                          ),
                          const Text(
                            'أكتوبر 2023',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: AppColors.secondary,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Days of week
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:
                            ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت']
                                .map(
                                  (day) => Expanded(
                                    child: Text(
                                      day,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondary,
                                        fontFamily: 'Tajawal',
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                      // Days grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          final day = index + 1;
                          final isDisabled = day < 6;
                          final isSelected = day == _selectedDay;

                          return GestureDetector(
                            onTap: isDisabled
                                ? null
                                : () => setState(() => _selectedDay = day),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isDisabled
                                        ? AppColors.tertiaryFixedDim
                                        : isSelected
                                        ? Colors.white
                                        : AppColors.onSurface,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Warning Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.errorContainer),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.error,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'تنبيه هام',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onErrorContainer,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'في حال عدم استلام الطلب في الموعد المحدد، سيتم إلغاء الطلب تلقائياً.',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onErrorContainer,
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
                    color: AppColors.surface.withValues(alpha: 0.9),
                    border: Border(
                      top: BorderSide(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push('/delivery-location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'تأكيد موعد الاستلام',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
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

  Widget _buildTransportOption({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedTransport == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedTransport = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.secondary,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.onSurface
                        : AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Positioned(
                top: -8,
                right: -8,
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primaryContainer,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
