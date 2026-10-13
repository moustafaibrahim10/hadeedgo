import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_service.g.dart';

@RestApi()
abstract class OrdersApiService {
  factory OrdersApiService(Dio dio, {String? baseUrl}) = _OrdersApiService;

  @POST('/api/v1/orders')
  Future<HttpResponse<dynamic>> createOrder(@Body() Map<String, dynamic> body);

  @GET('/api/v1/orders')
  Future<HttpResponse<dynamic>> getOrders({
    @Query('filter') String? filter,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET('/api/v1/orders/active')
  Future<HttpResponse<dynamic>> getActiveOrder();

  @GET('/api/v1/orders/{id}')
  Future<HttpResponse<dynamic>> getOrder(@Path('id') String id);

  @GET('/api/v1/orders/{id}/tracking')
  Future<HttpResponse<dynamic>> getTracking(@Path('id') String id);
}
