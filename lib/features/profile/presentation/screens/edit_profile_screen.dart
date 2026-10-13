import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubits/account_cubits.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _companyController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().load();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _populateFields(ProfileState state) {
    if (!_initialized && state.status == ProfileStatus.success) {
      _nameController.text = state.profile.fullName ?? '';
      _phoneController.text = state.profile.phone ?? '';
      _emailController.text = state.profile.email ?? '';
      _companyController.text = state.profile.companyName ?? '';
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.red[700],
            ),
          );
        } else if (state.status == ProfileStatus.updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.successMessage ?? 'تم حفظ التعديلات بنجاح',
                style: const TextStyle(fontFamily: 'Tajawal'),
              ),
              backgroundColor: Colors.green[700],
            ),
          );
          context.pop();
        }
      },
      builder: (context, state) {
        _populateFields(state);
        final profile = state.profile;
        final avatarUrl = profile.avatarUrl;

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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.onSurface,
                ),
                onPressed: () => context.pop(),
              ),
            ],
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
                height: 0.5,
              ),
            ),
          ),
          body: state.status == ProfileStatus.loading && !_initialized
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryContainer,
                  ),
                )
              : Stack(
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
                          // Profile Image Section
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              AppColors.surfaceContainerLowest,
                                          width: 4,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: avatarUrl?.isNotEmpty == true
                                            ? Image.network(
                                                avatarUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, _, _) =>
                                                    Image.asset(
                                                      'assets/photos/png/onboarding1.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                              )
                                            : Image.asset(
                                                'assets/photos/png/onboarding1.png',
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
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.photo_camera,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  profile.fullName?.isNotEmpty == true
                                      ? profile.fullName!
                                      : 'مستخدم HadeedGo',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Form Section
                          _buildField(
                            label: 'الاسم بالكامل',
                            controller: _nameController,
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'رقم الجوال (مسجل)',
                            controller: _phoneController,
                            icon: Icons.phone_outlined,
                            isReadOnly: true,
                            isLtr: true,
                            helperText: profile.isPhoneVerified
                                ? 'تم التحقق من رقم الهاتف'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'البريد الإلكتروني',
                            controller: _emailController,
                            icon: Icons.email_outlined,
                            isLtr: true,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildField(
                            label: 'اسم المؤسسة / الشركة',
                            controller: _companyController,
                            icon: Icons.business_outlined,
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
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                              color: AppColors.outlineVariant.withValues(
                                alpha: 0.3,
                              ),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: state.status == ProfileStatus.updating
                              ? null
                              : () {
                                  context.read<ProfileCubit>().update(
                                    fullName: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    companyName: _companyController.text.trim(),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: state.status == ProfileStatus.updating
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'حفظ التغييرات',
                                      style: TextStyle(
                                        fontSize: 18,
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
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isLtr = false,
    bool isReadOnly = false,
    String? helperText,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      style: const TextStyle(
        fontFamily: 'Tajawal',
        fontSize: 15,
        color: AppColors.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: const TextStyle(
          color: Colors.green,
          fontFamily: 'Tajawal',
          fontSize: 11,
        ),
        prefixIcon: Icon(icon, color: AppColors.secondary, size: 20),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.onSurfaceVariant,
          fontFamily: 'Tajawal',
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.primaryContainer,
          fontFamily: 'Tajawal',
        ),
        filled: true,
        fillColor: isReadOnly
            ? AppColors.surfaceVariant.withValues(alpha: 0.25)
            : AppColors.surfaceContainerLowest,
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
          vertical: 14,
        ),
      ),
    );
  }
}
