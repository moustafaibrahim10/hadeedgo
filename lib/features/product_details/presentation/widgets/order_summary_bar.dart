import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class OrderSummaryBar extends StatelessWidget {
  final int quantity;
  final int pricePerTon;
  final VoidCallback onAdd;

  const OrderSummaryBar({
    required this.quantity,
    required this.pricePerTon,
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 14,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.totalForQuantity('$quantity'),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${_format(pricePerTon * quantity)} ${l10n.egp}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.productPricePerTon,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${_format(pricePerTon)} ${l10n.egp}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.shopping_cart_outlined),
                label: Text(
                  l10n.addConfiguredProduct,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _format(int value) => value.toString().replaceAllMapped(
    RegExp(r'(?<=\d)(?=(\d{3})+$)'),
    (match) => ',',
  );
}
