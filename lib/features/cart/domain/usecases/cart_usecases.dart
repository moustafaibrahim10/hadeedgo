import '../entities/cart_entities.dart';
import '../repositories/cart_repository.dart';

class GetCart {
  final CartRepository repository;
  const GetCart(this.repository);
  Future<Cart> call() => repository.getCart();
}

class GetCartSummary {
  final CartRepository repository;
  const GetCartSummary(this.repository);
  Future<CartSummary> call() => repository.getSummary();
}

class AddCartItem {
  final CartRepository repository;
  const AddCartItem(this.repository);
  Future<Cart> call({required String offerId, required int quantity}) =>
      repository.addItem(offerId: offerId, quantity: quantity);
}

class UpdateCartItem {
  final CartRepository repository;
  const UpdateCartItem(this.repository);
  Future<Cart> call({required String cartItemId, required int quantity}) =>
      repository.updateItem(cartItemId: cartItemId, quantity: quantity);
}

class RemoveCartItem {
  final CartRepository repository;
  const RemoveCartItem(this.repository);
  Future<Cart> call(String cartItemId) => repository.removeItem(cartItemId);
}

class ClearCart {
  final CartRepository repository;
  const ClearCart(this.repository);
  Future<Cart> call() => repository.clearCart();
}

class MergeCartItem {
  final CartRepository repository;
  const MergeCartItem(this.repository);
  Future<Cart> call({required String offerId, required int quantity}) =>
      repository.mergeItem(offerId: offerId, quantity: quantity);
}
