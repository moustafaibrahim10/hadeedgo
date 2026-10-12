import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Order> createOrder({
    required String deliveryMethod,
    String? deliveryAddressDetails,
    String? deliveryAddressLabel,
    String? pickupSupplierId,
    DateTime? preferredDeliveryDate,
  });
  Future<OrdersPage> getOrders({String filter = 'All', int page = 1, int pageSize = 20});
  Future<ActiveOrder> getActiveOrder();
  Future<Order> getOrder(String id);
  Future<OrderTracking> getTracking(String id);
}