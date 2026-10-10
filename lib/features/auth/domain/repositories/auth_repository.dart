import '../entities/auth_entities.dart';

abstract interface class AuthRepository {
  Future<OtpChallenge> sendOtp({
    required String phone,
    required String purpose,
    required String channel,
  });

  Future<AuthSession> register({
    required String phone,
    required String otpCode,
    required String fullName,
    required String password,
    required bool acceptTerms,
    String? email,
    String? companyName,
  });

  Future<AuthSession> login({required String phone, required String password});

  Future<AuthSession> loginWithOtp({
    required String phone,
    required String otpCode,
  });

  Future<AuthUser> currentUser();
  Future<void> logout();
  Future<void> clearLocalSession();
}
