import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/usecases/search_usecases.dart';

// ─── Shared helper ────────────────────────────────────────────────────────────

String _msg(Object error) => error is FailureException
    ? error.failure.message
    : error is Failure
    ? error.message
    : 'حدث خطأ غير متوقع';

// ─── 1. ExploreCubit ──────────────────────────────────────────────────────────
// Drives the Explore screen: popular searches, recent searches, categories,
// partner suppliers.  Loaded once on screen open.

enum ExploreStatus { initial, loading, success, failure }

class ExploreState {
  final ExploreStatus status;
  final ExploreData data;
  final String? errorMessage;

  const ExploreState({
    this.status = ExploreStatus.initial,
    this.data = const ExploreData(),
    this.errorMessage,
  });

  ExploreState copyWith({
    ExploreStatus? status,
    ExploreData? data,
    String? errorMessage,
  }) => ExploreState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage,
  );
}

class ExploreCubit extends Cubit<ExploreState> {
  final GetExplore _getExplore;

  ExploreCubit(this._getExplore) : super(const ExploreState());

  Future<void> load() async {
    if (state.status == ExploreStatus.loading) return;
    emit(state.copyWith(status: ExploreStatus.loading, errorMessage: null));
    try {
      final data = await _getExplore();
      emit(state.copyWith(status: ExploreStatus.success, data: data));
    } catch (error) {
      emit(
        state.copyWith(
          status: ExploreStatus.failure,
          errorMessage: _msg(error),
        ),
      );
    }
  }
}

// ─── 2. SearchCubit ───────────────────────────────────────────────────────────
// Drives the active search results view (query + optional filters + pagination).
// Supports appending pages for infinite scroll.

enum SearchStatus { initial, loading, success, loadingMore, failure }

class SearchState {
  final SearchStatus status;
  final SearchResultsPage results;
  final String? activeQuery;
  final String? activeCategoryId;
  final String? activeSupplierId;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.results = const SearchResultsPage(),
    this.activeQuery,
    this.activeCategoryId,
    this.activeSupplierId,
    this.errorMessage,
  });

  SearchState copyWith({
    SearchStatus? status,
    SearchResultsPage? results,
    String? activeQuery,
    String? activeCategoryId,
    String? activeSupplierId,
    String? errorMessage,
  }) => SearchState(
    status: status ?? this.status,
    results: results ?? this.results,
    activeQuery: activeQuery ?? this.activeQuery,
    activeCategoryId: activeCategoryId ?? this.activeCategoryId,
    activeSupplierId: activeSupplierId ?? this.activeSupplierId,
    errorMessage: errorMessage,
  );
}

class SearchCubit extends Cubit<SearchState> {
  final SearchProducts _search;

  SearchCubit(this._search) : super(const SearchState());

  /// Executes a fresh search (resets pagination).
  Future<void> search({
    String? q,
    String? categoryId,
    String? supplierId,
    int pageSize = 20,
  }) async {
    emit(
      SearchState(
        status: SearchStatus.loading,
        activeQuery: q,
        activeCategoryId: categoryId,
        activeSupplierId: supplierId,
      ),
    );
    try {
      final results = await _search(
        q: q,
        categoryId: categoryId,
        supplierId: supplierId,
        page: 1,
        pageSize: pageSize,
      );
      emit(state.copyWith(status: SearchStatus.success, results: results));
    } catch (error) {
      emit(
        state.copyWith(status: SearchStatus.failure, errorMessage: _msg(error)),
      );
    }
  }

  /// Loads the next page and appends items (infinite scroll).
  Future<void> loadMore() async {
    if (state.status == SearchStatus.loadingMore) return;
    if (!state.results.hasMore) return;
    emit(state.copyWith(status: SearchStatus.loadingMore));
    try {
      final nextPage = await _search(
        q: state.activeQuery,
        categoryId: state.activeCategoryId,
        supplierId: state.activeSupplierId,
        page: state.results.page + 1,
        pageSize: state.results.pageSize,
      );
      // Merge old + new items
      final merged = SearchResultsPage(
        query: nextPage.query,
        categoryId: nextPage.categoryId,
        supplierId: nextPage.supplierId,
        totalCount: nextPage.totalCount,
        page: nextPage.page,
        pageSize: nextPage.pageSize,
        items: [...state.results.items, ...nextPage.items],
      );
      emit(state.copyWith(status: SearchStatus.success, results: merged));
    } catch (error) {
      // Keep existing results visible on pagination failure.
      emit(
        state.copyWith(status: SearchStatus.success, errorMessage: _msg(error)),
      );
    }
  }

  void clear() => emit(const SearchState());
}

// ─── 3. RecentSearchesCubit ───────────────────────────────────────────────────
// Manages the recent-searches list: load & clear.

enum RecentSearchesStatus { initial, loading, success, failure }

class RecentSearchesState {
  final RecentSearchesStatus status;
  final List<RecentSearch> items;
  final String? errorMessage;

  const RecentSearchesState({
    this.status = RecentSearchesStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  RecentSearchesState copyWith({
    RecentSearchesStatus? status,
    List<RecentSearch>? items,
    String? errorMessage,
  }) => RecentSearchesState(
    status: status ?? this.status,
    items: items ?? this.items,
    errorMessage: errorMessage,
  );
}

class RecentSearchesCubit extends Cubit<RecentSearchesState> {
  final GetRecentSearches _getRecent;
  final ClearRecentSearches _clearRecent;

  RecentSearchesCubit(this._getRecent, this._clearRecent)
    : super(const RecentSearchesState());

  Future<void> load() async {
    emit(
      state.copyWith(status: RecentSearchesStatus.loading, errorMessage: null),
    );
    try {
      final items = await _getRecent();
      emit(state.copyWith(status: RecentSearchesStatus.success, items: items));
    } catch (error) {
      emit(
        state.copyWith(
          status: RecentSearchesStatus.failure,
          errorMessage: _msg(error),
        ),
      );
    }
  }

  Future<void> clearAll() async {
    try {
      await _clearRecent();
      emit(
        state.copyWith(status: RecentSearchesStatus.success, items: const []),
      );
    } catch (_) {
      // Silently ignore clear errors — not critical.
    }
  }
}
