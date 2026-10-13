import '../../../catalog/domain/entities/catalog_entities.dart';

class CartItem {
  final String cartItemId;
  final String offerId;
  final String productId;
  final String? title;
  final String? titleAr;
  final String? specsSummary;
  final String? imageUrl;
  final Supplier supplier;
  final num? pricePerTon;
  final num? unitPrice;
  final num? lineTotal;
  final String? currency;
  final String? unit;
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final int quantityStep;

  const CartItem({
    required this.cartItemId,
    required this.offerId,
    required this.productId,
    this.title,
    this.titleAr,
    this.specsSummary,
    this.imageUrl,
    required this.supplier,
    this.pricePerTon,
    this.unitPrice,
    this.lineTotal,
    this.currency,
    this.unit,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity = 1,
    this.quantityStep = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final offer = _map(json['offer']);
    final product = _map(json['product']);
    T? value<T>(String key) => (json[key] ?? offer[key] ?? product[key]) as T?;
    final priceValue = _num(
      json['unitPrice'] ??
          json['pricePerTon'] ??
          offer['unitPrice'] ??
          offer['pricePerTon'] ??
          product['unitPrice'] ??
          product['pricePerTon'],
    );
    return CartItem(
      cartItemId: _string(json['cartItemId'] ?? json['id']),
      offerId: _string(json['offerId'] ?? offer['offerId']),
      productId: _string(json['productId'] ?? offer['productId']),
      title: value<String>('title'),
      titleAr: value<String>('titleAr'),
      specsSummary: value<String>('specsSummary'),
      imageUrl: value<String>('imageUrl'),
      supplier: Supplier.fromJson(
        _map(json['supplier'] ?? offer['supplier'] ?? product['supplier']),
      ),
      pricePerTon: priceValue,
      unitPrice: priceValue,
      lineTotal: _num(
        json['lineTotal'] ?? offer['lineTotal'] ?? product['lineTotal'],
      ),
      currency: value<String>('currency'),
      unit: value<String>('unit'),
      quantity: _int(json['quantity']) ?? 0,
      minQuantity: _int(json['minQuantity'] ?? offer['minQuantity']) ?? 1,
      maxQuantity: _int(json['maxQuantity'] ?? offer['maxQuantity']) ?? 1,
      quantityStep: _int(json['quantityStep'] ?? offer['quantityStep']) ?? 1,
    );
  }

  String displayTitle(bool isEnglish) =>
      ((isEnglish ? title : titleAr)?.trim().isNotEmpty == true
      ? (isEnglish ? title : titleAr)
      : (title ?? titleAr ?? ''))!;

  int normalizeQuantity(int value) {
    final lower = minQuantity;
    final upper = maxQuantity < lower ? lower : maxQuantity;
    final step = quantityStep > 0 ? quantityStep : 1;
    final clamped = value.clamp(lower, upper);
    return lower + ((clamped - lower) ~/ step) * step;
  }
}

class Cart {
  final String? id;
  final int itemCount;
  final String? currency;
  final List<CartItem> items;
  final num totalWeightTons;
  final num merchantSubTotal;
  final num estimatedDeliveryFee;
  final num grandTotal;

  const Cart({
    this.id,
    this.itemCount = 0,
    this.currency,
    this.items = const [],
    this.totalWeightTons = 0,
    this.merchantSubTotal = 0,
    this.estimatedDeliveryFee = 0,
    this.grandTotal = 0,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final source = json['cart'] is Map<String, dynamic>
        ? json['cart'] as Map<String, dynamic>
        : json;
    final checkout = _map(
      source['checkout'] ?? source['checkoutBreakdown'] ?? source['summary'],
    );
    final rawItems = source['items'] ?? source['cartItems'] ?? const [];
    return Cart(
      id: source['id']?.toString(),
      itemCount:
          _int(source['itemCount']) ?? (rawItems is List ? rawItems.length : 0),
      currency:
          source['currency']?.toString() ?? checkout['currency']?.toString(),
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(CartItem.fromJson)
                .toList()
          : const [],
      totalWeightTons:
          _num(source['totalWeightTons'] ?? checkout['totalWeightTons']) ?? 0,
      merchantSubTotal:
          _num(source['merchantSubTotal'] ?? checkout['merchantSubTotal']) ?? 0,
      estimatedDeliveryFee:
          _num(
            source['estimatedDeliveryFee'] ?? checkout['estimatedDeliveryFee'],
          ) ??
          0,
      grandTotal: _num(source['grandTotal'] ?? checkout['grandTotal']) ?? 0,
    );
  }
}

class CartSummary {
  final int itemCount;
  final num totalAmount;

  const CartSummary({this.itemCount = 0, this.totalAmount = 0});

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    itemCount: _int(json['itemCount']) ?? 0,
    totalAmount: _num(json['totalAmount']) ?? 0,
  );
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : const {};
String _string(Object? value) => value?.toString() ?? '';
num? _num(Object? value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
int? _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
