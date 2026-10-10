import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    final displayName = user?.fullName?.trim().isNotEmpty == true
        ? user!.fullName!
        : 'HadeedGo';
    final verificationLabel = user?.isPhoneVerified == true
        ? 'الهاتف موثق'
        : 'الهاتف غير موثق';

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
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Tajawal',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
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
        child: Column(
          children: [
            // Profile Header
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surfaceContainerHighest,
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/photos/png/onboarding1.png',
                          ), // placeholder for avatar
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surfaceVariant),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        verificationLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Personal Info Group
            _buildSectionHeader('المعلومات الشخصية'),
            _IosListGroup(
              children: [
                _IosListItem(
                  icon: Icons.person_outline,
                  iconColor: AppColors.tertiary,
                  iconBgColor: AppColors.surfaceContainer,
                  title: 'تعديل الملف الشخصي',
                  onTap: () => context.push('/edit-profile'),
                ),
                _IosListItem(
                  icon: Icons.location_on_outlined,
                  iconColor: AppColors.tertiary,
                  iconBgColor: AppColors.surfaceContainer,
                  title: 'العناوين المحفوظة',
                  onTap: () => context.push('/addresses'),
                  showBorder: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Financial Group
            _buildSectionHeader('المالية'),
            _IosListGroup(
              children: [
                _IosListItem(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: AppColors.primary,
                  iconBgColor: AppColors.primaryFixed,
                  title: 'محفظتي',
                  trailingText: '0 ج.م',
                  onTap: () => context.push('/wallet'),
                ),
                _IosListItem(
                  icon: Icons.receipt_long_outlined,
                  iconColor: AppColors.tertiary,
                  iconBgColor: AppColors.surfaceContainer,
                  title: 'الفواتير الضريبية',
                  onTap: () => context.push('/tax-invoice'),
                  showBorder: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Support Group
            _buildSectionHeader('المساعدة والدعم'),
            _IosListGroup(
              children: [
                _IosListItem(
                  icon: Icons.support_agent_outlined,
                  iconColor: AppColors.secondary,
                  iconBgColor: AppColors.secondaryFixed,
                  title: 'الدعم الفني',
                  onTap: () => context.push('/support'),
                  showBorder: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Legal Group
            _buildSectionHeader('معلومات قانونية'),
            _IosListGroup(
              children: [
                _IosListItem(
                  icon: Icons.gavel_outlined,
                  iconColor: AppColors.tertiary,
                  iconBgColor: AppColors.surfaceContainer,
                  title: 'شروط الخدمة',
                  onTap: () {},
                ),
                _IosListItem(
                  icon: Icons.policy_outlined,
                  iconColor: AppColors.tertiary,
                  iconBgColor: AppColors.surfaceContainer,
                  title: 'سياسة الخصوصية',
                  onTap: () {},
                ),
                _IosListItem(
                  icon: Icons.logout,
                  iconColor: AppColors.error,
                  iconBgColor: AppColors.errorContainer.withValues(alpha: 0.3),
                  title: 'تسجيل الخروج',
                  titleColor: AppColors.error,
                  onTap: () {},
                  showChevron: false,
                  showBorder: false,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Version Info
            Text(
              'إصدار التطبيق 1.0.4 (Build 420)',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }
}

class _IosListGroup extends StatelessWidget {
  final List<Widget> children;

  const _IosListGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant, width: 0.5),
      ),
      child: Column(children: children),
    );
  }
}

class _IosListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final Color titleColor;
  final String? trailingText;
  final VoidCallback onTap;
  final bool showBorder;
  final bool showChevron;

  const _IosListItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.titleColor = AppColors.onSurface,
    this.trailingText,
    required this.onTap,
    this.showBorder = true,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.surfaceVariant,
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: titleColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.tertiary,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 16),
            ],
            if (showChevron)
              const Icon(
                Icons.chevron_left_rounded, // Assuming RTL, chevron points left
                color: AppColors.outlineVariant,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
