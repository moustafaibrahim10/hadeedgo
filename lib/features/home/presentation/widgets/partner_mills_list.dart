import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_content.dart';

class PartnerMillsList extends StatelessWidget {
  final List<PartnerSupplier> suppliers;
  final ValueChanged<PartnerSupplier>? onSupplierTap;
  const PartnerMillsList({
    required this.suppliers,
    this.onSupplierTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    if (suppliers.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 78.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suppliers.length,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final supplier = suppliers[index];
          return InkWell(
            onTap: onSupplierTap == null
                ? null
                : () => onSupplierTap!(supplier),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 128.w,
              alignment: Alignment.center,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Text(
                supplier.displayName(isEnglish),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
