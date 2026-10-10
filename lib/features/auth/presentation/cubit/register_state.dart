import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, loading, success, failure }

enum RegisterMessage { success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final RegisterMessage? message;

  const RegisterState({this.status = RegisterStatus.initial, this.message});

  RegisterState copyWith({RegisterStatus? status, RegisterMessage? message}) {
    return RegisterState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}
