import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.92),
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            IconButton(
              onPressed: () {},
              tooltip: l10n.notifications,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Image.asset(
              'assets/photos/png/home_logo.png',
              height: 32.h,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8.w),
            Text(
              l10n.homeTitle,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
            const Spacer(),
            Semantics(
              label: l10n.profile,
              button: true,
              child: IconButton(
                onPressed: () => context.go('/profile'),
                tooltip: l10n.profile,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.primaryFixed,
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 21.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
