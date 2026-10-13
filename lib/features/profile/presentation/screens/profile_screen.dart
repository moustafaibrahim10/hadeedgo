import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubits/account_cubits.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountSummaryCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    final summaryState = context.watch<AccountSummaryCubit>().state;
    final profile = summaryState.summary.profile;

    final displayName = profile.fullName?.trim().isNotEmpty == true
        ? profile.fullName!
        : (user?.fullName?.trim().isNotEmpty == true
              ? user!.fullName!
              : 'HadeedGo');

    final isPhoneVerified =
        profile.isPhoneVerified || (user?.isPhoneVerified == true);
    final verificationLabel = isPhoneVerified
        ? 'الهاتف موثق'
        : 'الهاتف غير موثق';
    final avatarUrl = profile.avatarUrl;

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
      body: RefreshIndicator(
        onRefresh: () => context.read<AccountSummaryCubit>().load(),
        color: AppColors.primaryContainer,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
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
                          image: avatarUrl?.isNotEmpty == true
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                    'assets/photos/png/onboarding1.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/edit-profile'),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (profile.companyName?.trim().isNotEmpty == true) ...[
                    const SizedBox(height: 2),
                    Text(
                      profile.companyName!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(
                        alpha: 0.3,
                      ),
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
                    trailingText: summaryState.summary.savedAddressCount > 0
                        ? '${summaryState.summary.savedAddressCount}'
                        : null,
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
                    trailingText: summaryState.summary.taxInvoiceCount > 0
                        ? '${summaryState.summary.taxInvoiceCount}'
                        : null,
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
                    iconBgColor: AppColors.errorContainer.withValues(
                      alpha: 0.3,
                    ),
                    title: 'تسجيل الخروج',
                    titleColor: AppColors.error,
                    onTap: () => _confirmLogout(context),
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
      ),
    );
  }

  /// Shows a confirmation dialog, then performs logout. The router's
  /// `refreshListenable` reacts to the resulting `unauthenticated` state and
  /// redirects to the login screen automatically.
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        content: const Text(
          'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
          style: TextStyle(fontFamily: 'Tajawal', color: AppColors.secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'خروج',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthCubit>().logout();
    }
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
