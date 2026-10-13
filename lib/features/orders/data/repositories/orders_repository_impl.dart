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
  }) async {
    final payload = <String, dynamic>{'deliveryMethod': deliveryMethod};
    if (deliveryAddressDetails != null && deliveryAddressDetails.isNotEmpty) {
      payload['deliveryAddressDetails'] = deliveryAddressDetails;
    }
    if (deliveryAddressLabel != null && deliveryAddressLabel.isNotEmpty) {
      payload['deliveryAddressLabel'] = deliveryAddressLabel;
    }
    if (pickupSupplierId != null && pickupSupplierId.isNotEmpty) {
      payload['pickupSupplierId'] = pickupSupplierId;
    }
    if (preferredDeliveryDate != null) {
      payload['preferredDeliveryDate'] = preferredDeliveryDate
          .toIso8601String()
          .split('T')
          .first;
    }

    return Order.fromJson(
      await _data(_api.createOrder(payload), 'تعذر إنشاء الطلب'),
    );
  }

  @override
  Future<OrdersPage> getOrders({
    String filter = 'All',
    int page = 1,
    int pageSize = 20,
  }) async => OrdersPage.fromJson(
    await _data(
      _api.getOrders(filter: filter, page: page, pageSize: pageSize),
      'تعذر تحميل الطلبات',
    ),
  );

  @override
  Future<ActiveOrder> getActiveOrder() async => ActiveOrder.fromJson(
    await _data(_api.getActiveOrder(), 'تعذر تحميل الشحنة النشطة'),
  );

  @override
  Future<Order> getOrder(String id) async =>
      Order.fromJson(await _data(_api.getOrder(id), 'تعذر تحميل تفاصيل الطلب'));

  @override
  Future<OrderTracking> getTracking(String id) async => OrderTracking.fromJson(
    await _data(_api.getTracking(id), 'تعذر تحميل تتبع الطلب'),
  );

  Future<Map<String, dynamic>> _data(
    Future<HttpResponse<dynamic>> request,
    String message,
  ) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>)
        throw FailureException(ServerFailure(message));
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) {
        final errorMsg = parsed.errors.isNotEmpty
            ? parsed.errors
                  .map((e) => e.message)
                  .where((m) => m.isNotEmpty)
                  .join(', ')
            : parsed.message ?? message;
        throw FailureException(
          ServerFailure(errorMsg.isNotEmpty ? errorMsg : message),
        );
      }
      final data = raw['data'];
      if (data is! Map<String, dynamic>)
        throw FailureException(ServerFailure(message));
      return data;
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401)
        throw const FailureException(SessionExpiredFailure());
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const FailureException(NetworkFailure());
      }
      final body = error.response?.data;
      String? parsedMessage;
      if (body is Map<String, dynamic>) {
        if (body['message'] != null &&
            body['message'].toString().trim().isNotEmpty) {
          parsedMessage = body['message'].toString();
        } else if (body['errors'] is List &&
            (body['errors'] as List).isNotEmpty) {
          final errs = (body['errors'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => e['message']?.toString())
              .where((m) => m != null && m.isNotEmpty)
              .join(', ');
          if (errs.isNotEmpty) parsedMessage = errs;
        } else if (body['errors'] is Map) {
          final errs = (body['errors'] as Map).values
              .expand((v) => v is List ? v : [v])
              .map((e) => e.toString())
              .where((m) => m.isNotEmpty)
              .join(', ');
          if (errs.isNotEmpty) parsedMessage = errs;
        } else if (body['title'] != null) {
          parsedMessage = body['title'].toString();
        }
      }
      throw FailureException(
        ServerFailure(
          parsedMessage ?? error.response?.statusMessage ?? message,
        ),
      );
    }
  }
}
