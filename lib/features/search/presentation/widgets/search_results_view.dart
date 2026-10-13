import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../catalog/domain/entities/catalog_entities.dart';
import '../../domain/entities/search_entities.dart';
import '../cubits/search_cubit.dart';

class SearchResultsView extends StatelessWidget {
  final SearchState state;
  final ScrollController scrollController;
  final ValueChanged<Product> onSelectProduct;
  final VoidCallback onRetry;
  final VoidCallback onClear;
  final List<SearchCategory> filterCategories;
  final ValueChanged<String?> onSelectCategoryFilter;

  const SearchResultsView({
    required this.state,
    required this.scrollController,
    required this.onSelectProduct,
    required this.onRetry,
    required this.onClear,
    this.filterCategories = const [],
    required this.onSelectCategoryFilter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == SearchStatus.loading) {
      return _buildSkeleton();
    }

    if (state.status == SearchStatus.failure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56.sp,
                color: Colors.red[400],
              ),
              SizedBox(height: 12.h),
              Text(
                state.errorMessage ?? 'حدث خطأ أثناء البحث',
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
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
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

    final items = state.results.items;

    if (items.isEmpty && state.status == SearchStatus.success) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 42.sp,
                  color: AppColors.secondary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'لم نتمكن من العثور على نتائج',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'تأكد من صحة الكلمات المدخلة أو جرب البحث بكلمات عامة مثل (حديد، تسليح، كمر)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.secondary,
                  fontFamily: 'Tajawal',
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              OutlinedButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'العودة للاستكشاف',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryContainer,
                  side: const BorderSide(color: AppColors.primaryContainer),
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

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 90.h),
      physics: const BouncingScrollPhysics(),
      itemCount:
          items.length + 1 + (state.status == SearchStatus.loadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Header info at index 0
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Count & Active query header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Tajawal',
                        color: AppColors.secondary,
                      ),
                      children: [
                        const TextSpan(text: 'تم العثور على '),
                        TextSpan(
                          text: '${state.results.totalCount}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const TextSpan(text: ' منتج'),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onClear,
                    icon: Icon(Icons.close_rounded, size: 14.sp),
                    label: const Text(
                      'مسح',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),

              // Filter chips (Category filtering)
              if (filterCategories.isNotEmpty) ...[
                SizedBox(height: 8.h),
                SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterCategories.length + 1,
                    separatorBuilder: (_, _) => SizedBox(width: 8.w),
                    itemBuilder: (context, catIndex) {
                      if (catIndex == 0) {
                        final isSelected = state.activeCategoryId == null;
                        return ChoiceChip(
                          label: Text(
                            'الكل',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Tajawal',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (_) => onSelectCategoryFilter(null),
                          selectedColor: AppColors.primaryContainer,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurface,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primaryContainer
                                : AppColors.surfaceVariant,
                          ),
                          shape: const StadiumBorder(),
                          showCheckmark: false,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                        );
                      }
                      final cat = filterCategories[catIndex - 1];
                      final isSelected = state.activeCategoryId == cat.id;
                      return ChoiceChip(
                        label: Text(
                          cat.displayName(false),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Tajawal',
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => onSelectCategoryFilter(cat.id),
                        selectedColor: AppColors.primaryContainer,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.onSurface,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryContainer
                              : AppColors.surfaceVariant,
                        ),
                        shape: const StadiumBorder(),
                        showCheckmark: false,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 12.h),
            ],
          );
        }

        // Product Item
        final itemIndex = index - 1;
        if (itemIndex < items.length) {
          final product = items[itemIndex];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _ProductSearchResultCard(
              product: product,
              onTap: () => onSelectProduct(product),
            ),
          );
        }

        // Bottom Loading More spinner
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primaryContainer,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 4,
      itemBuilder: (context, _) => Container(
        height: 120.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _ProductSearchResultCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductSearchResultCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = product.displayTitle(false);
    final supplierName = product.supplier.displayName(false);
    final price = product.pricePerTon;
    final currency = product.currency ?? 'ج.م';
    final unit = product.unit ?? 'طن';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image or Icon
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: product.imageUrl?.isNotEmpty == true
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                          size: 32.sp,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.primary,
                        size: 32.sp,
                      ),
              ),
              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Supplier & Specs
                    Row(
                      children: [
                        Icon(
                          Icons.factory_rounded,
                          size: 13.sp,
                          color: AppColors.secondary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            supplierName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.secondary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        if (product.supplier.isVerified) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.verified_rounded,
                            size: 13.sp,
                            color: AppColors.primaryContainer,
                          ),
                        ],
                      ],
                    ),

                    if (product.specsSummary?.isNotEmpty == true) ...[
                      SizedBox(height: 4.h),
                      Text(
                        product.specsSummary!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],

                    SizedBox(height: 8.h),

                    // Price & Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (price != null)
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontFamily: 'Tajawal'),
                              children: [
                                TextSpan(
                                  text: price.toString(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryContainer,
                                  ),
                                ),
                                TextSpan(
                                  text: ' $currency / $unit',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Text(
                            'تواصل لمعرفة السعر',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.secondary,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14.sp,
                          color: AppColors.primaryContainer,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
