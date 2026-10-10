import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionStorage {
  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';
  static const _expiresInSecondsKey = 'auth.expires_in_seconds';

  final FlutterSecureStorage _storage;

  const SessionStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  Future<String?> get accessToken => _storage.read(key: _accessTokenKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshTokenKey);

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    int? expiresInSeconds,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    if (expiresInSeconds != null) {
      await _storage.write(
        key: _expiresInSecondsKey,
        value: expiresInSeconds.toString(),
      );
    }
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresInSecondsKey),
    ]);
  }

  Future<bool> get hasSession async => (await accessToken) != null;
}
