import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entities.dart';

enum AuthStatus { initial, loading, unauthenticated, authenticated, failure }

enum AuthOperation { none, sendingOtp, loggingIn, registering, loggingOut }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthOperation operation;
  final AuthUser? user;
  final OtpChallenge? otpChallenge;
  final Map<String, String> fieldErrors;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.operation = AuthOperation.none,
    this.user,
    this.otpChallenge,
    this.fieldErrors = const {},
    this.errorMessage,
  });

  bool get isBusy => operation != AuthOperation.none;

  AuthState copyWith({
    AuthStatus? status,
    AuthOperation? operation,
    AuthUser? user,
    OtpChallenge? otpChallenge,
    Map<String, String>? fieldErrors,
    String? errorMessage,
    bool clearError = false,
    bool clearOtpChallenge = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      operation: operation ?? this.operation,
      user: user ?? this.user,
      otpChallenge: clearOtpChallenge
          ? null
          : otpChallenge ?? this.otpChallenge,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    operation,
    user,
    otpChallenge,
    fieldErrors,
    errorMessage,
  ];
}
