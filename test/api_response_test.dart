import 'package:flutter_test/flutter_test.dart';
import 'package:hadeedgo/core/network/api_response.dart';
import 'package:hadeedgo/features/cart/domain/entities/cart_entities.dart';

void main() {
  test('maps backend field errors without exposing raw JSON', () {
    final response = ApiResponse<Map<String, dynamic>>.fromJson({
      'success': false,
      'errors': [
        {
          'field': 'phone',
          'code': 'AlreadyExists',
          'message': 'Phone already exists',
        },
      ],
    }, null);

    expect(response.hasFieldErrors, isTrue);
    expect(response.errorForField('phone'), 'Phone already exists');
  });

  test(
    'cart parser accepts the live backend contract used by product details',
    () {
      final cart = Cart.fromJson({
        'id': 'cart-1',
        'itemCount': 1,
        'totalAmount': 1500,
        'currency': 'SAR',
        'checkout': {
          'totalWeightTons': 1,
          'merchantSubTotal': 1500,
          'estimatedDeliveryFee': 50,
          'grandTotal': 1550,
          'currency': 'SAR',
        },
        'items': [
          {
            'id': 'item-1',
            'offerId': 'offer-1',
            'productId': 'product-1',
            'title': 'Steel Coil',
            'specsSummary': '2mm - 1.5m',
            'imageUrl': 'https://example.com/steel.jpg',
            'supplier': {
              'id': 'supplier-1',
              'name': 'Alpha Steel',
              'nameAr': 'الفولاذ ألفا',
              'logoUrl': 'https://example.com/logo.png',
              'isVerified': true,
            },
            'quantity': 1,
            'unitPrice': 1500,
            'lineTotal': 1500,
            'currency': 'SAR',
            'unit': 'Ton',
            'minQuantity': 1,
            'maxQuantity': 10,
            'quantityStep': 1,
          },
        ],
      });

      expect(cart.items, hasLength(1));
      expect(cart.items.first.offerId, 'offer-1');
      expect(cart.items.first.pricePerTon, 1500);
      expect(cart.totalWeightTons, 1);
      expect(cart.merchantSubTotal, 1500);
      expect(cart.estimatedDeliveryFee, 50);
      expect(cart.grandTotal, 1550);
    },
  );

  test('cart parser accepts a nested cart payload', () {
    final cart = Cart.fromJson({
      'cart': {
        'itemCount': 1,
        'items': [
          {
            'id': 'item-1',
            'offerId': 'offer-1',
            'productId': 'product-1',
            'quantity': 2,
          },
        ],
      },
    });

    expect(cart.items, hasLength(1));
    expect(cart.items.first.offerId, 'offer-1');
    expect(cart.items.first.quantity, 2);
  });
}
