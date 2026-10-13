// ─── User Profile Entity ───────────────────────────────────────────────────────

class UserProfile {
  final String id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? companyName;
  final String? avatarUrl;
  final bool isPhoneVerified;
  final bool isEmailVerified;

  const UserProfile({
    required this.id,
    this.fullName,
    this.phone,
    this.email,
    this.companyName,
    this.avatarUrl,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id']?.toString() ?? '',
    fullName: json['fullName']?.toString(),
    phone: json['phone']?.toString(),
    email: json['email']?.toString(),
    companyName: json['companyName']?.toString(),
    avatarUrl: json['avatarUrl']?.toString(),
    isPhoneVerified: json['isPhoneVerified'] == true,
    isEmailVerified: json['isEmailVerified'] == true,
  );

  UserProfile copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? companyName,
    String? avatarUrl,
    bool? isPhoneVerified,
    bool? isEmailVerified,
  }) => UserProfile(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    companyName: companyName ?? this.companyName,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
    isEmailVerified: isEmailVerified ?? this.isEmailVerified,
  );
}

// ─── Account Summary Entity ───────────────────────────────────────────────────

class AccountSummary {
  final UserProfile profile;
  final int savedAddressCount;
  final int taxInvoiceCount;

  const AccountSummary({
    this.profile = const UserProfile(id: ''),
    this.savedAddressCount = 0,
    this.taxInvoiceCount = 0,
  });

  factory AccountSummary.fromJson(Map<String, dynamic> json) => AccountSummary(
    profile: json['profile'] is Map<String, dynamic>
        ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
        : const UserProfile(id: ''),
    savedAddressCount: _int(json['savedAddressCount']) ?? 0,
    taxInvoiceCount: _int(json['taxInvoiceCount']) ?? 0,
  );
}

// ─── Saved Address Entity ─────────────────────────────────────────────────────

class SavedAddress {
  final String id;
  final String? label;
  final String? governorate;
  final String? city;
  final String? street;
  final String? building;
  final String? floor;
  final String? apartment;
  final String? additionalDetails;
  final bool isDefault;
  final String? formattedAddress;

  const SavedAddress({
    required this.id,
    this.label,
    this.governorate,
    this.city,
    this.street,
    this.building,
    this.floor,
    this.apartment,
    this.additionalDetails,
    this.isDefault = false,
    this.formattedAddress,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
    id: json['id']?.toString() ?? '',
    label: json['label']?.toString(),
    governorate: json['governorate']?.toString(),
    city: json['city']?.toString(),
    street: json['street']?.toString(),
    building: json['building']?.toString(),
    floor: json['floor']?.toString(),
    apartment: json['apartment']?.toString(),
    additionalDetails: json['additionalDetails']?.toString(),
    isDefault: json['isDefault'] == true,
    formattedAddress: json['formattedAddress']?.toString(),
  );

  String displayTitle() =>
      label?.trim().isNotEmpty == true ? label! : (city ?? 'عنوان');

  String displayFullAddress() {
    if (formattedAddress?.trim().isNotEmpty == true) return formattedAddress!;
    final parts = [
      if (street?.isNotEmpty == true) street!,
      if (building?.isNotEmpty == true) 'مبنى $building',
      if (floor?.isNotEmpty == true) 'طابق $floor',
      if (apartment?.isNotEmpty == true) 'شقة $apartment',
      if (city?.isNotEmpty == true) city!,
      if (governorate?.isNotEmpty == true) governorate!,
    ];
    return parts.isNotEmpty ? parts.join('، ') : (additionalDetails ?? '');
  }
}

// ─── Tax Invoices Entities ────────────────────────────────────────────────────

class TaxInvoiceItem {
  final String orderId;
  final String? invoiceNumber;
  final String? orderNumber;
  final DateTime? issuedAt;
  final num? taxAmount;
  final num? totalAmount;
  final String? currency;

  const TaxInvoiceItem({
    required this.orderId,
    this.invoiceNumber,
    this.orderNumber,
    this.issuedAt,
    this.taxAmount,
    this.totalAmount,
    this.currency,
  });

