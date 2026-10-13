import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/account_entities.dart';
import '../../domain/usecases/account_usecases.dart';

String _msg(Object error) => error is FailureException
    ? error.failure.message
    : error is Failure
    ? error.message
    : 'حدث خطأ غير متوقع';

// ─── 1. AccountSummaryCubit ───────────────────────────────────────────────────

enum AccountSummaryStatus { initial, loading, success, failure }

class AccountSummaryState extends Equatable {
  final AccountSummaryStatus status;
  final AccountSummary summary;
  final String? errorMessage;

  const AccountSummaryState({
    this.status = AccountSummaryStatus.initial,
    this.summary = const AccountSummary(),
    this.errorMessage,
  });

  AccountSummaryState copyWith({
    AccountSummaryStatus? status,
    AccountSummary? summary,
    String? errorMessage,
  }) => AccountSummaryState(
    status: status ?? this.status,
    summary: summary ?? this.summary,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, summary, errorMessage];
}

class AccountSummaryCubit extends Cubit<AccountSummaryState> {
  final GetAccountSummary _getSummary;

  AccountSummaryCubit(this._getSummary) : super(const AccountSummaryState());

  Future<void> load() async {
    emit(
      state.copyWith(status: AccountSummaryStatus.loading, errorMessage: null),
    );
    try {
      final summary = await _getSummary();
      emit(
        state.copyWith(status: AccountSummaryStatus.success, summary: summary),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountSummaryStatus.failure,
          errorMessage: _msg(e),
        ),
      );
    }
  }
}

// ─── 2. ProfileCubit (View & Edit Profile) ────────────────────────────────────

enum ProfileStatus { initial, loading, success, updating, updated, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile profile;
  final String? errorMessage;
  final String? successMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile = const UserProfile(id: ''),
    this.errorMessage,
    this.successMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
    String? successMessage,
  }) => ProfileState(
    status: status ?? this.status,
    profile: profile ?? this.profile,
    errorMessage: errorMessage,
    successMessage: successMessage,
  );

  @override
  List<Object?> get props => [status, profile, errorMessage, successMessage];
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  ProfileCubit(this._getProfile, this._updateProfile)
    : super(const ProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));
    try {
      final profile = await _getProfile();
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, errorMessage: _msg(e)),
      );
    }
  }

  Future<bool> update({
    String? fullName,
    String? email,
    String? companyName,
    String? avatarUrl,
  }) async {
    emit(state.copyWith(status: ProfileStatus.updating, errorMessage: null));
    try {
      final updated = await _updateProfile(
        fullName: fullName,
        email: email,
        companyName: companyName,
        avatarUrl: avatarUrl,
      );
      emit(
        state.copyWith(
          status: ProfileStatus.updated,
          profile: updated,
          successMessage: 'تم تحديث الملف الشخصي بنجاح',
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(status: ProfileStatus.failure, errorMessage: _msg(e)),
      );
      return false;
    }
  }
}

// ─── 3. AddressesCubit (List, Create, Update, Delete) ─────────────────────────

enum AddressesStatus { initial, loading, success, mutating, failure }

class AddressesState extends Equatable {
  final AddressesStatus status;
  final List<SavedAddress> addresses;
  final String? errorMessage;
  final String? successMessage;

  const AddressesState({
    this.status = AddressesStatus.initial,
    this.addresses = const [],
    this.errorMessage,
    this.successMessage,
  });

  AddressesState copyWith({
    AddressesStatus? status,
    List<SavedAddress>? addresses,
    String? errorMessage,
    String? successMessage,
  }) => AddressesState(
    status: status ?? this.status,
    addresses: addresses ?? this.addresses,
    errorMessage: errorMessage,
    successMessage: successMessage,
  );

  @override
  List<Object?> get props => [status, addresses, errorMessage, successMessage];
}

