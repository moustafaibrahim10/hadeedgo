import '../../domain/entities/search_entities.dart';

abstract interface class SearchRepository {
  Future<ExploreData> getExplore();
  Future<SearchFilters> getFilters();
  Future<SearchResultsPage> search({
    String? q,
    String? categoryId,
    String? supplierId,
    int page = 1,
    int pageSize = 20,
  });
  Future<List<RecentSearch>> getRecentSearches();
  Future<void> clearRecentSearches();
}
