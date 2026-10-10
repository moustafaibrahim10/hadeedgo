import 'package:equatable/equatable.dart';
import '../../domain/entities/home_content.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeContent? content;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.content,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeContent? content,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      content: content ?? this.content,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, content, errorMessage];
}
