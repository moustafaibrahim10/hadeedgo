import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/storage/session_storage.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _api;
  final SessionStorage _storage;

  const AuthRepositoryImpl(this._api, this._storage);

  @override
  Future<OtpChallenge> sendOtp({
    required String phone,
    required String purpose,
    required String channel,
  }) async {
    final response = await _call(
      () => _api.sendOtp({
        'phone': phone,
        'purpose': purpose,
        'channel': channel,
      }),
    );
    return AuthModelMapper.otpFromJson(_data(response));
  }

  @override
  Future<AuthSession> register({
    required String phone,
    required String otpCode,
    required String fullName,
    required String password,
    required bool acceptTerms,
    String? email,
    String? companyName,
  }) async {
    final response = await _call(
      () => _api.register({
        'phone': phone,
        'otpCode': otpCode,
        'fullName': fullName,
        'password': password,
        'email': email,
        'companyName': companyName,
        'acceptTerms': acceptTerms,
        'pendingCartItem': null,
      }),
    );
    return _saveSession(response);
  }

  @override
  Future<AuthSession> login({
    required String phone,
    required String password,
  }) async {
    final response = await _call(
      () => _api.login({
        'phone': phone,
        'password': password,
        'pendingCartItem': null,
      }),
    );
    return _saveSession(response);
  }

  @override
  Future<AuthSession> loginWithOtp({
    required String phone,
    required String otpCode,
  }) async {
    final response = await _call(
      () => _api.loginWithOtp({
        'phone': phone,
        'otpCode': otpCode,
        'pendingCartItem': null,
      }),
    );
    return _saveSession(response);
  }

  @override
  Future<AuthUser> currentUser() async {
    final response = await _call(_api.me);
    return AuthModelMapper.userFromJson(_data(response));
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.refreshToken;
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _call(() => _api.logout({'refreshToken': refreshToken}));
      }
    } finally {
      await _storage.clear();
    }
  }

  @override
  Future<void> clearLocalSession() => _storage.clear();

  Future<AuthSession> _saveSession(Map<String, dynamic> response) async {
    final session = AuthModelMapper.sessionFromJson(_data(response));
    if (session.accessToken.isEmpty || session.refreshToken.isEmpty) {
      throw const FailureException(AuthFailure());
    }
    await _storage.save(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresInSeconds: session.expiresInSeconds,
    );
    return session;
  }

  Future<Map<String, dynamic>> _call(
    Future<HttpResponse<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FailureException(ServerFailure());
      }
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        raw,
        (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
      );
      if (!parsed.success) {
        final fieldErrors = <String, String>{
          for (final error in parsed.errors)
            if (error.field.isNotEmpty) error.field: error.message,
        };
        if (fieldErrors.isNotEmpty) {
          throw FailureException(
            FieldValidationFailure(fieldErrors: fieldErrors),
          );
        }
        throw FailureException(AuthFailure(parsed.message ?? 'حدث خطأ'));
      }
      return raw;
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const FailureException(NetworkFailure());
      }
      throw FailureException(
        ServerFailure(error.response?.statusMessage ?? 'حدث خطأ في الخادم'),
      );
    }
  }

  Map<String, dynamic> _data(Map<String, dynamic> response) {
    final data = response['data'];
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }
}
