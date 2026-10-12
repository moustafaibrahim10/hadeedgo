import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class SearchTopBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback onBack;
  final String hintText;

  const SearchTopBar({
    required this.controller,
    required this.onBack,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText = 'ابحث عن حديد، مقاسات، مصانع...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              tooltip: 'رجوع',
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.onSurface,
                size: 22.sp,
              ),
              visualDensity: VisualDensity.compact,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Icon(
                        Icons.search_rounded,
                        color: AppColors.secondary,
                        size: 20.sp,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            fontFamily: 'Tajawal',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        if (value.text.isEmpty) return const SizedBox.shrink();
                        return IconButton(
                          onPressed: onClear,
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: AppColors.secondary,
                          ),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 18.r,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
