import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/catalog_entities.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_api_service.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogApiService _api;

  const CatalogRepositoryImpl(this._api);

  @override
  Future<List<Category>> getCategories() async =>
      _list(_api.getCategories(), Category.fromJson, 'تعذر تحميل التصنيفات');

  @override
  Future<List<Supplier>> getSuppliers() async =>
      _list(_api.getSuppliers(), Supplier.fromJson, 'تعذر تحميل الموردين');

  @override
  Future<Supplier> getSupplierDetails(String id) async => _object(
    _api.getSupplierDetails(id),
    Supplier.fromJson,
    'تعذر تحميل بيانات المورد',
  );

  @override
  Future<List<Offer>> getFeaturedOffers({int? limit}) =>
      _list(_api.getFeaturedOffers(limit), Offer.fromJson, 'تعذر تحميل العروض');

  @override
  Future<List<Product>> getProducts({String? categoryId, String? supplierId}) =>
      _list(
        _api.getProducts(categoryId: categoryId, supplierId: supplierId),
        Product.fromJson,
        'تعذر تحميل المنتجات',
      );

  @override
  Future<ProductDetails> getProductDetails(String id) => _object(
    _api.getProductDetails(id),
    ProductDetails.fromJson,
    'تعذر تحميل تفاصيل المنتج',
  );

  Future<List<T>> _list<T>(
    Future<HttpResponse<dynamic>> request,
    T Function(Map<String, dynamic>) mapper,
    String message,
  ) async {
    final data = await _request(request, message);
    final raw = data['data'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().map(mapper).toList();
  }

  Future<T> _object<T>(
    Future<HttpResponse<dynamic>> request,
    T Function(Map<String, dynamic>) mapper,
    String message,
  ) async {
    final data = await _request(request, message);
    final raw = data['data'];
    if (raw is! Map<String, dynamic>) {
      throw FailureException(ServerFailure(message));
    }
    return mapper(raw);
  }

  Future<Map<String, dynamic>> _request(
    Future<HttpResponse<dynamic>> request,
    String message,
  ) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw FailureException(ServerFailure(message));
      }
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        raw,
        (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
      );
      if (!parsed.success) {
        throw FailureException(ServerFailure(parsed.message ?? message));
      }
      return raw;
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw FailureException(const SessionExpiredFailure());
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const FailureException(NetworkFailure());
      }
      throw FailureException(ServerFailure(_responseMessage(error, message)));
    }
  }

  String _responseMessage(DioException error, String fallback) {
    if (error.response?.statusCode == 500) return fallback;
    final body = error.response?.data;
    if (body is Map<String, dynamic>) {
      final message = body['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
      final errors = body['errors'];
      if (errors is List) {
        for (final item in errors) {
          if (item is Map<String, dynamic>) {
            final itemMessage = item['message']?.toString();
            if (itemMessage != null && itemMessage.isNotEmpty) {
              return itemMessage;
            }
          }
        }
      }
    }
    return error.response?.statusMessage ?? fallback;
  }
}
