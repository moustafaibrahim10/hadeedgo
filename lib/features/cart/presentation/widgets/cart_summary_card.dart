import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_entities.dart';

class CartSummaryCard extends StatelessWidget {
  final Cart cart;
  final VoidCallback onCheckout;

  const CartSummaryCard({
    required this.cart,
    required this.onCheckout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 14)],
      ),
      child: Column(
        children: [
          _Row(
            label: l10n.cartWeight,
            value: '${_format(cart.totalWeightTons)} ${l10n.tonUnit}',
          ),
          _Row(
            label: l10n.subtotal,
            value: _money(cart.merchantSubTotal, l10n),
          ),
          _Row(
            label: l10n.deliveryFee,
            value: _money(cart.estimatedDeliveryFee, l10n),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.grandTotal,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              Text(
                _money(cart.grandTotal, l10n),
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.lock_outline_rounded),
              label: Text(
                l10n.checkout,
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
                  borderRadius: BorderRadius.circular(10.r),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _money(num value, AppLocalizations l10n) =>
      '${_format(value)} ${l10n.egp}';
  String _format(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.secondary,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    ),
  );
}
