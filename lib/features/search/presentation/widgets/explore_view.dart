import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/catalog_entities.dart';
import '../../domain/entities/search_entities.dart';

class ExploreView extends StatelessWidget {
  final ExploreData data;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onSelectQuery;
  final ValueChanged<SearchCategory> onSelectCategory;
  final ValueChanged<Supplier> onSelectSupplier;
  final VoidCallback onClearRecent;
  final VoidCallback onViewAllCategories;
  final VoidCallback onViewAllSuppliers;

  const ExploreView({
    required this.data,
    required this.isLoading,
    required this.onRefresh,
    required this.onSelectQuery,
    required this.onSelectCategory,
    required this.onSelectSupplier,
    required this.onClearRecent,
    required this.onViewAllCategories,
    required this.onViewAllSuppliers,
    this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && data.categories.isEmpty && data.popularSearches.isEmpty) {
      return _buildLoadingSkeleton();
    }

    if (errorMessage != null && data.categories.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 56.sp,
                color: AppColors.secondary,
              ),
              SizedBox(height: 12.h),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('إعادة المحاولة', style: TextStyle(fontFamily: 'Tajawal')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primaryContainer,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 90.h),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          // ─── Recent Searches (البحث الأخير) ──────────────────────────
          if (data.recentSearches.isNotEmpty) ...[
            _SectionHeader(
              title: 'عمليات البحث الأخيرة',
              icon: Icons.history_rounded,
              actionTitle: 'مسح الكل',
              onAction: onClearRecent,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: data.recentSearches.map((item) {
                final query = item.query ?? '';
                if (query.trim().isEmpty) return const SizedBox.shrink();
                return _SearchChip(
                  label: query,
                  icon: Icons.history_rounded,
                  onTap: () => onSelectQuery(query),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),
          ],

          // ─── Popular Searches (مقاسات شائعة) ────────────────────────
          if (data.popularSearches.isNotEmpty) ...[
            const _SectionHeader(
              title: 'مقاسات شائعة',
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.primaryContainer,
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: data.popularSearches.map((item) {
                final label = item.label ?? item.query ?? '';
                final query = item.query ?? item.label ?? '';
                if (label.trim().isEmpty) return const SizedBox.shrink();
                return _SearchChip(
                  label: label,
                  icon: Icons.search_rounded,
                  isHighlighted: true,
                  onTap: () => onSelectQuery(query),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),
          ],

          // ─── Categories (أقسام المنتجات) ─────────────────────────────
          if (data.categories.isNotEmpty) ...[
            _SectionHeader(
              title: 'أقسام المنتجات',
              icon: Icons.grid_view_rounded,
              actionTitle: 'عرض الكل',
              onAction: onViewAllCategories,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 130.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: data.categories.length,
                separatorBuilder: (_, _) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final cat = data.categories[index];
                  return _CategoryExploreCard(
                    category: cat,
                    onTap: () => onSelectCategory(cat),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
          ],

          // ─── Partner Suppliers (المصانع والشركات المعتمدة) ────────────
          if (data.partnerSuppliers.isNotEmpty) ...[
            _SectionHeader(
              title: 'المصانع والشركات المعتمدة',
              icon: Icons.factory_rounded,
              actionTitle: 'عرض الكل',
              onAction: onViewAllSuppliers,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 140.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: data.partnerSuppliers.length,
                separatorBuilder: (_, _) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final sup = data.partnerSuppliers[index];
                  return _SupplierExploreCard(
                    supplier: sup,
                    onTap: () => onSelectSupplier(sup),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _skeletonBox(width: 140.w, height: 20.h),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          children: List.generate(
            4,
            (_) => _skeletonBox(width: 90.w, height: 34.h, radius: 18.r),
          ),
        ),
        SizedBox(height: 28.h),
        _skeletonBox(width: 120.w, height: 20.h),
        SizedBox(height: 12.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (_, _) => _skeletonBox(width: 130.w, height: 120.h, radius: 14.r),
          ),
        ),
      ],
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─── Header Component ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String? actionTitle;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.iconColor,
    this.actionTitle,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: iconColor ?? AppColors.primary,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        if (actionTitle != null && onAction != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(6.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Text(
                actionTitle!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryContainer,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Chip Component ───────────────────────────────────────────────────────────

class _SearchChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isHighlighted
          ? AppColors.primaryFixed.withValues(alpha: 0.4)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isHighlighted
              ? AppColors.primaryContainer.withValues(alpha: 0.5)
              : AppColors.surfaceVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: isHighlighted
                    ? AppColors.primaryContainer
                    : AppColors.secondary,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: isHighlighted
                      ? AppColors.primary
                      : AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Category Card Component ─────────────────────────────────────────────────

class _CategoryExploreCard extends StatelessWidget {
  final SearchCategory category;
  final VoidCallback onTap;

  const _CategoryExploreCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = category.displayName(false);
    final subtitle = category.subtitle?.isNotEmpty == true
        ? category.subtitle!
        : (category.productCount > 0 ? '${category.productCount} منتج' : '');

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 140.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  _categoryIcon(category.icon),
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _categoryIcon(String? icon) {
    switch (icon?.toLowerCase()) {
      case 'pipes':
      case 'pipe':
        return Icons.water_drop_outlined;
      case 'angles':
      case 'angle':
        return Icons.square_foot_rounded;
      case 'beams':
      case 'beam':
        return Icons.construction_rounded;
      case 'sheets':
      case 'sheet':
        return Icons.layers_rounded;
      default:
        return Icons.view_in_ar_rounded;
    }
  }
}

// ─── Supplier / Factory Card Component ───────────────────────────────────────

class _SupplierExploreCard extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onTap;

  const _SupplierExploreCard({
    required this.supplier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = supplier.displayName(false);
    final rating = supplier.rating;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 150.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: supplier.logoUrl?.isNotEmpty == true
                        ? Image.network(
                            supplier.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.factory_rounded,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                          )
                        : Icon(
                            Icons.factory_rounded,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                  ),
                  const Spacer(),
                  if (supplier.isVerified)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 12.sp,
                            color: AppColors.primaryContainer,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'معتمد',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryContainer,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 4.h),
              if (rating != null && rating > 0)
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 14.sp,
                      color: Colors.amber[700],
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
