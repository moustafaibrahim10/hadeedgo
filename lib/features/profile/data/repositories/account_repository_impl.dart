import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/account_entities.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_api_service.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApiService _api;
  const AccountRepositoryImpl(this._api);

  @override
  Future<AccountSummary> getAccountSummary() async => AccountSummary.fromJson(
    await _dataMap(_api.getAccountSummary(), 'تعذر تحميل ملخص الحساب'),
  );

  @override
  Future<UserProfile> getProfile() async => UserProfile.fromJson(
    await _dataMap(_api.getProfile(), 'تعذر تحميل الملف الشخصي'),
  );

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? email,
    String? companyName,
    String? avatarUrl,
  }) async {
    final payload = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'companyName': companyName,
      'avatarUrl': avatarUrl,
    };
    return UserProfile.fromJson(
      await _dataMap(_api.updateProfile(payload), 'تعذر تحديث الملف الشخصي'),
    );
  }

  @override
  Future<List<SavedAddress>> getAddresses() async {
    final data = await _dataList(_api.getAddresses(), 'تعذر تحميل العناوين');
    return data
        .whereType<Map<String, dynamic>>()
        .map(SavedAddress.fromJson)
        .toList();
  }

  @override
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
  }) async {
    final payload = <String, dynamic>{
      'label': label,
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'additionalDetails': additionalDetails,
      'isDefault': isDefault,
    };
    return SavedAddress.fromJson(
      await _dataMap(_api.createAddress(payload), 'تعذر إضافة العنوان'),
    );
  }

  @override
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
  }) async {
    final payload = <String, dynamic>{
      'label': label,
      'governorate': governorate,
      'city': city,
      'street': street,
      'building': building,
      'floor': floor,
      'apartment': apartment,
      'additionalDetails': additionalDetails,
      'isDefault': isDefault,
    };
    return SavedAddress.fromJson(
      await _dataMap(
        _api.updateAddress(addressId, payload),
        'تعذر تعديل العنوان',
      ),
    );
  }

  @override
  Future<void> deleteAddress(String addressId) async =>
      _dataMap(_api.deleteAddress(addressId), 'تعذر حذف العنوان');

  @override
  Future<TaxInvoicesPage> getInvoices({
    int page = 1,
    int pageSize = 10,
  }) async => TaxInvoicesPage.fromJson(
    await _dataMap(
      _api.getInvoices(page: page, pageSize: pageSize),
      'تعذر تحميل الفواتير الضريبية',
    ),
  );

  @override
  Future<TaxInvoiceDetails> getInvoiceDetails(String orderId) async =>
      TaxInvoiceDetails.fromJson(
        await _dataMap(
          _api.getInvoiceDetails(orderId),
          'تعذر تحميل تفاصيل الفاتورة',
        ),
      );

  @override
  Future<SupportInfo> getSupport() async => SupportInfo.fromJson(
    await _dataMap(_api.getSupport(), 'تعذر تحميل بيانات الدعم الفني'),
  );

  // ─── Private Helpers ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _dataMap(
    Future<HttpResponse<dynamic>> request,
    String fallback,
  ) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>)
        throw FailureException(ServerFailure(fallback));
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) {
        final errorMsg = parsed.errors.isNotEmpty
            ? parsed.errors
                  .map((e) => e.message)
                  .where((m) => m.isNotEmpty)
                  .join(', ')
            : parsed.message ?? fallback;
        throw FailureException(
          ServerFailure(errorMsg.isNotEmpty ? errorMsg : fallback),
        );
      }
      final data = raw['data'];
      return data is Map<String, dynamic> ? data : const {};
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      throw _handleDioError(error, fallback);
    }
  }

  Future<List<dynamic>> _dataList(
    Future<HttpResponse<dynamic>> request,
    String fallback,
  ) async {
    try {
      final response = await request;
      final raw = response.data;
      if (raw is! Map<String, dynamic>)
        throw FailureException(ServerFailure(fallback));
      final parsed = ApiResponse<dynamic>.fromJson(raw, null);
      if (!parsed.success) {
        final errorMsg = parsed.errors.isNotEmpty
            ? parsed.errors
                  .map((e) => e.message)
                  .where((m) => m.isNotEmpty)
                  .join(', ')
            : parsed.message ?? fallback;
        throw FailureException(
          ServerFailure(errorMsg.isNotEmpty ? errorMsg : fallback),
        );
      }
      final data = raw['data'];
      return data is List ? data : const [];
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      throw _handleDioError(error, fallback);
    }
  }

  FailureException _handleDioError(DioException error, String fallback) {
    if (error.response?.statusCode == 401) {
      return const FailureException(SessionExpiredFailure());
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const FailureException(NetworkFailure());
    }
    final body = error.response?.data;
    String? message;
    if (body is Map<String, dynamic>) {
      if (body['message'] != null &&
          body['message'].toString().trim().isNotEmpty) {
        message = body['message'].toString();
      } else if (body['errors'] is List &&
          (body['errors'] as List).isNotEmpty) {
        final errs = (body['errors'] as List)
            .whereType<Map<String, dynamic>>()
            .map((e) => e['message']?.toString())
            .where((m) => m != null && m.isNotEmpty)
            .join(', ');
        if (errs.isNotEmpty) message = errs;
      } else if (body['errors'] is Map) {
        final errs = (body['errors'] as Map).values
            .expand((v) => v is List ? v : [v])
            .map((e) => e.toString())
            .where((m) => m.isNotEmpty)
            .join(', ');
        if (errs.isNotEmpty) message = errs;
      } else if (body['title'] != null) {
        message = body['title'].toString();
      }
    }
    return FailureException(
      ServerFailure(message ?? error.response?.statusMessage ?? fallback),
    );
  }
}
