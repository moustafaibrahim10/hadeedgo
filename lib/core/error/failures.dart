import 'package:equatable/equatable.dart';

/// Base failure class — returned from repositories/usecases to presentation layer.
/// Domain layer never imports Flutter or Dio — failures are plain Dart.
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// General server-side error (non-field-specific).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم']);
}

/// Network/connectivity failure.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تحقق من اتصالك بالإنترنت']);
}

/// Auth-specific failure (invalid credentials, expired token, etc.).
class AuthFailure extends Failure {
  // The positional optional parameter preserves the existing Failure API.
  // ignore: use_super_parameters
  const AuthFailure([String message = 'خطأ في المصادقة']) : super(message);
}

/// Field-level validation failures from the backend.
class FieldValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const FieldValidationFailure({
    required this.fieldErrors,
    String message = 'يرجى مراجعة البيانات المدخلة',
  }) : super(message);

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// OTP-specific failures.
class OtpFailure extends Failure {
  const OtpFailure([super.message = 'رمز التحقق غير صحيح أو منتهي']);
}

/// Session expired — triggers logout.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure([
    super.message = 'انتهت جلستك، يرجى تسجيل الدخول',
  ]);
}
