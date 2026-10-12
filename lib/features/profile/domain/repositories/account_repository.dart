import '../entities/account_entities.dart';

abstract interface class AccountRepository {
  /// GET /api/v1/account
  Future<AccountSummary> getAccountSummary();

  /// GET /api/v1/account/profile
  Future<UserProfile> getProfile();

  /// PUT /api/v1/account/profile
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? companyName,
    String? avatarUrl,
  });

  /// GET /api/v1/account/addresses
  Future<List<SavedAddress>> getAddresses();

  /// POST /api/v1/account/addresses
  Future<SavedAddress> createAddress({
    String? label,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? additionalDetails,
    bool isDefault = false,
  });

  /// PUT /api/v1/account/addresses/{addressId}
  Future<SavedAddress> updateAddress({
    required String addressId,
    String? label,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? additionalDetails,
    bool isDefault = false,
  });

  /// DELETE /api/v1/account/addresses/{addressId}
  Future<void> deleteAddress(String addressId);

  /// GET /api/v1/account/invoices
  Future<TaxInvoicesPage> getInvoices({int page = 1, int pageSize = 10});

  /// GET /api/v1/account/invoices/{orderId}
  Future<TaxInvoiceDetails> getInvoiceDetails(String orderId);

  /// GET /api/v1/account/support
  Future<SupportInfo> getSupport();
}
