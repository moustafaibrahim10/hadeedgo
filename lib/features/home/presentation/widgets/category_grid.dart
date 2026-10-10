import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_content.dart';

class CategoryGrid extends StatelessWidget {
  final List<HomeCategory> categories;
  final ValueChanged<HomeCategory>? onCategoryTap;
  const CategoryGrid({required this.categories, this.onCategoryTap, super.key});

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    if (categories.isEmpty) return const SizedBox.shrink();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: onCategoryTap == null ? null : () => onCategoryTap!(category),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconFor(category.icon),
                  color: AppColors.primary,
                  size: 28.sp,
                ),
                SizedBox(height: 8.h),
                Text(
                  category.displayName(isEnglish),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.onSurface,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _iconFor(String? icon) {
    switch (icon?.toLowerCase()) {
      case 'pipes':
      case 'pipe':
        return Icons.water_drop_outlined;
      case 'angles':
      case 'angle':
        return Icons.square_foot;
      case 'beams':
      case 'beam':
        return Icons.construction_outlined;
      case 'sheets':
      case 'sheet':
        return Icons.layers_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
