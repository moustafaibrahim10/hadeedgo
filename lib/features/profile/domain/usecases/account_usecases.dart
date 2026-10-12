import '../entities/account_entities.dart';
import '../repositories/account_repository.dart';

class GetAccountSummary {
  final AccountRepository repository;
  const GetAccountSummary(this.repository);
  Future<AccountSummary> call() => repository.getAccountSummary();
}

class GetProfile {
  final AccountRepository repository;
  const GetProfile(this.repository);
  Future<UserProfile> call() => repository.getProfile();
}

class UpdateProfile {
  final AccountRepository repository;
  const UpdateProfile(this.repository);
  Future<UserProfile> call({
    String? fullName,
    String? email,
    String? companyName,
    String? avatarUrl,
  }) => repository.updateProfile(
    fullName: fullName,
    email: email,
    companyName: companyName,
    avatarUrl: avatarUrl,
  );
}

class GetAddresses {
  final AccountRepository repository;
  const GetAddresses(this.repository);
  Future<List<SavedAddress>> call() => repository.getAddresses();
}

class CreateAddress {
  final AccountRepository repository;
  const CreateAddress(this.repository);
  Future<SavedAddress> call({
    String? label,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? additionalDetails,
    bool isDefault = false,
  }) => repository.createAddress(
    label: label,
    governorate: governorate,
    city: city,
    street: street,
    building: building,
    floor: floor,
    apartment: apartment,
    additionalDetails: additionalDetails,
    isDefault: isDefault,
  );
}

class UpdateAddress {
  final AccountRepository repository;
  const UpdateAddress(this.repository);
  Future<SavedAddress> call({
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
  }) => repository.updateAddress(
    addressId: addressId,
    label: label,
    governorate: governorate,
    city: city,
    street: street,
    building: building,
    floor: floor,
    apartment: apartment,
    additionalDetails: additionalDetails,
    isDefault: isDefault,
  );
}

class DeleteAddress {
  final AccountRepository repository;
  const DeleteAddress(this.repository);
  Future<void> call(String addressId) => repository.deleteAddress(addressId);
}

class GetInvoices {
  final AccountRepository repository;
  const GetInvoices(this.repository);
  Future<TaxInvoicesPage> call({int page = 1, int pageSize = 10}) =>
      repository.getInvoices(page: page, pageSize: pageSize);
}

class GetInvoiceDetails {
  final AccountRepository repository;
  const GetInvoiceDetails(this.repository);
  Future<TaxInvoiceDetails> call(String orderId) =>
      repository.getInvoiceDetails(orderId);
}

class GetSupportInfo {
  final AccountRepository repository;
  const GetSupportInfo(this.repository);
  Future<SupportInfo> call() => repository.getSupport();
}
