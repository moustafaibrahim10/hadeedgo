import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_product.dart';

class SearchProductCard extends StatelessWidget {
  final SearchProduct product;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const SearchProductCard({
    required this.product,
    required this.onAdd,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.surfaceVariant),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)],
        ),
        child: Stack(
          children: [
            if (product.accent)
              PositionedDirectional(
                start: -16.w,
                top: 0,
                bottom: 0,
                child: Container(width: 4.w, color: AppColors.primaryContainer),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        l10n.pricePerTon,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      SizedBox(height: 3.h),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontFamily: 'Tajawal'),
                          children: [
                            TextSpan(
                              text: product.price,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryContainer,
                              ),
                            ),
                            TextSpan(
                              text: ' ${l10n.egp}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Icon(
                    product.type == SearchProductType.coil
                        ? Icons.data_usage_rounded
                        : Icons.construction_rounded,
                    color: AppColors.tertiary,
                  ),
                ),
              ],
            ),
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: Semantics(
                label: l10n.addProductToCart,
                button: true,
                child: IconButton(
                  onPressed: onAdd,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
