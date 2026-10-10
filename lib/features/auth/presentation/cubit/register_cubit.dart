import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  Future<void> register({
    required String fullName,
    required String? companyName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    emit(const RegisterState(status: RegisterStatus.loading));

    try {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      emit(
        const RegisterState(
          status: RegisterStatus.success,
          message: RegisterMessage.success,
        ),
      );
    } catch (_) {
      emit(
        const RegisterState(
          status: RegisterStatus.failure,
          message: RegisterMessage.failure,
        ),
      );
    }
  }
}
