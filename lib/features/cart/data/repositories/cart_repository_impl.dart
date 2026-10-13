import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/cart_entities.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_api_service.dart';

class CartRepositoryImpl implements CartRepository {
  final CartApiService _api;
  const CartRepositoryImpl(this._api);

  @override
  Future<Cart> getCart() async {
    final response = await _request(_api.getCart(), 'تعذر تحميل السلة');
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FailureException(ServerFailure('تعذر تحميل السلة'));
    }
    return Cart.fromJson(data);
  }

  @override
  Future<CartSummary> getSummary() async {
    final response = await _request(_api.getSummary(), 'تعذر تحميل ملخص السلة');
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FailureException(ServerFailure('تعذر تحميل ملخص السلة'));
    }
    return CartSummary.fromJson(data);
  }

  @override
  Future<Cart> addItem({required String offerId, required int quantity}) =>
      _mutate(
        _api.addItem({'offerId': offerId, 'quantity': quantity}),
        'تعذر إضافة المنتج إلى السلة',
      );

  @override
  Future<Cart> updateItem({
    required String cartItemId,
    required int quantity,
  }) => _mutate(
    _api.updateItem(cartItemId, {'quantity': quantity}),
    'تعذر تحديث كمية المنتج',
  );

  @override
  Future<Cart> removeItem(String cartItemId) =>
      _mutate(_api.removeItem(cartItemId), 'تعذر حذف المنتج من السلة');

  @override
  Future<Cart> clearCart() async {
    await _request(_api.clearCart(), 'تعذر إفراغ السلة');
    return const Cart();
  }

  @override
  Future<Cart> mergeItem({required String offerId, required int quantity}) =>
      _mutate(
        _api.mergeItem({
          'item': {'offerId': offerId, 'quantity': quantity},
        }),
        'تعذر دمج السلة',
      );

  Future<Cart> _mutate(
    Future<HttpResponse<dynamic>> request,
    String message,
  ) async {
    final data = await _request(request, message);
    final raw = data['data'];
    if (raw is! Map<String, dynamic>) return getCart();
    final cart = raw['cart'];
    return Cart.fromJson(cart is Map<String, dynamic> ? cart : raw);
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
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) {
        throw FailureException(ServerFailure(parsed.message ?? message));
      }
      return raw;
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
      throw FailureException(ServerFailure(_errorMessage(error, message)));
    }
  }

  String _errorMessage(DioException error, String fallback) {
    final body = error.response?.data;
    if (body is Map<String, dynamic>) {
      final message = body['message']?.toString();
      if (message != null && message.isNotEmpty) return message;
    }
    return error.response?.statusMessage ?? fallback;
  }
}
