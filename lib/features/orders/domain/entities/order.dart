enum OrderStatus { pending, processing, shipped, delivered, cancelled, unknown }

class OrderItem {
  final String id;
  final String productId;
  final String? title;
  final String? titleAr;
  final String? specsSummary;
  final String? supplierName;
  final String? supplierNameAr;
  final num quantity;
  final num unitPrice;
  final num lineTotal;
  final String? currency;
  final String? unit;

  const OrderItem({
    required this.id,
    required this.productId,
    this.title,
    this.titleAr,
    this.specsSummary,
    this.supplierName,
    this.supplierNameAr,
    this.quantity = 0,
    this.unitPrice = 0,
    this.lineTotal = 0,
    this.currency,
    this.unit,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: _string(json['id']),
    productId: _string(json['productId']),
    title: json['title']?.toString(),
    titleAr: json['titleAr']?.toString(),
    specsSummary: json['specsSummary']?.toString(),
    supplierName: json['supplierName']?.toString(),
    supplierNameAr: json['supplierNameAr']?.toString(),
    quantity: _num(json['quantity']) ?? 0,
    unitPrice: _num(json['unitPrice']) ?? 0,
    lineTotal: _num(json['lineTotal']) ?? 0,
    currency: json['currency']?.toString(),
    unit: json['unit']?.toString(),
  );

  String displayTitle(bool english) =>
      ((english ? title : titleAr)?.trim().isNotEmpty == true
      ? (english ? title : titleAr)!
      : (title ?? titleAr ?? ''));
}

class OrderStatusEvent {
  final String status;
  final String? title;
  final String? description;
  final DateTime? occurredAt;
  final bool isCurrent;

  const OrderStatusEvent({
    required this.status,
    this.title,
    this.description,
    this.occurredAt,
    this.isCurrent = false,
  });

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) =>
      OrderStatusEvent(
        status: _string(json['status']),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
        occurredAt: DateTime.tryParse(json['occurredAt']?.toString() ?? ''),
        isCurrent: json['isCurrent'] == true,
      );
}

class Order {
  final String id;
  final String? orderNumber;
  final String? statusLabel;
  final String deliveryMethod;
  final String? deliveryAddressLabel;
  final String? deliveryAddressDetails;
  final DateTime? preferredDeliveryDate;
  final num subTotal;
  final num deliveryFee;
  final num taxAmount;
  final num totalAmount;
  final String? currency;
  final int? etaMinutes;
  final String? deliveryDestinationLabel;
  final String? driverName;
  final String? driverPhone;
  final DateTime? createdAt;
  final List<OrderItem> orderItems;
  final List<OrderStatusEvent> statusEvents;
  final int itemCount;
  final bool canTrack;
  final String status;

  const Order({
    required this.id,
    this.orderNumber,
    this.status = 'Unknown',
    this.statusLabel,
    this.deliveryMethod = 'Delivery',
    this.deliveryAddressLabel,
    this.deliveryAddressDetails,
    this.preferredDeliveryDate,
    this.subTotal = 0,
    this.deliveryFee = 0,
    this.taxAmount = 0,
    this.totalAmount = 0,
    this.currency,
    this.etaMinutes,
    this.deliveryDestinationLabel,
    this.driverName,
    this.driverPhone,
    this.createdAt,
    this.orderItems = const [],
    this.statusEvents = const [],
    this.itemCount = 0,
    this.canTrack = false,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: _string(json['id']),
    orderNumber: json['orderNumber']?.toString(),
    status: _string(json['status']),
    statusLabel: json['statusLabel']?.toString(),
    deliveryMethod: _string(json['deliveryMethod']),
    deliveryAddressLabel: json['deliveryAddressLabel']?.toString(),
    deliveryAddressDetails: json['deliveryAddressDetails']?.toString(),
    preferredDeliveryDate: DateTime.tryParse(
      json['preferredDeliveryDate']?.toString() ?? '',
    ),
    subTotal: _num(json['subTotal']) ?? 0,
    deliveryFee: _num(json['deliveryFee']) ?? 0,
    taxAmount: _num(json['taxAmount']) ?? 0,
    totalAmount: _num(json['totalAmount']) ?? 0,
    currency: json['currency']?.toString(),
    etaMinutes: _int(json['etaMinutes']),
    deliveryDestinationLabel: json['deliveryDestinationLabel']?.toString(),
    driverName: json['driverName']?.toString(),
    driverPhone: json['driverPhone']?.toString(),
    createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    orderItems: _list(json['items'], OrderItem.fromJson),
    statusEvents: _list(json['statusEvents'], OrderStatusEvent.fromJson),
    itemCount: _int(json['itemCount']) ?? 0,
    canTrack: json['canTrack'] == true,
  );

  OrderStatus get statusType {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
      case 'preparing':
        return OrderStatus.processing;
      case 'shipped':
      case 'indelivery':
      case 'outfordelivery':
        return OrderStatus.shipped;
      case 'delivered':
      case 'completed':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }
}

class OrdersPage {
  final String filter;
  final int totalCount;
  final int page;
  final int pageSize;
  final List<Order> items;

