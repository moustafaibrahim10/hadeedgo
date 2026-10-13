import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_content.dart';

class FeaturedProductCard extends StatefulWidget {
  final FeaturedOffer offer;
  final VoidCallback? onTap;
  final ValueChanged<int>? onAddToCart;
  const FeaturedProductCard({
    required this.offer,
    this.onTap,
    this.onAddToCart,
    super.key,
  });

  @override
  State<FeaturedProductCard> createState() => _FeaturedProductCardState();
}

class _FeaturedProductCardState extends State<FeaturedProductCard> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.offer.defaultQuantity.clamp(
      widget.offer.minQuantity,
      widget.offer.maxQuantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    final offer = widget.offer;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 88.h,
              width: double.infinity,
              child: offer.imageUrl?.isNotEmpty == true
                  ? Image.network(
                      offer.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Image.asset(
                        'assets/photos/png/onboarding3.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/photos/png/onboarding3.png',
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          offer.supplier.displayName(isEnglish),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      if (offer.supplier.isVerified)
                        Icon(
                          Icons.verified_rounded,
                          color: AppColors.primaryContainer,
                          size: 20.sp,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                    child: Text(
                      offer.title ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                    child: Text(
                      offer.specsSummary ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          label: l10n.price,
                          value: '${offer.pricePerTon} ${offer.currency ?? ''}',
                          valueColor: AppColors.primaryContainer,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: _Metric(
                          label: l10n.update,
                          value: offer.lastUpdatedLabel ?? '',
                          valueColor: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: _QuantityStepper(
                      quantity: _quantity,
                      offer: offer,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    height: 38.h,
                    child: ElevatedButton.icon(
                      onPressed: widget.onAddToCart == null
                          ? null
                          : () => widget.onAddToCart!(_quantity),
                      icon: const Icon(Icons.shopping_cart_outlined, size: 16),
                      label: Text(
                        l10n.addToCart,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onTertiaryContainer,
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _Metric({
    required this.label,
    required this.value,
    required this.valueColor,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(8.w),
    color: AppColors.surfaceContainerLowest,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.tertiary,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.1,
            overflow: TextOverflow.ellipsis,
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    ),
  );
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final FeaturedOffer offer;
  final ValueChanged<int> onChanged;
  const _QuantityStepper({
    required this.quantity,
    required this.offer,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) => Container(
    height: 36.h,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: AppColors.outlineVariant),
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: quantity + offer.quantityStep <= offer.maxQuantity
              ? () => onChanged(quantity + offer.quantityStep)
              : null,
          icon: const Icon(Icons.add, size: 18),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 28.w),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              '$quantity ${offer.unit}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontFamily: 'Tajawal'),
            ),
          ),
        ),
        IconButton(
          onPressed: quantity - offer.quantityStep >= offer.minQuantity
              ? () => onChanged(quantity - offer.quantityStep)
              : null,
          icon: const Icon(Icons.remove, size: 18),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 28.w),
        ),
      ],
    ),
  );
}
