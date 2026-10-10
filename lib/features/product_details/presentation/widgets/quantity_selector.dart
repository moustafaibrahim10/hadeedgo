import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    required this.quantity,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.quantityTons,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondary,
              fontFamily: 'Tajawal',
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                _Button(
                  icon: Icons.add,
                  onPressed: () => onChanged(quantity + 1),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 32.w,
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                _Button(
                  icon: Icons.remove,
                  onPressed: quantity > 1
                      ? () => onChanged(quantity - 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _Button({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: Icon(icon, size: 18, color: AppColors.primaryContainer),
    visualDensity: VisualDensity.compact,
    style: IconButton.styleFrom(backgroundColor: Colors.white),
  );
}
