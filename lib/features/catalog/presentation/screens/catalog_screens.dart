import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/presentation/cubits/cart_cubit.dart';
import '../../domain/entities/catalog_entities.dart';
import '../cubits/catalog_cubits.dart';
import '../widgets/product_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoriesCubit>().state;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.catalogCategories)),
      body: _CatalogStateView<Category>(
        state: state,
        onRetry: context.read<CategoriesCubit>().load,
        builder: (categories) => GridView.builder(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.12,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: category,
              onTap: () => context.push('/products?categoryId=${category.id}'),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnglish = _english(context);
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      _categoryIcon(category.icon),
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15.sp,
                    color: AppColors.secondary,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                category.displayName(isEnglish),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                l10n.productsCount(category.productCount),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondary,
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

IconData _categoryIcon(String? icon) {
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

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});
  @override
  Widget build(BuildContext context) => _ListScaffold<Supplier>(
    title: AppLocalizations.of(context).catalogSuppliers,
    cubit: context.read<SuppliersCubit>(),
    state: context.watch<SuppliersCubit>().state,
    itemBuilder: (supplier) => ListTile(
      leading: _SupplierLogo(supplier: supplier),
      title: Text(supplier.displayName(_english(context))),
      trailing: supplier.isVerified ? const Icon(Icons.verified) : null,
      onTap: () => context.push('/suppliers/${supplier.id}'),
    ),
    onRetry: () => context.read<SuppliersCubit>().load(),
  );
}

class ProductsScreen extends StatelessWidget {
  final String? categoryId;
  final String? supplierId;
  const ProductsScreen({this.categoryId, this.supplierId, super.key});
  @override
  Widget build(BuildContext context) => _ListScaffold<Product>(
    title: AppLocalizations.of(context).catalogProducts,
    cubit: context.read<ProductsCubit>(),
    state: context.watch<ProductsCubit>().state,
    itemBuilder: (product) => ProductCard(
      product: product,
      isEnglish: _english(context),
      onTap: () => context.push('/products/${product.id}'),
    ),
    onRetry: () => context.read<ProductsCubit>().load(
      categoryId: categoryId,
      supplierId: supplierId,
    ),
  );
}

