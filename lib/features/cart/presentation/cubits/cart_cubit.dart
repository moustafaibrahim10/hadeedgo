import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_entities.dart';
import '../../domain/usecases/cart_usecases.dart';

enum CartStatus { initial, loading, success, empty, failure }

class CartState {
  final CartStatus status;
  final Cart cart;
  final String? errorMessage;
  final bool isMutating;

  const CartState({
    this.status = CartStatus.initial,
    this.cart = const Cart(),
    this.errorMessage,
    this.isMutating = false,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    String? errorMessage,
    bool? isMutating,
  }) => CartState(
    status: status ?? this.status,
    cart: cart ?? this.cart,
    errorMessage: errorMessage,
    isMutating: isMutating ?? this.isMutating,
  );
}

class CartCubit extends Cubit<CartState> {
  final GetCart _getCart;
  final AddCartItem _addItem;
  final UpdateCartItem _updateItem;
  final RemoveCartItem _removeItem;
  final ClearCart _clearCart;
  final MergeCartItem _mergeItem;

  CartCubit(
    this._getCart,
    this._addItem,
    this._updateItem,
    this._removeItem,
    this._clearCart,
    this._mergeItem,
  ) : super(const CartState());

  Future<void> load() async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      final cart = await _getCart();
      emit(
        state.copyWith(
          status: cart.items.isEmpty ? CartStatus.empty : CartStatus.success,
          cart: cart,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> addItem({required String offerId, required int quantity}) =>
      _runMutation(() => _addItem(offerId: offerId, quantity: quantity));

  Future<void> updateItem({required CartItem item, required int quantity}) {
    final normalized = item.normalizeQuantity(quantity);
    return _runMutation(
      () => _updateItem(cartItemId: item.cartItemId, quantity: normalized),
    );
  }

  Future<void> removeItem(String cartItemId) =>
      _runMutation(() => _removeItem(cartItemId));

  Future<void> clearCart() => _runMutation(_clearCart.call);

  Future<void> mergeItem({required String offerId, required int quantity}) =>
      _runMutation(() => _mergeItem(offerId: offerId, quantity: quantity));

  Future<void> _runMutation(Future<Cart> Function() operation) async {
    if (state.isMutating) return;
    emit(state.copyWith(isMutating: true, errorMessage: null));
    try {
      final cart = await operation();
      emit(
        state.copyWith(
          status: cart.items.isEmpty ? CartStatus.empty : CartStatus.success,
          cart: cart,
          isMutating: false,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isMutating: false, errorMessage: _message(error)));
    }
  }
}

class CartSummaryState {
  final CartStatus status;
  final CartSummary summary;
  final String? errorMessage;

  const CartSummaryState({
    this.status = CartStatus.initial,
    this.summary = const CartSummary(),
    this.errorMessage,
  });
}

class CartSummaryCubit extends Cubit<CartSummaryState> {
  final GetCartSummary _getSummary;
  CartSummaryCubit(this._getSummary) : super(const CartSummaryState());

  Future<void> load() async {
    emit(const CartSummaryState(status: CartStatus.loading));
    try {
      final summary = await _getSummary();
      emit(
        CartSummaryState(
          status: summary.itemCount == 0
              ? CartStatus.empty
              : CartStatus.success,
          summary: summary,
        ),
      );
    } catch (error) {
      emit(
        CartSummaryState(
          status: CartStatus.failure,
          errorMessage: _message(error),
        ),
      );
    }
  }
}

String _message(Object error) => error is FailureException
    ? error.failure.message
    : error is Failure
    ? error.message
    : 'تعذر تحميل السلة';