  const OrdersPage({
    this.filter = 'All',
    this.totalCount = 0,
    this.page = 1,
    this.pageSize = 20,
    this.items = const [],
  });

  factory OrdersPage.fromJson(Map<String, dynamic> json) => OrdersPage(
    filter: _string(json['filter']),
    totalCount: _int(json['totalCount']) ?? 0,
    page: _int(json['page']) ?? 1,
    pageSize: _int(json['pageSize']) ?? 20,
    items: _list(json['items'], Order.fromJson),
  );
}

class OrderTracking {
  final String orderId;
  final String? orderNumber;
  final String status;
  final String? statusLabel;
  final int? etaMinutes;
  final String? deliveryDestinationLabel;
  final String? driverName;
  final String? driverPhone;
  final num progressPercent;
  final List<OrderStatusEvent> timeline;

  const OrderTracking({
    required this.orderId,
    this.orderNumber,
    this.status = 'Unknown',
    this.statusLabel,
    this.etaMinutes,
    this.deliveryDestinationLabel,
    this.driverName,
    this.driverPhone,
    this.progressPercent = 0,
    this.timeline = const [],
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) => OrderTracking(
    orderId: _string(json['orderId']),
    orderNumber: json['orderNumber']?.toString(),
    status: _string(json['status']),
    statusLabel: json['statusLabel']?.toString(),
    etaMinutes: _int(json['etaMinutes']),
    deliveryDestinationLabel: json['deliveryDestinationLabel']?.toString(),
    driverName: json['driverName']?.toString(),
    driverPhone: json['driverPhone']?.toString(),
    progressPercent: _num(json['progressPercent']) ?? 0,
    timeline: _list(json['timeline'], OrderStatusEvent.fromJson),
  );
}

/// Lightweight active-order summary returned by GET /api/v1/orders/active.
/// Used for the Dynamic Island / active-shipment banner.
class ActiveOrder {
  final String orderId;
  final String? orderNumber;
  final String status;
  final int? etaMinutes;
  final String? message;

  const ActiveOrder({
    required this.orderId,
    this.orderNumber,
    this.status = 'Unknown',
    this.etaMinutes,
    this.message,
  });

  factory ActiveOrder.fromJson(Map<String, dynamic> json) => ActiveOrder(
    orderId: _string(json['orderId'] ?? json['id']),
    orderNumber: json['orderNumber']?.toString(),
    status: _string(json['status']),
    etaMinutes: _int(json['etaMinutes']),
    message: json['message']?.toString(),
  );

  bool get isActive {
    final s = status.toLowerCase();
    return s == 'pending' ||
        s == 'processing' ||
        s == 'preparing' ||
        s == 'shipped' ||
        s == 'indelivery' ||
        s == 'outfordelivery';
  }
}

List<T> _list<T>(Object? value, T Function(Map<String, dynamic>) mapper) =>
    value is List
    ? value.whereType<Map<String, dynamic>>().map(mapper).toList()
    : const [];
String _string(Object? value) => value?.toString() ?? '';
num? _num(Object? value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');
int? _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
