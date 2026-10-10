import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.7),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'العناوين المحفوظة',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
        ],
        automaticallyImplyLeading:
            false, // RTL handled properly with back button on right
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
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 120,
            ),
            child: Column(
              children: [
                _buildAddressCard(
                  title: 'موقع الإنشاء - التجمع الخامس',
                  address:
                      'قطعة 45، منطقة المستثمرين الشمالية، التجمع الخامس، القاهرة الجديدة',
                  contactName: 'م. أحمد محمود',
                  contactPhone: '01001234567',
                  icon: Icons.location_city,
                  isDefault: true,
                ),
                const SizedBox(height: 16),
                _buildAddressCard(
                  title: 'مخزن العبور',
                  address: 'المنطقة الصناعية الأولى، بلوك 12، مدينة العبور',
                  contactName: 'خالد سعيد',
                  contactPhone: '01119876543',
                  icon: Icons.warehouse,
                  isDefault: false,
                ),
              ],
            ),
          ),

          // Bottom Action Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
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
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withValues(alpha: 0.2),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'إضافة عنوان جديد',
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

  Widget _buildAddressCard({
    required String title,
    required String address,
    required String contactName,
    required String contactPhone,
    required IconData icon,
    required bool isDefault,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDefault ? AppColors.primary : AppColors.tertiary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'الافتراضي',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.onSurfaceVariant,
                    fontFamily: 'Tajawal',
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$contactName - $contactPhone',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                      textDirection: TextDirection
                          .ltr, // To keep phone number formatting correct if mixed with text
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