class SupplierDetailsScreen extends StatelessWidget {
  final String id;
  const SupplierDetailsScreen({required this.id, super.key});
  @override
  Widget build(BuildContext context) => _DetailsScaffold<Supplier>(
    title: AppLocalizations.of(context).catalogSuppliers,
    state: context.watch<SupplierDetailsCubit>().state,
    onRetry: () => context.read<SupplierDetailsCubit>().load(id),
    builder: (supplier) => Column(
      children: [
        _SupplierLogo(supplier: supplier, radius: 36),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(supplier.displayName(_english(context)))),
            if (supplier.isVerified) ...[
              const SizedBox(width: 6),
              const Icon(Icons.verified, color: AppColors.primaryContainer),
            ],
          ],
        ),
      ],
    ),
  );
}

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  const ProductDetailsScreen({required this.id, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? _selectedOfferId;
  int _quantity = 1;
  int _selectedThicknessIndex = 0;
  int _selectedLengthIndex = 1;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductDetailsCubit>().state;
    final l10n = AppLocalizations.of(context);
    if (state.status == CatalogStatus.loading ||
        state.status == CatalogStatus.initial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.status == CatalogStatus.failure || state.item == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.catalogProducts)),
        body: _Retry(
          message: state.errorMessage,
          onRetry: () => context.read<ProductDetailsCubit>().load(widget.id),
        ),
      );
    }

    final product = state.item!;
    final selectedOffer = _selectedOffer(product);
    if (selectedOffer == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l10n.productConfiguration),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Center(
          child: Text(
            l10n.noCatalogResults,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.secondary,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      );
    }

    final thicknessValues = _thicknessValues(product);
    final sizeValue = _sizeValue(product, _english(context));
    final quantity = selectedOffer.normalizeQuantity(
      _quantity == 0 ? selectedOffer.defaultQuantity : _quantity,
    );

    if (thicknessValues.isNotEmpty &&
        _selectedThicknessIndex >= thicknessValues.length) {
      _selectedThicknessIndex = 0;
    }

    return BlocListener<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.isMutating && !current.isMutating,
      listener: (context, cartState) {
        if (cartState.errorMessage == null) {
          AppFeedback.showSuccess(context, l10n.cartItemAdded);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            l10n.productConfiguration,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onBackground,
              fontFamily: 'Tajawal',
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.onBackground,
          ),
        ),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductHero(product: product),
                      SizedBox(height: 14.h),
                      _SpecificationsCard(
                        product: product,
                        selectedOffer: selectedOffer,
                        quantity: quantity,
                        thicknessValues: thicknessValues,
                        selectedThicknessIndex: _selectedThicknessIndex,
                        selectedLengthIndex: _selectedLengthIndex,
                        onThicknessChanged: (index) => setState(() {
                          _selectedThicknessIndex = index;
                        }),
                        onLengthChanged: (index) => setState(() {
                          _selectedLengthIndex = index;
                        }),
                        onQuantityChanged: (value) => setState(() {
                          _quantity = selectedOffer.normalizeQuantity(value);
                        }),
                        sizeValue: sizeValue,
                      ),
                    ],
                  ),
                ),
              ),
              _ProductActionBar(
                offer: selectedOffer,
                quantity: quantity,
                isLoading: context.watch<CartCubit>().state.isMutating,
                onAdd: () => context.read<CartCubit>().addItem(
                  offerId: selectedOffer.offerId,
                  quantity: quantity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offer? _selectedOffer(ProductDetails product) {
    if (product.offers.isEmpty) return null;
    for (final offer in product.offers) {
      if (offer.offerId == _selectedOfferId) return offer;
    }
    return product.offers.first;
  }

  List<double> _thicknessValues(ProductDetails product) {
    final values = <double>{};
    final regex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:mm|مم)');
    for (final offer in product.offers) {
      final source = [
        offer.title,
        offer.specsSummary,
        product.specsSummary,
      ].join(' ');
      for (final match in regex.allMatches(source)) {
        final value = double.tryParse(match.group(1) ?? '');
        if (value != null) values.add(value);
      }
    }
    if (values.isEmpty) {
      return [1.25, 1.5, 1.8, 2.0];
    }
    final sorted = values.toList()..sort();
    return sorted.take(4).toList();
  }

  String _sizeValue(ProductDetails product, bool isEnglish) {
    final values = [
      product.category?.displayName(isEnglish),
      product.specsSummary,
      product.title,
      product.titleAr,
    ];
    for (final value in values) {
      if ((value ?? '').trim().isNotEmpty) {
        final match = RegExp(r'\d+\s*[×xX]\s*\d+').firstMatch(value!);
        if (match != null)
          return match.group(0)!.replaceAll('x', '×').replaceAll('X', '×');
        final simple = RegExp(r'\d+(?:\.\d+)?\s*(?:mm|مم)').firstMatch(value);
        if (simple != null) return simple.group(0)!;
      }
    }
    return '50×50';
  }
}

// ignore: unused_element
class _OfferCard extends StatelessWidget {
  final Offer offer;
  final bool selected;
  final int quantity;
  final VoidCallback onSelect;
  final ValueChanged<int> onQuantityChanged;

