import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class ProductFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ProductFilterChips({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = [
      l10n.all,
      l10n.rebarLengths,
      l10n.coils,
      l10n.scrap,
      l10n.flatProducts,
    ];
    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, _) => SizedBox(width: 10.w),
        itemBuilder: (context, index) => ChoiceChip(
          label: Text(
            labels[index],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
          ),
          selected: selectedIndex == index,
          onSelected: (_) => onSelected(index),
          selectedColor: AppColors.primaryContainer,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: selectedIndex == index ? Colors.white : AppColors.secondary,
          ),
          side: BorderSide(
            color: selectedIndex == index
                ? AppColors.primaryContainer
                : AppColors.surfaceVariant,
          ),
          shape: const StadiumBorder(),
          showCheckmark: false,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        ),
      ),
    );
  }
}
