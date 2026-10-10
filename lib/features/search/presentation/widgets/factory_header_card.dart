import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class FactoryHeaderCard extends StatelessWidget {
  const FactoryHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.surfaceContainerLow),
            ),
            child: Icon(
              Icons.factory_rounded,
              color: AppColors.primary,
              size: 34.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ezzSteel,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 6.h),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryContainer,
                          size: 16,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          l10n.factoryRating,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primaryContainer,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    _Dot(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: AppColors.secondary,
                          size: 15,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          l10n.certifiedFactory,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.secondary,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),
                    _Dot(),
                    Text(
                      l10n.sadat,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
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

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) => Container(
    width: 4.w,
    height: 4.w,
    decoration: const BoxDecoration(
      color: AppColors.outlineVariant,
      shape: BoxShape.circle,
    ),
  );
}
