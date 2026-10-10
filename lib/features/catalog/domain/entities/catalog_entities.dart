class Category {
  final String id;
  final String? name;
  final String? nameAr;
  final String? icon;
  final int productCount;

  const Category({
    required this.id,
    this.name,
    this.nameAr,
    this.icon,
    this.productCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString(),
    nameAr: json['nameAr']?.toString(),
    icon: json['icon']?.toString(),
    productCount: _int(json['productCount']) ?? 0,
  );

  String displayName(bool isEnglish) =>
      (isEnglish ? name : nameAr)?.trim().isNotEmpty == true
      ? (isEnglish ? name : nameAr)!
      : (name ?? nameAr ?? '');
}

class Supplier {
  final String id;
  final String? name;
  final String? nameAr;
  final String? logoUrl;
  final bool isVerified;

  const Supplier({
    required this.id,
    this.name,
    this.nameAr,
    this.logoUrl,
    this.isVerified = false,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString(),
    nameAr: json['nameAr']?.toString(),
    logoUrl: json['logoUrl']?.toString(),
    isVerified: json['isVerified'] == true,
  );

  String displayName(bool isEnglish) =>
      (isEnglish ? name : nameAr)?.trim().isNotEmpty == true
      ? (isEnglish ? name : nameAr)!
      : (name ?? nameAr ?? '');
}

class Offer {
  final String offerId;
  final String productId;
  final Supplier supplier;
  final String? title;
  final String? specsSummary;
  final String? imageUrl;
  final num? pricePerTon;
  final String? currency;
  final DateTime? lastUpdatedAt;
  final String? lastUpdatedLabel;
  final int defaultQuantity;
  final int minQuantity;
  final int maxQuantity;
  final int quantityStep;
  final String? unit;

  const Offer({
    required this.offerId,
    required this.productId,
    required this.supplier,
    this.title,
    this.specsSummary,
    this.imageUrl,
    this.pricePerTon,
    this.currency,
    this.lastUpdatedAt,
    this.lastUpdatedLabel,
    this.defaultQuantity = 1,
    this.minQuantity = 1,
    this.maxQuantity = 1,
    this.quantityStep = 1,
    this.unit,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
    offerId: json['offerId']?.toString() ?? '',
    productId: json['productId']?.toString() ?? '',
    supplier: Supplier.fromJson(_map(json['supplier'])),
    title: json['title']?.toString(),
    specsSummary: json['specsSummary']?.toString(),
    imageUrl: json['imageUrl']?.toString(),
    pricePerTon: json['pricePerTon'] is num ? json['pricePerTon'] as num : null,
    currency: json['currency']?.toString(),
    lastUpdatedAt: DateTime.tryParse(json['lastUpdatedAt']?.toString() ?? ''),
    lastUpdatedLabel: json['lastUpdatedLabel']?.toString(),
    defaultQuantity: _int(json['defaultQuantity']) ?? 1,
    minQuantity: _int(json['minQuantity']) ?? 1,
    maxQuantity: _int(json['maxQuantity']) ?? 1,
    quantityStep: _int(json['quantityStep']) ?? 1,
    unit: json['unit']?.toString(),
  );

  int normalizeQuantity(int value) {
    final lower = minQuantity;
    final upper = maxQuantity < lower ? lower : maxQuantity;
    final step = quantityStep > 0 ? quantityStep : 1;
    final clamped = value.clamp(lower, upper);
    return lower + ((clamped - lower) ~/ step) * step;
  }
}

class Product {
  final String id;
  final String? title;
  final String? titleAr;
  final String? specsSummary;
  final String? imageUrl;
  final Supplier supplier;
  final num? pricePerTon;
  final String? currency;
  final String? unit;

  const Product({
    required this.id,
    this.title,
    this.titleAr,
    this.specsSummary,
    this.imageUrl,
    required this.supplier,
    this.pricePerTon,
    this.currency,
    this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString(),
    titleAr: json['titleAr']?.toString(),
    specsSummary: json['specsSummary']?.toString(),
    imageUrl: json['imageUrl']?.toString(),
    supplier: Supplier.fromJson(_map(json['supplier'])),
    pricePerTon: json['pricePerTon'] is num ? json['pricePerTon'] as num : null,
    currency: json['currency']?.toString(),
    unit: json['unit']?.toString(),
  );

  String displayTitle(bool isEnglish) =>
      (isEnglish ? title : titleAr)?.trim().isNotEmpty == true
      ? (isEnglish ? title : titleAr)!
      : (title ?? titleAr ?? '');
}

class ProductDetails extends Product {
  final Category? category;
  final List<Offer> offers;

  const ProductDetails({
    required super.id,
    super.title,
    super.titleAr,
    super.specsSummary,
    super.imageUrl,
    required super.supplier,
    super.pricePerTon,
    super.currency,
    super.unit,
    this.category,
    this.offers = const [],
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    final product = Product.fromJson(json);
    final rawOffers = json['offers'];
    return ProductDetails(
      id: product.id,
      title: product.title,
      titleAr: product.titleAr,
      specsSummary: product.specsSummary,
      imageUrl: product.imageUrl,
      supplier: product.supplier,
      pricePerTon: product.pricePerTon,
      currency: product.currency,
      unit: product.unit,
      category: json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      offers: rawOffers is List
          ? rawOffers
                .whereType<Map<String, dynamic>>()
                .map(Offer.fromJson)
                .toList()
          : const [],
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : const {};

int? _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
