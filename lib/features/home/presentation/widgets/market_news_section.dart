import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_content.dart';

class MarketNewsSection extends StatelessWidget {
  final List<HomeNews> news;
  const MarketNewsSection({required this.news, super.key});

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) return const SizedBox.shrink();
    return Column(
      children: news
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.surfaceVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixed,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        _iconFor(item.icon),
                        color: AppColors.primaryContainer,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurface,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.summary ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.secondary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  IconData _iconFor(String? icon) {
    switch (icon?.toLowerCase()) {
      case 'factory':
        return Icons.factory_outlined;
      case 'down':
        return Icons.trending_down_rounded;
      default:
        return Icons.trending_up_rounded;
    }
  }
}
