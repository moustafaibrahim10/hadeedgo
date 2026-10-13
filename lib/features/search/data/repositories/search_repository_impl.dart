import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_api_service.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchApiService _api;
  const SearchRepositoryImpl(this._api);

  // ─── Public API ──────────────────────────────────────────────────────────────

  @override
  Future<ExploreData> getExplore() async => ExploreData.fromJson(
    await _data(_api.getExplore(), 'تعذر تحميل صفحة الاستكشاف'),
  );

  @override
  Future<SearchFilters> getFilters() async => SearchFilters.fromJson(
    await _data(_api.getFilters(), 'تعذر تحميل الفلاتر'),
  );

  @override
  Future<SearchResultsPage> search({
    String? q,
    String? categoryId,
    String? supplierId,
    int page = 1,
    int pageSize = 20,
  }) async => SearchResultsPage.fromJson(
    await _data(
      _api.search(
        q: q,
        categoryId: categoryId,
        supplierId: supplierId,
        page: page,
        pageSize: pageSize,
      ),
      'تعذر تحميل نتائج البحث',
    ),
  );

  @override
  Future<List<RecentSearch>> getRecentSearches() async {
    final data = await _data(
      _api.getRecentSearches(),
      'تعذر تحميل البحث الأخير',
    );
    final raw = data['items'] ?? data['data'] ?? data;
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(RecentSearch.fromJson)
          .toList();
    }
    return const [];
  }

  @override
  Future<void> clearRecentSearches() async =>
      _data(_api.clearRecentSearches(), 'تعذر مسح البحث الأخير');

  // ─── Private Helpers ─────────────────────────────────────────────────────────

  /// Unwraps `data` from a standard `{ success, message, data, errors }` envelope.
  Future<Map<String, dynamic>> _data(
    Future<HttpResponse<dynamic>> request,
    String fallback,
  ) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>)
        throw FailureException(ServerFailure(fallback));
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) {
        throw FailureException(ServerFailure(parsed.message ?? fallback));
      }
      final data = raw['data'];
      // Some endpoints (clearRecentSearches) return no data object — return empty map.
      return data is Map<String, dynamic> ? data : const {};
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const FailureException(SessionExpiredFailure());
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const FailureException(NetworkFailure());
      }
      final body = error.response?.data;
      final message = body is Map<String, dynamic>
          ? body['message']?.toString()
          : null;
      throw FailureException(
        ServerFailure(
          message?.isNotEmpty == true
              ? message!
              : error.response?.statusMessage ?? fallback,
        ),
      );
    }
  }
}
