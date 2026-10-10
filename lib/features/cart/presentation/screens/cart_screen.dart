import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/home_app_bar.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../cubits/cart_cubit.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocListener(
    listeners: [
      BlocListener<CartCubit, CartState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) =>
            AppFeedback.showError(context, state.errorMessage!),
      ),
      BlocListener<CartCubit, CartState>(
        listenWhen: (previous, current) =>
            previous.cart != current.cart &&
            current.status != CartStatus.loading,
        listener: (context, _) => context.read<CartSummaryCubit>().load(),
      ),
    ],
    child: const _CartView(),
  );
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state.status == CartStatus.loading ||
                state.status == CartStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == CartStatus.failure) {
              return _CartRetry(onRetry: context.read<CartCubit>().load);
            }
            if (state.status == CartStatus.empty) {
              return Center(
                child: Text(
                  l10n.emptyCart,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }
            return _CartContent(state: state);
          },
        ),
        bottomNavigationBar: HomeBottomNavigation(
          activeIndex: 3,
          onItemSelected: (index) {
            if (index == 0) context.go('/home');
            if (index == 1) context.go('/search');
            if (index == 2) context.go('/orders');
            if (index == 4) context.go('/profile');
          },
        ),
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  final CartState state;
  const _CartContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<CartCubit>();
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.cartTitle,
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: state.isMutating ? null : cubit.clearCart,
                    icon: const Icon(Icons.delete_sweep_outlined),
                    label: Text(l10n.clearCart),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ...state.cart.items.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: CartItemCard(
                    item: item,
                    onRemove: () => cubit.removeItem(item.cartItemId),
                    onDecrease: () => cubit.updateItem(
                      item: item,
                      quantity: item.quantity - item.quantityStep,
                    ),
                    onIncrease: () => cubit.updateItem(
                      item: item,
                      quantity: item.quantity + item.quantityStep,
                    ),
                  ),
                ),
              ),
              if (state.isMutating) ...[
                SizedBox(height: 4.h),
                const LinearProgressIndicator(),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: CartSummaryCard(
            cart: state.cart,
            onCheckout: () => context.push('/checkout-confirmation'),
          ),
        ),
      ],
    );
  }
}

class _CartRetry extends StatelessWidget {
  final VoidCallback onRetry;
  const _CartRetry({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(AppLocalizations.of(context).cartLoadError),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context).retry),
        ),
      ],
    ),
  );
}
