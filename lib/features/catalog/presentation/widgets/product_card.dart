import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/catalog_entities.dart';
/// Premium product card for the catalog product list. Mirrors the visual
/// language of the search / featured cards (white card, soft shadow, rounded
/// corners, accent stripe) with a bolder price treatment and a gradient
/// call-to-action button.
class ProductCard extends StatelessWidget {
  final Product product;
  final bool isEnglish;
  final VoidCallback onTap;

  const ProductCard({
    required this.product,
    required this.isEnglish,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final supplier = product.supplier;
    final priceText = _formatMoney(product.pricePerTon, product.currency);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 6.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.surfaceVariant),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryContainer.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5.w,
                    color: AppColors.primaryContainer,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.w, 16.w, 16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ProductTitle(
                              title: product.displayTitle(isEnglish),
                              verified: supplier.isVerified,
                            ),
                            SizedBox(height: 4.h),
                            _ProductSupplier(
                              name: supplier.displayName(isEnglish),
                            ),
                            if (product.specsSummary?.isNotEmpty == true) ...[
                              SizedBox(height: 6.h),
                              Text(
                                product.specsSummary!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  height: 1.4,
                                  color: AppColors.secondary,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                            SizedBox(height: 12.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.pricePerTon,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.secondary,
                                          fontFamily: 'Tajawal',
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      if (priceText.isNotEmpty)
                                        Text(
                                          priceText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryContainer,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                _PremiumActionButton(onTap: onTap),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _CatalogImage(
                        imageUrl: product.imageUrl,
                        icon: Icons.inventory_2_outlined,
                        size: 84.w,
                        radius: 14.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatMoney(num? value, String? currency) {
    if (value == null) return '';
    final amount =
        value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
    final parts = <String>[amount];
    if (currency?.isNotEmpty == true) parts.add(currency!);
    if (product.unit?.isNotEmpty == true) parts.add('/ ${product.unit}');
    return parts.join(' ');
  }
}



class _ProductTitle extends StatelessWidget {
  final String title;
  final bool verified;
  const _ProductTitle({required this.title, required this.verified});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      if (verified)
        Padding(
          padding: EdgeInsetsDirectional.only(start: 6.w),
          child: Icon(
            Icons.verified_rounded,
            color: AppColors.primaryContainer,
            size: 20.sp,
          ),
        ),
    ],
  );
}

class _ProductSupplier extends StatelessWidget {
  final String name;
  const _ProductSupplier({required this.name});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.factory_outlined, size: 14.sp, color: AppColors.tertiary),
      SizedBox(width: 4.w),
      Expanded(
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.tertiary,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    ],
  );
}

/// Gradient call-to-action button used by the premium product card.
class _PremiumActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PremiumActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, AppColors.primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward_rounded,
                    size: 18.sp, color: Colors.white),
                SizedBox(width: 6.w),
                Text(
                  l10n.viewDetails,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogImage extends StatelessWidget {
  final String? imageUrl;
  final IconData icon;
  final double size;
  final double radius;

  const _CatalogImage({
    required this.imageUrl,
    required this.icon,
    required this.size,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: imageUrl?.isNotEmpty == true
        ? Image.network(
            imageUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _placeholder(),
          )
        : _placeholder(),
  );

  Widget _placeholder() => Container(
    width: size,
    height: size,
    color: AppColors.surfaceContainerLow,
    child: Icon(icon, color: AppColors.primary),
  );
}