  const _OfferCard({
    required this.offer,
    required this.selected,
    required this.quantity,
    required this.onSelect,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final price = offer.pricePerTon?.toString();
    final priceText = [
      ...?price == null ? null : [price],
      ...?offer.currency?.isNotEmpty == true ? [offer.currency] : null,
    ].join(' ');
    final hasUpdate =
        offer.lastUpdatedLabel != null || offer.lastUpdatedAt != null;
    final canIncrease = quantity + offer.quantityStep <= offer.maxQuantity;
    final canDecrease = quantity - offer.quantityStep >= offer.minQuantity;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.surfaceVariant,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _SupplierLogo(supplier: offer.supplier),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        offer.supplier.displayName(_english(context)),
                      ),
                    ),
                    if (offer.supplier.isVerified)
                      const Icon(
                        Icons.verified,
                        color: AppColors.primaryContainer,
                      ),
                  ],
                ),
                subtitle: Text(offer.title ?? offer.specsSummary ?? ''),
                trailing: priceText.isEmpty && !hasUpdate
                    ? null
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (priceText.isNotEmpty) Text(priceText),
                          if (hasUpdate)
                            Text(
                              AppLocalizations.of(context).lastUpdated(
                                offer.lastUpdatedLabel ??
                                    MaterialLocalizations.of(
                                      context,
                                    ).formatMediumDate(
                                      offer.lastUpdatedAt!.toLocal(),
                                    ),
                              ),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                        ],
                      ),
              ),
              if (selected)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      tooltip: AppLocalizations.of(context).decreaseQuantity,
                      onPressed: canDecrease
                          ? () =>
                                onQuantityChanged(quantity - offer.quantityStep)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      '$quantity${offer.unit == null ? '' : ' ${offer.unit}'}',
                    ),
                    IconButton(
                      tooltip: AppLocalizations.of(context).increaseQuantity,
                      onPressed: canIncrease
                          ? () =>
                                onQuantityChanged(quantity + offer.quantityStep)
                          : null,
                      icon: const Icon(Icons.add),
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

class _ProductHero extends StatelessWidget {
  final ProductDetails product;
  const _ProductHero({required this.product});

  @override
  Widget build(BuildContext context) {
    final isEnglish = _english(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.08,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                product.imageUrl?.isNotEmpty == true
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _heroPlaceholder(),
                      )
                    : _heroPlaceholder(),
                if (product.supplier.isVerified)
                  Positioned(
                    top: 14.h,
                    right: 14.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.factory_outlined,
                            color: AppColors.primaryContainer,
                            size: 17,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            l10n.directFromFactory,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            const Icon(
              Icons.factory_outlined,
              color: AppColors.secondary,
              size: 17,
            ),
            SizedBox(width: 5.w),
            Text(
              product.supplier.displayName(isEnglish),
              style: TextStyle(
                fontSize: 12.5.sp,
                color: AppColors.secondary,
                fontFamily: 'Tajawal',
              ),
            ),
            if (product.supplier.isVerified) ...[
              SizedBox(width: 4.w),
              const Icon(
                Icons.verified,
                color: AppColors.primaryContainer,
                size: 16,
              ),
            ],
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          product.displayTitle(isEnglish),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _heroPlaceholder() => Container(
    color: AppColors.surfaceContainerLow,
    child: const Icon(
      Icons.inventory_2_outlined,
      color: AppColors.primary,
      size: 64,
    ),
  );
}

class _SpecificationsCard extends StatelessWidget {
  final ProductDetails product;
  final Offer? selectedOffer;
  final int quantity;
  final List<double> thicknessValues;
  final int selectedThicknessIndex;
  final int selectedLengthIndex;
  final ValueChanged<int> onThicknessChanged;
  final ValueChanged<int> onLengthChanged;
  final ValueChanged<int> onQuantityChanged;
  final String sizeValue;

  const _SpecificationsCard({
    required this.product,
    required this.selectedOffer,
    required this.quantity,
    required this.thicknessValues,
    required this.selectedThicknessIndex,
    required this.selectedLengthIndex,
    required this.onThicknessChanged,
    required this.onLengthChanged,
    required this.onQuantityChanged,
    required this.sizeValue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isEnglish = _english(context);
    final lengthOptions = ['6 متر', '12 متر'];
    final thicknessValuesToShow = thicknessValues.isNotEmpty
        ? thicknessValues
        : [1.25, 1.5, 1.8, 2.0];

    final pricePerTon = selectedOffer?.pricePerTon ?? product.pricePerTon;
    final currency = selectedOffer?.currency ?? product.currency;
    final effectivePrice = selectedOffer?.pricePerTon;
    final displayPrice = pricePerTon == null
        ? '—'
        : _formatMoney(pricePerTon, currency);
    final totalPrice = selectedOffer?.pricePerTon ?? 0;
    final lastUpdatedWidget = selectedOffer == null
        ? null
        : (selectedOffer!.lastUpdatedLabel != null ||
              selectedOffer!.lastUpdatedAt != null)
        ? Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.update_outlined,
                  size: 15,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 5.w),
                Text(
                  selectedOffer!.lastUpdatedLabel ??
                      MaterialLocalizations.of(context).formatMediumDate(
                        selectedOffer!.lastUpdatedAt!.toLocal(),
                      ),
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 10.5.sp,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          )
        : null;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.7),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.technicalSpecifications,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 12.h),
          _SpecField(
            label: 'المقاس',
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(9.r),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.secondary,
                    size: 18,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    sizeValue,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (product.category != null &&
              (product.category!.displayName(isEnglish).isNotEmpty ||
                  product.category!.icon != null))
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Row(
                children: [
                  Icon(
                    _categoryIcon(product.category!.icon),
                    size: 16,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    product.category!.displayName(isEnglish),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.secondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 14.h),
          _SpecField(
            label: 'السماكة (مم)',
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(thicknessValuesToShow.length, (index) {
                final value = thicknessValuesToShow[index];
                final selected =
                    index ==
                    selectedThicknessIndex % thicknessValuesToShow.length;
                return GestureDetector(
                  onTap: () => onThicknessChanged(index),
                  child: Container(
                    width: 48.w,
                    height: 38.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.onBackground
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : AppColors.outlineVariant,
                      ),
                    ),
                    child: Text(
                      value.toStringAsFixed(
                        value.truncateToDouble() == value ? 0 : 1,
                      ),
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.onSurface,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 14.h),
          _SpecField(
            label: 'الطول',
            child: Row(
              children: List.generate(lengthOptions.length, (index) {
                final selected = index == selectedLengthIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onLengthChanged(index),
                    child: Container(
                      height: 38.h,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: index == 0 ? 0 : 8.w),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryFixed
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        lengthOptions[index],
                        style: TextStyle(
                          color: selected
                              ? AppColors.primary
                              : AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 14.h),
          _SpecField(
            label: 'الكمية (طن)',
            child: Container(
              height: 44.h,
              width: 180.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      onPressed: quantity > (selectedOffer?.minQuantity ?? 1)
                          ? () => onQuantityChanged(
                              quantity - (selectedOffer?.quantityStep ?? 1),
                            )
                          : null,
                      icon: const Icon(Icons.remove, color: AppColors.primary),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      quantity.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: quantity < (selectedOffer?.maxQuantity ?? 999)
                          ? () => onQuantityChanged(
                              quantity + (selectedOffer?.quantityStep ?? 1),
                            )
                          : null,
                      icon: const Icon(Icons.add, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.fact_check_outlined,
                size: 16,
                color: AppColors.secondary,
              ),
              SizedBox(width: 5.w),
              Text(
                product.supplier.displayName(isEnglish),
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 11.5.sp,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          ...?lastUpdatedWidget == null ? null : [lastUpdatedWidget],
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'السعر للطن',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 11.sp,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  Text(
                    displayPrice,
                    style: TextStyle(
                      color: AppColors.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
              if (effectivePrice != null)
                Text(
                  _formatMoney(totalPrice * quantity, currency),
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tajawal',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatMoney(num value, String? currency) {
    final formatted = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    return currency == null || currency.isEmpty
        ? formatted
        : '$formatted $currency';
  }
}

class _SpecField extends StatelessWidget {
  final String label;
  final Widget child;

  const _SpecField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.secondary,
          fontFamily: 'Tajawal',
        ),
      ),
      SizedBox(height: 8.h),
      child,
    ],
  );
}

// ignore: unused_element
class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _SpecRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.secondary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.onSurface,
              fontFamily: 'Tajawal',
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProductActionBar extends StatelessWidget {
  final Offer offer;
  final int quantity;
  final bool isLoading;
  final VoidCallback onAdd;
  const _ProductActionBar({
    required this.offer,
    required this.quantity,
    required this.isLoading,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final total = offer.pricePerTon == null
        ? null
        : offer.pricePerTon! * quantity;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.96),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.quantityTons}: $quantity ${offer.unit ?? ''}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    if (offer.pricePerTon != null)
                      Text(
                        '${l10n.pricePerTon}: ${_formatMoney(offer.pricePerTon!, offer.currency)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                  ],
                ),
                if (total != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.estimatedTotal,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.secondary,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        _formatMoney(total, offer.currency),
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onAdd,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.shopping_cart_outlined),
                label: Text(AppLocalizations.of(context).addProductToCart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMoney(num value, String? currency) =>
      '${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)} ${currency ?? ''}'
          .trim();
}

class _SupplierLogo extends StatelessWidget {
  final Supplier supplier;
  final double radius;

  const _SupplierLogo({required this.supplier, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    final logoUrl = supplier.logoUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceContainerLow,
      child: logoUrl?.isNotEmpty == true
          ? ClipOval(
              child: Image.network(
                logoUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.factory_outlined,
                  color: AppColors.primary,
                ),
              ),
            )
          : const Icon(Icons.factory_outlined, color: AppColors.primary),
    );
  }
}

class _CatalogStateView<T> extends StatelessWidget {
  final CatalogListState<T> state;
  final VoidCallback onRetry;
  final Widget Function(List<T> items) builder;

  const _CatalogStateView({
    required this.state,
    required this.onRetry,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status == CatalogStatus.loading ||
        state.status == CatalogStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CatalogStatus.failure) {
      return _Retry(message: state.errorMessage, onRetry: onRetry);
    }
    if (state.status == CatalogStatus.empty) {
      return Center(child: Text(AppLocalizations.of(context).noCatalogResults));
    }
    return builder(state.items);
  }
}

class _ListScaffold<T> extends StatelessWidget {
  final String title;
  final Cubit<CatalogListState<T>> cubit;
  final CatalogListState<T> state;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onRetry;
  const _ListScaffold({
    required this.title,
    required this.cubit,
    required this.state,
    required this.itemBuilder,
    required this.onRetry,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: _content(context),
  );
  Widget _content(BuildContext context) {
    if (state.status == CatalogStatus.loading ||
        state.status == CatalogStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == CatalogStatus.failure) {
      return _Retry(message: state.errorMessage, onRetry: onRetry);
    }
    if (state.status == CatalogStatus.empty) {
      return Center(child: Text(AppLocalizations.of(context).noCatalogResults));
    }
    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (_, index) => itemBuilder(state.items[index]),
    );
  }
}

class _DetailsScaffold<T> extends StatelessWidget {
  final String title;
  final CatalogDetailsState<T> state;
  final VoidCallback onRetry;
  final Widget Function(T item) builder;
  const _DetailsScaffold({
    required this.title,
    required this.state,
    required this.onRetry,
    required this.builder,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body:
        state.status == CatalogStatus.loading ||
            state.status == CatalogStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : state.status == CatalogStatus.failure || state.item == null
        ? _Retry(message: state.errorMessage, onRetry: onRetry)
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: builder(state.item as T),
          ),
  );
}

class _Retry extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _Retry({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(
    child: Card(
      margin: EdgeInsets.all(24.w),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: const BorderSide(color: AppColors.surfaceVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              message ?? AppLocalizations.of(context).genericError,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 15.sp,
                fontFamily: 'Tajawal',
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
    ),
  );
}

bool _english(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'en';
