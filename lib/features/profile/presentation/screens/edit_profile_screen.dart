import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
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
            false, // Right-to-left UI means back button is on the right, but standard RTL flutter handles it. To match exactly the HTML which has back arrow on left/right depending on RTL, we use standard Flutter back button.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
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
              bottom: 100,
            ),
            child: Column(
              children: [
                // Profile Image Section
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.surfaceContainerLowest,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/photos/png/onboarding1.png', // Temporary placeholder
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'المهندس أحمد محمود',
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

                // Form Section
                _buildTextField(
                  label: 'الاسم بالكامل',
                  initialValue: 'أحمد محمود',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'رقم الجوال',
                  initialValue: '+20 100 123 4567',
                  isLtr: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'البريد الإلكتروني',
                  initialValue: 'ahmed.mahmoud@steelco.com',
                  isLtr: true,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'اسم المؤسسة/الشركة',
                  initialValue: 'الشركة المصرية للصلب',
                ),
              ],
            ),
          ),

          // Bottom Action Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.9),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withValues(alpha: 0.2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'حفظ التغييرات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    bool isLtr = false,
  }) {
    return TextFormField(
      initialValue: initialValue,
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 15,
          color: AppColors.onSurfaceVariant,
          fontFamily: 'Tajawal',
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 15,
          color: AppColors.primaryContainer,
          fontFamily: 'Tajawal',
        ),
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryContainer,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 17,
        color: AppColors.onSurface,
        fontFamily: 'Tajawal',
      ),
    );
  }
}
