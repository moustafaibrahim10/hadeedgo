import '../../domain/entities/home_content.dart';
import '../../../catalog/domain/entities/catalog_entities.dart';

class HomeModelMapper {
  static HomeContent fromJson(Map<String, dynamic> json) {
    return HomeContent(
      activeShipment: _mapObject(
        json['activeShipment'],
        ActiveShipment.fromJson,
      ),
      featuredOffers: _mapList(json['featuredOffers'], Offer.fromJson),
      categories: _mapList(json['categories'], Category.fromJson),
      partnerSuppliers: _mapList(json['partnerSuppliers'], Supplier.fromJson),
      marketNews: _mapList(json['marketNews'], HomeNews.fromJson),
      cartItemCount: _int(json['cartItemCount']) ?? 0,
    );
  }

  static T? _mapObject<T>(
    Object? value,
    T Function(Map<String, dynamic>) mapper,
  ) {
    return value is Map<String, dynamic> ? mapper(value) : null;
  }

  static List<T> _mapList<T>(
    Object? value,
    T Function(Map<String, dynamic>) mapper,
  ) {
    if (value is! List) return const [];
    return value.whereType<Map<String, dynamic>>().map(mapper).toList();
  }

  static int? _int(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
}
