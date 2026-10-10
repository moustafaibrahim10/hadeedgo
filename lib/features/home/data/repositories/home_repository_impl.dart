import 'package:dio/dio.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/home_content.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_api_service.dart';
import '../models/home_models.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _api;

  const HomeRepositoryImpl(this._api);

  @override
  Future<HomeContent> getHome() async {
    try {
      final response = await _api.getHome();
      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const FailureException(ServerFailure());
      }
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        raw,
        (json) => json is Map<String, dynamic> ? json : <String, dynamic>{},
      );
      if (!parsed.success) {
        throw FailureException(
          ServerFailure(parsed.message ?? 'تعذر تحميل الصفحة الرئيسية'),
        );
      }
      final data = raw['data'];
      return HomeModelMapper.fromJson(
        data is Map<String, dynamic> ? data : const {},
      );
    } on FailureException {
      rethrow;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const FailureException(NetworkFailure());
      }
      throw FailureException(
        ServerFailure(
          error.response?.statusMessage ?? 'تعذر تحميل الصفحة الرئيسية',
        ),
      );
    }
  }
}
