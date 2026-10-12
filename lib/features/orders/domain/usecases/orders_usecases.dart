import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class CreateOrder {
  final OrdersRepository repository;
  const CreateOrder(this.repository);
  Future<Order> call({required String deliveryMethod, String? deliveryAddressDetails, String? deliveryAddressLabel, String? pickupSupplierId, DateTime? preferredDeliveryDate}) => repository.createOrder(deliveryMethod: deliveryMethod, deliveryAddressDetails: deliveryAddressDetails, deliveryAddressLabel: deliveryAddressLabel, pickupSupplierId: pickupSupplierId, preferredDeliveryDate: preferredDeliveryDate);
}

class GetOrders {
  final OrdersRepository repository;
  const GetOrders(this.repository);
  Future<OrdersPage> call({String filter = 'All', int page = 1, int pageSize = 20}) => repository.getOrders(filter: filter, page: page, pageSize: pageSize);
}

class GetActiveOrder {
  final OrdersRepository repository;
  const GetActiveOrder(this.repository);
  Future<ActiveOrder> call() => repository.getActiveOrder();
}

class GetOrder {
  final OrdersRepository repository;
  const GetOrder(this.repository);
  Future<Order> call(String id) => repository.getOrder(id);
}

class GetOrderTracking {
  final OrdersRepository repository;
  const GetOrderTracking(this.repository);
  Future<OrderTracking> call(String id) => repository.getTracking(id);
}