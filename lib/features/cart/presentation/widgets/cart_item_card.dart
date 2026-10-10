import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_entities.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final price = item.pricePerTon == null
        ? null
        : '${_format(item.pricePerTon!)}${item.currency == null ? '' : ' ${item.currency}'}';
    final canDecrease = item.quantity - item.quantityStep >= item.minQuantity;
    final canIncrease = item.quantity + item.quantityStep <= item.maxQuantity;
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 8)],
      ),
      child: Row(
        children: [
          _CartImage(imageUrl: item.imageUrl),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.displayTitle(
                          Localizations.localeOf(context).languageCode == 'en',
                        ),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onRemove,
                      tooltip: l10n.removeItem,
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 20.sp,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                Text(
                  [
                    if (item.specsSummary?.isNotEmpty == true)
                      item.specsSummary!,
                    item.supplier.displayName(
                      Localizations.localeOf(context).languageCode == 'en',
                    ),
                  ].join(' - '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.secondary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (price != null)
                      Expanded(
                        child: Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryContainer,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                    if (price != null) SizedBox(width: 4.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerEnd,
                        child: _QuantityStepper(
                          item: item,
                          canDecrease: canDecrease,
                          canIncrease: canIncrease,
                          onDecrease: onDecrease,
                          onIncrease: onIncrease,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _format(num value) => value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
}

class _QuantityStepper extends StatelessWidget {
  final CartItem item;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityStepper({
    required this.item,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(4.w),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(
        color: AppColors.outlineVariant.withValues(alpha: 0.3),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: canDecrease ? onDecrease : null,
          tooltip: AppLocalizations.of(context).decreaseQuantity,
          icon: const Icon(Icons.remove),
          iconSize: 18.sp,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          '${item.quantity}${item.unit == null ? '' : ' ${item.unit}'}',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        IconButton(
          onPressed: canIncrease ? onIncrease : null,
          tooltip: AppLocalizations.of(context).increaseQuantity,
          icon: const Icon(Icons.add),
          iconSize: 18.sp,
          visualDensity: VisualDensity.compact,
        ),
      ],
    ),
  );
}

class _CartImage extends StatelessWidget {
  final String? imageUrl;
  const _CartImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(8.r),
    child: imageUrl?.isNotEmpty == true
        ? Image.network(
            imageUrl!,
            width: 96.w,
            height: 96.w,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _placeholder(),
          )
        : _placeholder(),
  );

  Widget _placeholder() => Container(
    width: 96.w,
    height: 96.w,
    color: AppColors.surfaceContainerLow,
    child: Icon(
      Icons.inventory_2_outlined,
      color: AppColors.primary,
      size: 30.sp,
    ),
  );
}
