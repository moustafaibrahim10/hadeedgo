import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class ProductDetailsTopBar extends StatelessWidget {
  final VoidCallback onBack;

  const ProductDetailsTopBar({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      bottom: false,
      child: Container(
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
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
              onPressed: onBack,
              tooltip: l10n.back,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.secondary,
              ),
            ),
            Expanded(
              child: Text(
                l10n.productConfiguration,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            Text(
              l10n.homeTitle,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
