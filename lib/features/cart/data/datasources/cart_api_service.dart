import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'cart_api_service.g.dart';

@RestApi()
abstract class CartApiService {
  factory CartApiService(Dio dio, {String? baseUrl}) = _CartApiService;

  @GET('/api/v1/cart')
  Future<HttpResponse<dynamic>> getCart();

  @GET('/api/v1/cart/summary')
  Future<HttpResponse<dynamic>> getSummary();

  @POST('/api/v1/cart/items')
  Future<HttpResponse<dynamic>> addItem(@Body() Map<String, dynamic> body);

  @PUT('/api/v1/cart/items/{cartItemId}')
  Future<HttpResponse<dynamic>> updateItem(
    @Path('cartItemId') String cartItemId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/v1/cart/items/{cartItemId}')
  Future<HttpResponse<dynamic>> removeItem(
    @Path('cartItemId') String cartItemId,
  );

  @DELETE('/api/v1/cart/items')
  Future<HttpResponse<dynamic>> clearCart();

  @POST('/api/v1/cart/merge')
  Future<HttpResponse<dynamic>> mergeItem(@Body() Map<String, dynamic> body);
}
