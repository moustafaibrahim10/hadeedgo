import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'search_api_service.g.dart';

@RestApi()
abstract class SearchApiService {
  factory SearchApiService(Dio dio, {String? baseUrl}) = _SearchApiService;

  /// شاشة Explore — مقاسات شائعة، أقسام، مصانع، بحث أخير.
  @GET('/api/v1/search/explore')
  Future<HttpResponse<dynamic>> getExplore();

  /// فلاتر البحث — تصنيفات ومصانع.
  @GET('/api/v1/search/filters')
  Future<HttpResponse<dynamic>> getFilters();

  /// بحث المنتجات مع فلترة وpagination.
  @GET('/api/v1/search')
  Future<HttpResponse<dynamic>> search({
    @Query('q') String? q,
    @Query('categoryId') String? categoryId,
    @Query('supplierId') String? supplierId,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  /// عمليات البحث الأخيرة.
  @GET('/api/v1/search/recent')
  Future<HttpResponse<dynamic>> getRecentSearches();

  /// مسح عمليات البحث الأخيرة.
  @DELETE('/api/v1/search/recent')
  Future<HttpResponse<dynamic>> clearRecentSearches();
}
