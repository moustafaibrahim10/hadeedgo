import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_api_service.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersApiService _api;
  const OrdersRepositoryImpl(this._api);

  @override
  Future<Order> createOrder({
    required String deliveryMethod,
    String? deliveryAddressDetails,
    String? deliveryAddressLabel,
    String? pickupSupplierId,
    DateTime? preferredDeliveryDate,
  }) async => Order.fromJson(await _data(
    _api.createOrder({
      'deliveryMethod': deliveryMethod,
      'deliveryAddressDetails': deliveryAddressDetails,
      'deliveryAddressLabel': deliveryAddressLabel,
      'pickupSupplierId': pickupSupplierId,
      'preferredDeliveryDate': preferredDeliveryDate?.toIso8601String().split('T').first,
    }),
    'تعذر إنشاء الطلب',
  ));

  @override
  Future<OrdersPage> getOrders({String filter = 'All', int page = 1, int pageSize = 20}) async =>
      OrdersPage.fromJson(await _data(
        _api.getOrders(filter: filter, page: page, pageSize: pageSize),
        'تعذر تحميل الطلبات',
      ));

  @override
  Future<Order> getActiveOrder() async => Order.fromJson(await _data(_api.getActiveOrder(), 'تعذر تحميل الشحنة النشطة'));

  @override
  Future<Order> getOrder(String id) async => Order.fromJson(await _data(_api.getOrder(id), 'تعذر تحميل تفاصيل الطلب'));

  @override
  Future<OrderTracking> getTracking(String id) async => OrderTracking.fromJson(await _data(_api.getTracking(id), 'تعذر تحميل تتبع الطلب'));

  Future<Map<String, dynamic>> _data(Future<HttpResponse<dynamic>> request, String message) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>) throw FailureException(ServerFailure(message));
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) throw FailureException(ServerFailure(parsed.message ?? message));
      final data = raw['data'];
      if (data is! Map<String, dynamic>) throw FailureException(ServerFailure(message));
      return data;
    } on FailureException { rethrow; }
    on DioException catch (error) {
      if (error.response?.statusCode == 401) throw const FailureException(SessionExpiredFailure());
      throw FailureException(ServerFailure(error.response?.statusMessage ?? message));
    }
  }
}