  factory TaxInvoiceItem.fromJson(Map<String, dynamic> json) => TaxInvoiceItem(
    orderId: json['orderId']?.toString() ?? '',
    invoiceNumber: json['invoiceNumber']?.toString(),
    orderNumber: json['orderNumber']?.toString(),
    issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
    taxAmount: json['taxAmount'] is num ? json['taxAmount'] as num : null,
    totalAmount: json['totalAmount'] is num ? json['totalAmount'] as num : null,
    currency: json['currency']?.toString(),
  );
}

class TaxInvoicesPage {
  final int totalCount;
  final int page;
  final int pageSize;
  final List<TaxInvoiceItem> items;

  const TaxInvoicesPage({
    this.totalCount = 0,
    this.page = 1,
    this.pageSize = 10,
    this.items = const [],
  });

  bool get hasMore => page * pageSize < totalCount;

  factory TaxInvoicesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return TaxInvoicesPage(
      totalCount: _int(json['totalCount']) ?? 0,
      page: _int(json['page']) ?? 1,
      pageSize: _int(json['pageSize']) ?? 10,
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(TaxInvoiceItem.fromJson)
                .toList()
          : const [],
    );
  }
}

class InvoiceLine {
  final String? title;
  final num? quantity;
  final num? unitPrice;
  final num? lineTotal;
  final String? currency;

  const InvoiceLine({
    this.title,
    this.quantity,
    this.unitPrice,
    this.lineTotal,
    this.currency,
  });

  factory InvoiceLine.fromJson(Map<String, dynamic> json) => InvoiceLine(
    title: json['title']?.toString(),
    quantity: json['quantity'] is num ? json['quantity'] as num : null,
    unitPrice: json['unitPrice'] is num ? json['unitPrice'] as num : null,
    lineTotal: json['lineTotal'] is num ? json['lineTotal'] as num : null,
    currency: json['currency']?.toString(),
  );
}

class TaxInvoiceDetails {
  final String orderId;
  final String? invoiceNumber;
  final String? orderNumber;
  final DateTime? issuedAt;
  final String? currency;
  final String? buyerName;
  final String? buyerPhone;
  final String? buyerCompanyName;
  final String? buyerTaxId;
  final num? subTotal;
  final num? deliveryFee;
  final num? taxAmount;
  final num? totalAmount;
  final List<InvoiceLine> lines;

  const TaxInvoiceDetails({
    required this.orderId,
    this.invoiceNumber,
    this.orderNumber,
    this.issuedAt,
    this.currency,
    this.buyerName,
    this.buyerPhone,
    this.buyerCompanyName,
    this.buyerTaxId,
    this.subTotal,
    this.deliveryFee,
    this.taxAmount,
    this.totalAmount,
    this.lines = const [],
  });

  factory TaxInvoiceDetails.fromJson(Map<String, dynamic> json) {
    final rawLines = json['lines'];
    return TaxInvoiceDetails(
      orderId: json['orderId']?.toString() ?? '',
      invoiceNumber: json['invoiceNumber']?.toString(),
      orderNumber: json['orderNumber']?.toString(),
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
      currency: json['currency']?.toString(),
      buyerName: json['buyerName']?.toString(),
      buyerPhone: json['buyerPhone']?.toString(),
      buyerCompanyName: json['buyerCompanyName']?.toString(),
      buyerTaxId: json['buyerTaxId']?.toString(),
      subTotal: json['subTotal'] is num ? json['subTotal'] as num : null,
      deliveryFee: json['deliveryFee'] is num
          ? json['deliveryFee'] as num
          : null,
      taxAmount: json['taxAmount'] is num ? json['taxAmount'] as num : null,
      totalAmount: json['totalAmount'] is num
          ? json['totalAmount'] as num
          : null,
      lines: rawLines is List
          ? rawLines
                .whereType<Map<String, dynamic>>()
                .map(InvoiceLine.fromJson)
                .toList()
          : const [],
    );
  }
}

// ─── Support Info Entity ──────────────────────────────────────────────────────

class SupportInfo {
  final String? phone;
  final String? whatsApp;
  final String? email;
  final String? workingHours;
  final String? message;

  const SupportInfo({
    this.phone,
    this.whatsApp,
    this.email,
    this.workingHours,
    this.message,
  });

  factory SupportInfo.fromJson(Map<String, dynamic> json) => SupportInfo(
    phone: json['phone']?.toString(),
    whatsApp: json['whatsApp']?.toString(),
    email: json['email']?.toString(),
    workingHours: json['workingHours']?.toString(),
    message: json['message']?.toString(),
  );
}

// ─── Parsing Helpers ──────────────────────────────────────────────────────────

int? _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
