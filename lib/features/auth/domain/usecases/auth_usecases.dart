import '../entities/auth_entities.dart';
import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;
  const SendOtpUseCase(this._repository);

  Future<OtpChallenge> call({
    required String phone,
    required String purpose,
    required String channel,
  }) => _repository.sendOtp(phone: phone, purpose: purpose, channel: channel);
}

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<AuthSession> call({
    required String phone,
    required String otpCode,
    required String fullName,
    required String password,
    required bool acceptTerms,
    String? email,
    String? companyName,
  }) => _repository.register(
    phone: phone,
    otpCode: otpCode,
    fullName: fullName,
    password: password,
    acceptTerms: acceptTerms,
    email: email,
    companyName: companyName,
  );
}

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<AuthSession> call({required String phone, required String password}) =>
      _repository.login(phone: phone, password: password);
}

class LoginWithOtpUseCase {
  final AuthRepository _repository;
  const LoginWithOtpUseCase(this._repository);

  Future<AuthSession> call({required String phone, required String otpCode}) =>
      _repository.loginWithOtp(phone: phone, otpCode: otpCode);
}

class CurrentUserUseCase {
  final AuthRepository _repository;
  const CurrentUserUseCase(this._repository);

  Future<AuthUser> call() => _repository.currentUser();
}

class LogoutUseCase {
  final AuthRepository _repository;
  const LogoutUseCase(this._repository);

  Future<void> call() => _repository.logout();
}

class ClearLocalSessionUseCase {
  final AuthRepository _repository;
  const ClearLocalSessionUseCase(this._repository);

  Future<void> call() => _repository.clearLocalSession();
}
