import '../entities/search_entities.dart';
import '../repositories/search_repository.dart';

class GetExplore {
  final SearchRepository repository;
  const GetExplore(this.repository);
  Future<ExploreData> call() => repository.getExplore();
}

class GetSearchFilters {
  final SearchRepository repository;
  const GetSearchFilters(this.repository);
  Future<SearchFilters> call() => repository.getFilters();
}

class SearchProducts {
  final SearchRepository repository;
  const SearchProducts(this.repository);
  Future<SearchResultsPage> call({
    String? q,
    String? categoryId,
    String? supplierId,
    int page = 1,
    int pageSize = 20,
  }) => repository.search(
    q: q,
    categoryId: categoryId,
    supplierId: supplierId,
    page: page,
    pageSize: pageSize,
  );
}

class GetRecentSearches {
  final SearchRepository repository;
  const GetRecentSearches(this.repository);
  Future<List<RecentSearch>> call() => repository.getRecentSearches();
}

class ClearRecentSearches {
  final SearchRepository repository;
  const ClearRecentSearches(this.repository);
  Future<void> call() => repository.clearRecentSearches();
}
