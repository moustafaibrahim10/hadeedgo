import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_details.dart';

class ProductHero extends StatelessWidget {
  final ProductDetails product;

  const ProductHero({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 192.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              product.imageAsset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Icon(
                _iconFor(product.type),
                size: 72.sp,
                color: AppColors.tertiary,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          product.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(
              Icons.factory_outlined,
              size: 18.sp,
              color: AppColors.secondary,
            ),
            SizedBox(width: 5.w),
            Text(
              product.supplier,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.secondary,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.verified_rounded,
              size: 16.sp,
              color: AppColors.primaryContainer,
            ),
            SizedBox(width: 4.w),
            Text(
              l10n.verifiedSupplier,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.secondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _iconFor(ProductDetailsType type) => switch (type) {
    ProductDetailsType.beam => Icons.construction_rounded,
    ProductDetailsType.rebar => Icons.construction_rounded,
    ProductDetailsType.coil => Icons.data_usage_rounded,
  };
}