class AddressesCubit extends Cubit<AddressesState> {
  final GetAddresses _getAddresses;
  final CreateAddress _createAddress;
  final UpdateAddress _updateAddress;
  final DeleteAddress _deleteAddress;

  AddressesCubit(
    this._getAddresses,
    this._createAddress,
    this._updateAddress,
    this._deleteAddress,
  ) : super(const AddressesState());

  Future<void> load() async {
    emit(state.copyWith(status: AddressesStatus.loading, errorMessage: null));
    try {
      final list = await _getAddresses();
      emit(state.copyWith(status: AddressesStatus.success, addresses: list));
    } catch (e) {
      emit(
        state.copyWith(status: AddressesStatus.failure, errorMessage: _msg(e)),
      );
    }
  }

  Future<bool> create({
    String? label,
    String? governorate,
    String? city,
    String? street,
    String? building,
    String? floor,
    String? apartment,
    String? additionalDetails,
    bool isDefault = false,
  }) async {
    emit(state.copyWith(status: AddressesStatus.mutating, errorMessage: null));
    try {
      final created = await _createAddress(
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
      final updatedList = isDefault
          ? [
              created,
              ...state.addresses.map(
                (a) => a.id == created.id
                    ? a
                    : SavedAddress(
                        id: a.id,
                        label: a.label,
                        governorate: a.governorate,
                        city: a.city,
                        street: a.street,
                        building: a.building,
                        floor: a.floor,
                        apartment: a.apartment,
                        additionalDetails: a.additionalDetails,
                        isDefault: false,
                        formattedAddress: a.formattedAddress,
                      ),
              ),
            ]
          : [...state.addresses, created];
      emit(
        state.copyWith(
          status: AddressesStatus.success,
          addresses: updatedList,
          successMessage: 'تم إضافة العنوان بنجاح',
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(status: AddressesStatus.failure, errorMessage: _msg(e)),
      );
      return false;
    }
  }

  Future<bool> update({
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
  }) async {
    emit(state.copyWith(status: AddressesStatus.mutating, errorMessage: null));
    try {
      final updated = await _updateAddress(
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
      final list = state.addresses.map((a) {
        if (a.id == addressId) return updated;
        if (isDefault) {
          return SavedAddress(
            id: a.id,
            label: a.label,
            governorate: a.governorate,
            city: a.city,
            street: a.street,
            building: a.building,
            floor: a.floor,
            apartment: a.apartment,
            additionalDetails: a.additionalDetails,
            isDefault: false,
            formattedAddress: a.formattedAddress,
          );
        }
        return a;
      }).toList();
      emit(
        state.copyWith(
          status: AddressesStatus.success,
          addresses: list,
          successMessage: 'تم تعديل العنوان بنجاح',
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(status: AddressesStatus.failure, errorMessage: _msg(e)),
      );
      return false;
    }
  }

  Future<bool> delete(String addressId) async {
    emit(state.copyWith(status: AddressesStatus.mutating, errorMessage: null));
    try {
      await _deleteAddress(addressId);
      final list = state.addresses.where((a) => a.id != addressId).toList();
      emit(
        state.copyWith(
          status: AddressesStatus.success,
          addresses: list,
          successMessage: 'تم حذف العنوان بنجاح',
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(status: AddressesStatus.failure, errorMessage: _msg(e)),
      );
      return false;
    }
  }
}

// ─── 4. InvoicesCubit ─────────────────────────────────────────────────────────

enum InvoicesStatus { initial, loading, success, loadingMore, failure }

class InvoicesState extends Equatable {
  final InvoicesStatus status;
  final TaxInvoicesPage page;
  final String? errorMessage;

  const InvoicesState({
    this.status = InvoicesStatus.initial,
    this.page = const TaxInvoicesPage(),
    this.errorMessage,
  });

  InvoicesState copyWith({
    InvoicesStatus? status,
    TaxInvoicesPage? page,
    String? errorMessage,
  }) => InvoicesState(
    status: status ?? this.status,
    page: page ?? this.page,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, page, errorMessage];
}

class InvoicesCubit extends Cubit<InvoicesState> {
  final GetInvoices _getInvoices;

  InvoicesCubit(this._getInvoices) : super(const InvoicesState());

  Future<void> load({int pageSize = 10}) async {
    emit(state.copyWith(status: InvoicesStatus.loading, errorMessage: null));
    try {
      final res = await _getInvoices(page: 1, pageSize: pageSize);
      emit(state.copyWith(status: InvoicesStatus.success, page: res));
    } catch (e) {
      emit(
        state.copyWith(status: InvoicesStatus.failure, errorMessage: _msg(e)),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.status == InvoicesStatus.loadingMore || !state.page.hasMore)
      return;
    emit(state.copyWith(status: InvoicesStatus.loadingMore));
    try {
      final next = await _getInvoices(
        page: state.page.page + 1,
        pageSize: state.page.pageSize,
      );
      final merged = TaxInvoicesPage(
        totalCount: next.totalCount,
        page: next.page,
        pageSize: next.pageSize,
        items: [...state.page.items, ...next.items],
      );
      emit(state.copyWith(status: InvoicesStatus.success, page: merged));
    } catch (e) {
      emit(
        state.copyWith(status: InvoicesStatus.success, errorMessage: _msg(e)),
      );
    }
  }
}

// ─── 5. InvoiceDetailsCubit ───────────────────────────────────────────────────

enum InvoiceDetailsStatus { initial, loading, success, failure }

class InvoiceDetailsState extends Equatable {
  final InvoiceDetailsStatus status;
  final TaxInvoiceDetails? details;
  final String? errorMessage;

  const InvoiceDetailsState({
    this.status = InvoiceDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  InvoiceDetailsState copyWith({
    InvoiceDetailsStatus? status,
    TaxInvoiceDetails? details,
    String? errorMessage,
  }) => InvoiceDetailsState(
    status: status ?? this.status,
    details: details ?? this.details,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, details, errorMessage];
}

class InvoiceDetailsCubit extends Cubit<InvoiceDetailsState> {
  final GetInvoiceDetails _getInvoiceDetails;

  InvoiceDetailsCubit(this._getInvoiceDetails)
    : super(const InvoiceDetailsState());

  Future<void> load(String orderId) async {
    emit(
      state.copyWith(status: InvoiceDetailsStatus.loading, errorMessage: null),
    );
    try {
      final details = await _getInvoiceDetails(orderId);
      emit(
        state.copyWith(status: InvoiceDetailsStatus.success, details: details),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: InvoiceDetailsStatus.failure,
          errorMessage: _msg(e),
        ),
      );
    }
  }
}

// ─── 6. SupportCubit ──────────────────────────────────────────────────────────

enum SupportStatus { initial, loading, success, failure }

class SupportState extends Equatable {
  final SupportStatus status;
  final SupportInfo info;
  final String? errorMessage;

  const SupportState({
    this.status = SupportStatus.initial,
    this.info = const SupportInfo(),
    this.errorMessage,
  });

  SupportState copyWith({
    SupportStatus? status,
    SupportInfo? info,
    String? errorMessage,
  }) => SupportState(
    status: status ?? this.status,
    info: info ?? this.info,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, info, errorMessage];
}

class SupportCubit extends Cubit<SupportState> {
  final GetSupportInfo _getSupport;

  SupportCubit(this._getSupport) : super(const SupportState());

  Future<void> load() async {
    emit(state.copyWith(status: SupportStatus.loading, errorMessage: null));
    try {
      final info = await _getSupport();
      emit(state.copyWith(status: SupportStatus.success, info: info));
    } catch (e) {
      emit(
        state.copyWith(status: SupportStatus.failure, errorMessage: _msg(e)),
      );
    }
  }
}
