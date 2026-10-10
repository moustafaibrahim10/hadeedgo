import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_content.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/category_grid.dart';
import '../widgets/featured_product_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_bottom_navigation.dart';
import '../widgets/market_news_section.dart';
import '../widgets/partner_mills_list.dart';
import '../../../cart/presentation/cubits/cart_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous.isMutating && !current.isMutating,
      listener: (context, cartState) {
        if (cartState.errorMessage != null) {
          AppFeedback.showError(context, cartState.errorMessage!);
        } else {
          context.read<CartSummaryCubit>().load();
          AppFeedback.showSuccess(
            context,
            AppLocalizations.of(context).cartItemAdded,
          );
        }
      },
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.failure &&
              state.errorMessage != null) {
            AppFeedback.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
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
                64.h + MediaQuery.paddingOf(context).top,
              ),
              child: const HomeAppBar(),
            ),
            body: _buildBody(context, state),
            bottomNavigationBar: HomeBottomNavigation(
              cartItemCount: context
                  .watch<CartSummaryCubit>()
                  .state
                  .summary
                  .itemCount,
              onItemSelected: (index) {
                if (index == 1) context.go('/search');
                if (index == 2) context.go('/orders');
                if (index == 3) context.go('/cart');
                if (index == 4) context.go('/profile');
              },
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.initial ||
        state.status == HomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == HomeStatus.failure || state.content == null) {
      final l10n = AppLocalizations.of(context);
      return Center(
        child: ElevatedButton.icon(
          onPressed: () => context.read<HomeCubit>().loadHome(force: true),
          icon: const Icon(Icons.refresh),
          label: Text(l10n.update),
        ),
      );
    }

    final content = state.content!;
    final isCartMutating = context.watch<CartCubit>().state.isMutating;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().loadHome(force: true),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.activeShipment != null) ...[
                      _ShipmentBanner(shipment: content.activeShipment!),
                      SizedBox(height: 20.h),
                    ],
                    _SectionTitle(
                      title: AppLocalizations.of(context).featuredOffers,
                    ),
                    SizedBox(height: 8.h),
                    if (content.featuredOffers.isNotEmpty)
                      _FeaturedOffersCarousel(
                        offers: content.featuredOffers,
                        onOfferTap: (offer) => _openOffer(context, offer),
                        onAddToCart: isCartMutating
                            ? null
                            : (offer, quantity) => context
                                  .read<CartCubit>()
                                  .addItem(
                                    offerId: offer.offerId,
                                    quantity: quantity,
                                  ),
                      ),
                    if (content.categories.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      _SectionTitle(
                        title: AppLocalizations.of(context).categories,
                      ),
                      SizedBox(height: 8.h),
                      CategoryGrid(
                        categories: content.categories,
                        onCategoryTap: (category) =>
                            context.push('/products?categoryId=${category.id}'),
                      ),
                    ],
                    if (content.partnerSuppliers.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _SectionTitle(
                        title: AppLocalizations.of(context).partnerMills,
                      ),
                      SizedBox(height: 8.h),
                      PartnerMillsList(
                        suppliers: content.partnerSuppliers,
                        onSupplierTap: (supplier) =>
                            context.push('/suppliers/${supplier.id}'),
                      ),
                    ],
                    if (content.marketNews.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      _SectionTitle(
                        title: AppLocalizations.of(context).marketNews,
                      ),
                      SizedBox(height: 8.h),
                      MarketNewsSection(news: content.marketNews),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openOffer(BuildContext context, FeaturedOffer offer) {
    context.push('/products/${offer.productId}');
  }
}

class _FeaturedOffersCarousel extends StatefulWidget {
  final List<FeaturedOffer> offers;
  final ValueChanged<FeaturedOffer> onOfferTap;
  final Future<void> Function(FeaturedOffer offer, int quantity)?
  onAddToCart;

  const _FeaturedOffersCarousel({
    required this.offers,
    required this.onOfferTap,
    required this.onAddToCart,
  });

  @override
  State<_FeaturedOffersCarousel> createState() =>
      _FeaturedOffersCarouselState();
}

class _FeaturedOffersCarouselState extends State<_FeaturedOffersCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 380.h,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(),
            pageSnapping: true,
            padEnds: false,
            itemCount: widget.offers.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 10.w),
                child: RepaintBoundary(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FeaturedProductCard(
                      offer: widget.offers[index],
                      onTap: () => widget.onOfferTap(widget.offers[index]),
                      onAddToCart: widget.onAddToCart == null
                          ? null
                          : (quantity) => widget.onAddToCart!(
                                widget.offers[index],
                                quantity,
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.offers.length > 1) ...[
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.offers.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: index == _currentPage ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: index == _currentPage
                      ? AppColors.primaryContainer
                      : AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ShipmentBanner extends StatelessWidget {
  final ActiveShipment shipment;
  const _ShipmentBanner({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = shipment.message?.isNotEmpty == true
        ? shipment.message!
        : '${shipment.status ?? l10n.shipmentStatus}${shipment.etaMinutes == null ? '' : ' - ${shipment.etaMinutes} min'}';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        fontFamily: 'Tajawal',
      ),
    );
  }
}
