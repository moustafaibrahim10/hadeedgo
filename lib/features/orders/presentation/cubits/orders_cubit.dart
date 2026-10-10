import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/orders_usecases.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState {
  final OrdersStatus status;
  final OrdersPage page;
  final String filter;
  final String? errorMessage;
  const OrdersState({this.status = OrdersStatus.initial, this.page = const OrdersPage(), this.filter = 'All', this.errorMessage});
  OrdersState copyWith({OrdersStatus? status, OrdersPage? page, String? filter, String? errorMessage}) => OrdersState(status: status ?? this.status, page: page ?? this.page, filter: filter ?? this.filter, errorMessage: errorMessage);
}

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders _getOrders;
  OrdersCubit(this._getOrders) : super(const OrdersState());
  Future<void> load({String? filter, int page = 1}) async {
    final selected = filter ?? state.filter;
    emit(state.copyWith(status: OrdersStatus.loading, filter: selected, errorMessage: null));
    try { emit(state.copyWith(status: OrdersStatus.success, page: await _getOrders(filter: selected, page: page))); }
    catch (error) { emit(state.copyWith(status: OrdersStatus.failure, errorMessage: _message(error))); }
  }
}

class OrderDetailsState {
  final OrdersStatus status;
  final Order? order;
  final OrderTracking? tracking;
  final String? errorMessage;
  const OrderDetailsState({this.status = OrdersStatus.initial, this.order, this.tracking, this.errorMessage});
}

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrder _getOrder;
  final GetOrderTracking _getTracking;
  OrderDetailsCubit(this._getOrder, this._getTracking) : super(const OrderDetailsState());
  Future<void> load(String id) async {
    emit(const OrderDetailsState(status: OrdersStatus.loading));
    try { emit(OrderDetailsState(status: OrdersStatus.success, order: await _getOrder(id), tracking: await _getTracking(id))); }
    catch (error) { emit(OrderDetailsState(status: OrdersStatus.failure, errorMessage: _message(error))); }
  }
}

class CreateOrderState {
  final bool isSubmitting;
  final Order? order;
  final String? errorMessage;
  const CreateOrderState({this.isSubmitting = false, this.order, this.errorMessage});
}

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final CreateOrder _createOrder;
  CreateOrderCubit(this._createOrder) : super(const CreateOrderState());

  Future<void> create({String deliveryMethod = 'Delivery'}) async {
    if (state.isSubmitting) return;
    emit(const CreateOrderState(isSubmitting: true));
    try {
      final order = await _createOrder(deliveryMethod: deliveryMethod);
      emit(CreateOrderState(order: order));
    } catch (error) {
      emit(CreateOrderState(errorMessage: _message(error)));
    }
  }
}

String _message(Object error) => error is FailureException ? error.failure.message : error is Failure ? error.message : 'تعذر تحميل الطلب';