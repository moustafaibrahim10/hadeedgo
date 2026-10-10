import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_details.dart';
import '../widgets/order_summary_bar.dart';
import '../widgets/product_details_top_bar.dart';
import '../widgets/product_hero.dart';
import '../widgets/quantity_selector.dart';
import '../widgets/spec_selector_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductDetails? product;

  const ProductDetailsScreen({this.product, super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _thicknessIndex = 1;
  int _lengthIndex = 1;
  int _quantity = 10;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final product =
        widget.product ??
        ProductDetails(
          name: l10n.steelIBeam,
          supplier: l10n.egyptianSteel,
          description: l10n.productSpecification,
          price: l10n.productUnitPrice,
          type: ProductDetailsType.beam,
        );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            54.h + MediaQuery.paddingOf(context).top,
          ),
          child: ProductDetailsTopBar(onBack: () => context.pop()),
        ),
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                  children: [
                    ProductHero(product: product),
                    SizedBox(height: 24.h),
                    SpecSelectorCard(
                      label: l10n.sizeFixed,
                      options: const [],
                      selectedIndex: 0,
                      onSelected: (_) {},
                      locked: true,
                      fixedValue: l10n.ipe100,
                    ),
                    SizedBox(height: 16.h),
                    SpecSelectorCard(
                      label: l10n.thickness,
                      options: [
                        l10n.thickness41,
                        l10n.thickness57,
                        l10n.thickness69,
                      ],
                      selectedIndex: _thicknessIndex,
                      onSelected: (index) =>
                          setState(() => _thicknessIndex = index),
                    ),
                    SizedBox(height: 16.h),
                    SpecSelectorCard(
                      label: l10n.length,
                      options: [l10n.sixMeters, l10n.twelveMeters],
                      selectedIndex: _lengthIndex,
                      onSelected: (index) =>
                          setState(() => _lengthIndex = index),
                    ),
                    SizedBox(height: 16.h),
                    QuantitySelector(
                      quantity: _quantity,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                  ],
                ),
              ),
            ),
            OrderSummaryBar(
              quantity: _quantity,
              pricePerTon: product.pricePerTon,
              onAdd: () {},
            ),
          ],
        ),
      ),
    );
  }
}
