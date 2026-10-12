import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubits/search_cubit.dart';
import '../widgets/explore_view.dart';
import '../widgets/search_results_view.dart';
import '../widgets/search_top_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final ScrollController _scrollController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200.h) {
      context.read<SearchCubit>().loadMore();
    }
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      context.read<SearchCubit>().clear();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _triggerSearch(query.trim());
    });
  }

  void _triggerSearch(String query, {String? categoryId}) {
    _debounce?.cancel();
    if (query.trim().isEmpty) return;
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    _searchFocusNode.unfocus();
    context.read<SearchCubit>().search(
          q: query.trim(),
          categoryId: categoryId,
        );
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<SearchCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = context.watch<SearchCubit>().state;
    final exploreState = context.watch<ExploreCubit>().state;
    final recentState = context.watch<RecentSearchesCubit>().state;

    // Merge recent searches from RecentSearchesCubit into ExploreData if available
    final mergedExploreData = exploreState.data.copyWith(
      recentSearches: recentState.items.isNotEmpty
          ? recentState.items
          : exploreState.data.recentSearches,
    );

    final isSearching = _searchController.text.trim().isNotEmpty ||
        searchState.status != SearchStatus.initial;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
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
          child: SearchTopBar(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onBack: () {
              if (isSearching) {
                _clearSearch();
              } else {
                context.go('/home');
              }
            },
            onChanged: _onQueryChanged,
            onSubmitted: (query) => _triggerSearch(query),
            onClear: _clearSearch,
          ),
        ),
        body: SafeArea(
          child: isSearching
              ? SearchResultsView(
                  state: searchState,
                  scrollController: _scrollController,
                  filterCategories: exploreState.data.categories,
                  onSelectCategoryFilter: (categoryId) {
                    context.read<SearchCubit>().search(
                          q: _searchController.text.trim(),
                          categoryId: categoryId,
                        );
                  },
                  onSelectProduct: (product) => context.push('/products/${product.id}'),
                  onRetry: () => _triggerSearch(_searchController.text),
                  onClear: _clearSearch,
                )
              : ExploreView(
                  data: mergedExploreData,
                  isLoading: exploreState.status == ExploreStatus.loading,
                  errorMessage: exploreState.errorMessage,
                  onRefresh: () async {
                    await Future.wait([
                      context.read<ExploreCubit>().load(),
                      context.read<RecentSearchesCubit>().load(),
                    ]);
                  },
                  onSelectQuery: (query) => _triggerSearch(query),
                  onSelectCategory: (cat) {
                    context.push('/products?categoryId=${cat.id}');
                  },
                  onSelectSupplier: (supplier) {
                    context.push('/suppliers/${supplier.id}');
                  },
                  onClearRecent: () {
                    context.read<RecentSearchesCubit>().clearAll();
                  },
                  onViewAllCategories: () => context.push('/categories'),
                  onViewAllSuppliers: () => context.push('/suppliers'),
                ),
        ),
      ),
    );
  }
}
