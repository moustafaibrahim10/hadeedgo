import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  final int activeIndex;
  final int cartItemCount;
  final ValueChanged<int>? onItemSelected;

  const HomeBottomNavigation({
    this.activeIndex = 0,
    this.cartItemCount = 0,
    this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (Icons.home_rounded, l10n.home),
      (Icons.search_rounded, l10n.search),
      (Icons.assignment_outlined, l10n.orders),
      (Icons.shopping_cart_outlined, l10n.cart),
      (Icons.person_outline_rounded, l10n.profile),
    ];
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(36.r),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final isActive = entry.key == activeIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onItemSelected?.call(entry.key),
                  borderRadius: BorderRadius.circular(18.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            entry.value.$1,
                            color: isActive
                                ? AppColors.primaryContainer
                                : AppColors.secondary.withValues(alpha: 0.65),
                            size: 22.sp,
                          ),
                          if (entry.key == 3 && cartItemCount > 0)
                            Positioned(
                              top: -7,
                              right: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$cartItemCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        entry.value.$2,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isActive
                              ? AppColors.primaryContainer
                              : AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
