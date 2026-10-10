import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtpUseCase _sendOtp;
  final RegisterUseCase _register;
  final LoginUseCase _login;
  final LoginWithOtpUseCase _loginWithOtp;
  final CurrentUserUseCase _currentUser;
  final LogoutUseCase _logout;
  final ClearLocalSessionUseCase _clearLocalSession;

  AuthCubit({
    required this._sendOtp,
    required this._register,
    required this._login,
    required this._loginWithOtp,
    required this._currentUser,
    required this._logout,
    required this._clearLocalSession,
  }) : super(const AuthState());

  Future<void> restoreSession() async {
    emit(
      state.copyWith(status: AuthStatus.loading, operation: AuthOperation.none),
    );
    try {
      final user = await _currentUser();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (_) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> sendOtp({
    required String phone,
    required String purpose,
    required String channel,
  }) async {
    if (state.isBusy) return;
    emit(
      state.copyWith(
        operation: AuthOperation.sendingOtp,
        fieldErrors: const {},
        clearError: true,
      ),
    );
    try {
      final challenge = await _sendOtp(
        phone: phone,
        purpose: purpose,
        channel: channel,
      );
      emit(
        state.copyWith(
          operation: AuthOperation.none,
          otpChallenge: challenge,
          clearError: true,
        ),
      );
    } catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> login({required String phone, required String password}) async {
    if (state.isBusy) return;
    emit(
      state.copyWith(
        operation: AuthOperation.loggingIn,
        fieldErrors: const {},
        clearError: true,
      ),
    );
    try {
      await _login(phone: phone, password: password);
      final user = await _currentUser();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> loginWithOtp({
    required String phone,
    required String otpCode,
  }) async {
    if (state.isBusy) return;
    emit(state.copyWith(operation: AuthOperation.loggingIn, clearError: true));
    try {
      await _loginWithOtp(phone: phone, otpCode: otpCode);
      final user = await _currentUser();
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> register({
    required String phone,
    required String otpCode,
    required String fullName,
    required String password,
    required bool acceptTerms,
    String? email,
    String? companyName,
  }) async {
    if (state.isBusy) return;
    emit(
      state.copyWith(
        operation: AuthOperation.registering,
        fieldErrors: const {},
        clearError: true,
      ),
    );
    try {
      await _register(
        phone: phone,
        otpCode: otpCode,
        fullName: fullName,
        password: password,
        acceptTerms: acceptTerms,
        email: email,
        companyName: companyName,
      );
      await _clearLocalSession();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (error) {
      _emitFailure(error);
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(operation: AuthOperation.loggingOut));
    try {
      await _logout();
    } finally {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  void consumeOtpChallenge() {
    emit(state.copyWith(clearOtpChallenge: true));
  }

  void _emitFailure(Object error) {
    final failure = error is FailureException
        ? error.failure
        : const AuthFailure();
    final fieldErrors = failure is FieldValidationFailure
        ? failure.fieldErrors
        : const <String, String>{};
    emit(
      AuthState(
        status: AuthStatus.failure,
        operation: AuthOperation.none,
        fieldErrors: fieldErrors,
        errorMessage: fieldErrors.isEmpty ? failure.message : null,
      ),
    );
  }
}
