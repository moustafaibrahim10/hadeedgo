import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class DeliveryLocationScreen extends StatefulWidget {
  const DeliveryLocationScreen({super.key});

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
  String _selectedAddressId = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'تحديد موقع التوصيل',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 0.5,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Map Placeholder
          Positioned.fill(
            child: Image.asset(
              'assets/photos/png/onboarding2.png', // Temporary placeholder for map
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  _buildGlassPanel(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'البحث عن عنوان...',
                              hintStyle: TextStyle(
                                fontSize: 17,
                                color: AppColors.secondaryFixedDim,
                                fontFamily: 'Tajawal',
                              ),
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 17,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Bottom Panel
                  _buildGlassPanel(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'العناوين المحفوظة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAddressCard(
                          id: '1',
                          title: 'موقع المشروع ألفا',
                          subtitle: 'شارع الصناعة 45, المنطقة الصناعية الجديدة',
                          icon: Icons.location_on,
                        ),
                        const SizedBox(height: 12),
                        _buildAddressCard(
                          id: '2',
                          title: 'المستودع 2',
                          subtitle: 'طريق القاهرة الإسكندرية الصحراوي',
                          icon: Icons.factory_outlined,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.push(
                            '/secure-payment',
                          ), // Assume we move to secure payment next from delivery location
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'تأكيد الموقع',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel({
    required Widget child,
    required EdgeInsets padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.8),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedAddressId == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedAddressId = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceContainerLowest
              : AppColors.surfaceContainerLowest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 1 : 0.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryContainer
                  : AppColors.secondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 4),
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
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryContainer,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
