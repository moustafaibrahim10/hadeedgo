import '../entities/cart_entities.dart';

abstract interface class CartRepository {
  Future<Cart> getCart();
  Future<CartSummary> getSummary();
  Future<Cart> addItem({required String offerId, required int quantity});
  Future<Cart> updateItem({required String cartItemId, required int quantity});
  Future<Cart> removeItem(String cartItemId);
  Future<Cart> clearCart();
  Future<Cart> mergeItem({required String offerId, required int quantity});
}
