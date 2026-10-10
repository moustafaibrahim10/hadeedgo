import 'failures.dart';

class FailureException implements Exception {
  final Failure failure;

  const FailureException(this.failure);
}
