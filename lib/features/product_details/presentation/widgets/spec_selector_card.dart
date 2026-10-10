import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class SpecSelectorCard extends StatelessWidget {
  final String label;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool locked;
  final String? fixedValue;

  const SpecSelectorCard({
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.locked = false,
    this.fixedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                ),
              ),
              if (locked)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 18.sp,
                  color: AppColors.outline,
                ),
            ],
          ),
          SizedBox(height: 10.h),
          if (locked)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                fixedValue ?? '',
                style: TextStyle(
                  fontSize: 17.sp,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: options.length == 2 ? 2 : 3,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, index) => OutlinedButton(
                onPressed: () => onSelected(index),
                style: OutlinedButton.styleFrom(
                  foregroundColor: selectedIndex == index
                      ? AppColors.primaryContainer
                      : AppColors.secondary,
                  backgroundColor: selectedIndex == index
                      ? AppColors.primaryContainer.withValues(alpha: 0.05)
                      : Colors.transparent,
                  side: BorderSide(
                    color: selectedIndex == index
                        ? AppColors.primaryContainer
                        : AppColors.outlineVariant,
                    width: selectedIndex == index ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  options[index],
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(alpha: 0.2),
      ),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
    ),
    child: child,
  );
}
