import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_product.dart';
import '../widgets/factory_header_card.dart';
import '../widgets/product_filter_chips.dart';
import '../widgets/search_product_card.dart';
import '../widgets/search_top_bar.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final products = [
      SearchProduct(
        name: l10n.rebar12,
        description: l10n.rebarDescription,
        price: l10n.rebar12Price,
        type: SearchProductType.rebar,
        accent: true,
      ),
      SearchProduct(
        name: l10n.rebar16,
        description: l10n.rebarDescription,
        price: l10n.rebar16Price,
        type: SearchProductType.rebar,
      ),
      SearchProduct(
        name: l10n.coil8,
        description: l10n.coilDescription,
        price: l10n.coil8Price,
        type: SearchProductType.coil,
      ),
    ];

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
          child: SearchTopBar(
            onBack: () => context.go('/home'),
            onSearch: () {},
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 110.h),
            children: [
              const FactoryHeaderCard(),
              SizedBox(height: 20.h),
              ProductFilterChips(
                selectedIndex: _selectedFilter,
                onSelected: (index) => setState(() => _selectedFilter = index),
              ),
              SizedBox(height: 20.h),
              ...products.map(
                (product) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: SearchProductCard(
                    product: product,
                    onAdd: () {},
                    onTap: () => context.push('/products'),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: HomeBottomNavigation(
          activeIndex: 1,
          onItemSelected: _onNavigationSelected,
        ),
      ),
    );
  }

  void _onNavigationSelected(int index) {
    if (index == 0) context.go('/home');
    if (index == 2) context.go('/orders');
    if (index == 3) context.go('/cart');
  }
}
