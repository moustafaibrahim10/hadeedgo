import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadHome({bool force = false}) async {
    if (state.status == HomeStatus.loading && !force) return;
    emit(state.copyWith(status: HomeStatus.loading, clearError: true));
    try {
      final content = await _repository.getHome();
      emit(HomeState(status: HomeStatus.success, content: content));
    } catch (error) {
      final failure = error is FailureException
          ? error.failure
          : const ServerFailure();
      emit(
        HomeState(status: HomeStatus.failure, errorMessage: failure.message),
      );
    }
  }
}
