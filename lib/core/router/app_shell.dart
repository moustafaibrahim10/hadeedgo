import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/service_locator.dart' as di;
import '../theme/app_colors.dart';
import '../../features/cart/presentation/cubits/cart_cubit.dart';
import '../../features/home/presentation/widgets/home_bottom_navigation.dart';

/// Root scaffold that hosts the bottom navigation bar for the five primary
/// tabs (Home, Search, Orders, Cart, Profile) using a
/// [StatefulShellRoute.indexedStack]. Each tab keeps its own navigation state,
/// and pushing a detail route on top opens it full-screen (outside this shell),
/// which is the desired architecture for secondary pages.
class AppShellScaffold extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellScaffold({super.key, required this.navigationShell});

  @override
  State<AppShellScaffold> createState() => _AppShellScaffoldState();
}

class _AppShellScaffoldState extends State<AppShellScaffold> {
  @override
  void initState() {
    super.initState();
    // Load the shared cart summary once so the cart badge is live across tabs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      di.getIt<CartSummaryCubit>().load();
    });
  }

  void _onTabSelected(int index) {
    // Tapping the already-active tab pops that branch back to its root.
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.getIt<CartSummaryCubit>(),
      child: Scaffold(
        // Use the app background so the floating pill's side/bottom gaps blend
        // with the tabs (which share the same background) instead of showing
        // the black window background.
        backgroundColor: AppColors.background,
        body: widget.navigationShell,
        bottomNavigationBar: BlocBuilder<CartSummaryCubit, CartSummaryState>(
          builder: (context, cartState) {
            return HomeBottomNavigation(
              activeIndex: widget.navigationShell.currentIndex,
              cartItemCount: cartState.summary.itemCount,
              onItemSelected: _onTabSelected,
            );
          },
        ),
      ),
    );
  }
}
