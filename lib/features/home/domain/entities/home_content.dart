import '../../../catalog/domain/entities/catalog_entities.dart';

typedef HomeCategory = Category;
typedef SupplierInfo = Supplier;
typedef FeaturedOffer = Offer;
typedef PartnerSupplier = Supplier;

class HomeContent {
  final ActiveShipment? activeShipment;
  final List<FeaturedOffer> featuredOffers;
  final List<HomeCategory> categories;
  final List<PartnerSupplier> partnerSuppliers;
  final List<HomeNews> marketNews;
  final int cartItemCount;

  const HomeContent({
    this.activeShipment,
    this.featuredOffers = const [],
    this.categories = const [],
    this.partnerSuppliers = const [],
    this.marketNews = const [],
    this.cartItemCount = 0,
  });
}

class ActiveShipment {
  final String orderId;
  final String? orderNumber;
  final String? status;
  final int? etaMinutes;
  final String? message;

  const ActiveShipment({
    required this.orderId,
    this.orderNumber,
    this.status,
    this.etaMinutes,
    this.message,
  });

  factory ActiveShipment.fromJson(Map<String, dynamic> json) => ActiveShipment(
    orderId: json['orderId']?.toString() ?? '',
    orderNumber: json['orderNumber']?.toString(),
    status: json['status']?.toString(),
    etaMinutes: _int(json['etaMinutes']),
    message: json['message']?.toString(),
  );
}

class HomeNews {
  final String? id;
  final String? title;
  final String? summary;
  final String? icon;
  final DateTime? publishedAt;
  final bool isPrototype;

  const HomeNews({
    this.id,
    this.title,
    this.summary,
    this.icon,
    this.publishedAt,
    this.isPrototype = false,
  });

  factory HomeNews.fromJson(Map<String, dynamic> json) => HomeNews(
    id: json['id']?.toString(),
    title: json['title']?.toString(),
    summary: json['summary']?.toString(),
    icon: json['icon']?.toString(),
    publishedAt: DateTime.tryParse(json['publishedAt']?.toString() ?? ''),
    isPrototype: json['isPrototype'] == true,
  );
}

int? _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
