import 'package:dio/dio.dart';
import '../storage/session_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio _refreshDio;
  final SessionStorage _storage;
  Future<bool>? _refreshing;

  AuthInterceptor(this._refreshDio, this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshRequest = request.path.endsWith('/auth/refresh');
    if (!isUnauthorized ||
        isRefreshRequest ||
        request.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    final refreshed = await (_refreshing ??= _refresh()).whenComplete(() {
      _refreshing = null;
    });
    if (!refreshed) {
      await _storage.clear();
      handler.next(err);
      return;
    }

    request.extra['retried'] = true;
    final token = await _storage.accessToken;
    request.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await _refreshDio.fetch(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refresh() async {
    final refreshToken = await _storage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) return false;
      final accessToken = data['accessToken']?.toString();
      final nextRefreshToken = data['refreshToken']?.toString();
      if (accessToken == null || nextRefreshToken == null) return false;
      await _storage.save(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
        expiresInSeconds: (data['expiresInSeconds'] as num?)?.toInt(),
      );
      return true;
    } on DioException {
      return false;
    }
  }
}
