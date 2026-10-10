import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class SearchTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSearch;

  const SearchTopBar({required this.onBack, required this.onSearch, super.key});

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
          children: [
            IconButton(
              onPressed: onBack,
              tooltip: l10n.back,
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.primary,
              ),
            ),
            Expanded(
              child: Text(
                l10n.searchProductsTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            IconButton(
              onPressed: onSearch,
              tooltip: l10n.search,
              icon: const Icon(Icons.search_rounded, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
