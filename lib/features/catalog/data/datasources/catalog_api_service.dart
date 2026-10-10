import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'catalog_api_service.g.dart';

@RestApi()
abstract class CatalogApiService {
  factory CatalogApiService(Dio dio, {String? baseUrl}) = _CatalogApiService;

  @GET('/api/v1/catalog/categories')
  Future<HttpResponse<dynamic>> getCategories();

  @GET('/api/v1/catalog/suppliers')
  Future<HttpResponse<dynamic>> getSuppliers();

  @GET('/api/v1/catalog/suppliers/{id}')
  Future<HttpResponse<dynamic>> getSupplierDetails(@Path('id') String id);

  @GET('/api/v1/catalog/offers/featured')
  Future<HttpResponse<dynamic>> getFeaturedOffers(@Query('limit') int? limit);

  @GET('/api/v1/catalog/products')
  Future<HttpResponse<dynamic>> getProducts({
    @Query('categoryId') String? categoryId,
    @Query('supplierId') String? supplierId,
  });

  @GET('/api/v1/catalog/products/{id}')
  Future<HttpResponse<dynamic>> getProductDetails(@Path('id') String id);
}
