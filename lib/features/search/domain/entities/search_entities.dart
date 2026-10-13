import '../../../catalog/domain/entities/catalog_entities.dart';

// ─── Search-specific Category (has extra `subtitle` field) ───────────────────

class SearchCategory {
  final String id;
  final String? name;
  final String? nameAr;
  final String? icon;
  final String? subtitle;
  final int productCount;

  const SearchCategory({
    required this.id,
    this.name,
    this.nameAr,
    this.icon,
    this.subtitle,
    this.productCount = 0,
  });

  factory SearchCategory.fromJson(Map<String, dynamic> json) => SearchCategory(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString(),
    nameAr: json['nameAr']?.toString(),
    icon: json['icon']?.toString(),
    subtitle: json['subtitle']?.toString(),
    productCount: _int(json['productCount']) ?? 0,
  );

  String displayName(bool isEnglish) =>
      (isEnglish ? name : nameAr)?.trim().isNotEmpty == true
      ? (isEnglish ? name : nameAr)!
      : (name ?? nameAr ?? '');
}

// ─── Popular Search ───────────────────────────────────────────────────────────

class PopularSearch {
  final String? label;
  final String? query;

  const PopularSearch({this.label, this.query});

  factory PopularSearch.fromJson(Map<String, dynamic> json) => PopularSearch(
    label: json['label']?.toString(),
    query: json['query']?.toString(),
  );
}

// ─── Recent Search ────────────────────────────────────────────────────────────

class RecentSearch {
  final String id;
  final String? query;
  final DateTime? searchedAt;

  const RecentSearch({required this.id, this.query, this.searchedAt});

  factory RecentSearch.fromJson(Map<String, dynamic> json) => RecentSearch(
    id: json['id']?.toString() ?? '',
    query: json['query']?.toString(),
    searchedAt: DateTime.tryParse(json['searchedAt']?.toString() ?? ''),
  );
}

// ─── Explore Data ─────────────────────────────────────────────────────────────
// Response shape: GET /api/v1/search/explore

class ExploreData {
  final List<PopularSearch> popularSearches;
  final List<RecentSearch> recentSearches;
  final List<SearchCategory> categories;
  final List<Supplier> partnerSuppliers;

  const ExploreData({
    this.popularSearches = const [],
    this.recentSearches = const [],
    this.categories = const [],
    this.partnerSuppliers = const [],
  });

  factory ExploreData.fromJson(Map<String, dynamic> json) => ExploreData(
    popularSearches: _list(json['popularSearches'], PopularSearch.fromJson),
    recentSearches: _list(json['recentSearches'], RecentSearch.fromJson),
    categories: _list(json['categories'], SearchCategory.fromJson),
    partnerSuppliers: _list(json['partnerSuppliers'], Supplier.fromJson),
  );

  ExploreData copyWith({
    List<PopularSearch>? popularSearches,
    List<RecentSearch>? recentSearches,
    List<SearchCategory>? categories,
    List<Supplier>? partnerSuppliers,
  }) => ExploreData(
    popularSearches: popularSearches ?? this.popularSearches,
    recentSearches: recentSearches ?? this.recentSearches,
    categories: categories ?? this.categories,
    partnerSuppliers: partnerSuppliers ?? this.partnerSuppliers,
  );
}

// ─── Search Filters ───────────────────────────────────────────────────────────
// Response shape: GET /api/v1/search/filters

class SearchFilters {
  final List<SearchCategory> categories;
  final List<Supplier> partnerSuppliers;

  const SearchFilters({
    this.categories = const [],
    this.partnerSuppliers = const [],
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) => SearchFilters(
    categories: _list(json['categories'], SearchCategory.fromJson),
    partnerSuppliers: _list(json['partnerSuppliers'], Supplier.fromJson),
  );
}

// ─── Search Results Page ──────────────────────────────────────────────────────
// Response shape: GET /api/v1/search

class SearchResultsPage {
  final String? query;
  final String? categoryId;
  final String? supplierId;
  final int totalCount;
  final int page;
  final int pageSize;
  final List<Product> items;

  const SearchResultsPage({
    this.query,
    this.categoryId,
    this.supplierId,
    this.totalCount = 0,
    this.page = 1,
    this.pageSize = 20,
    this.items = const [],
  });

  bool get hasMore => items.length < totalCount;

  factory SearchResultsPage.fromJson(Map<String, dynamic> json) =>
      SearchResultsPage(
        query: json['query']?.toString(),
        categoryId: json['categoryId']?.toString(),
        supplierId: json['supplierId']?.toString(),
        totalCount: _int(json['totalCount']) ?? 0,
        page: _int(json['page']) ?? 1,
        pageSize: _int(json['pageSize']) ?? 20,
        items: _list(json['items'], Product.fromJson),
      );
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) mapper) =>
    value is List
    ? value.whereType<Map<String, dynamic>>().map(mapper).toList()
    : const [];

int? _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
