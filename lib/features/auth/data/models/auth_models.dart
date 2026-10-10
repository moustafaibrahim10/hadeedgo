import '../../domain/entities/auth_entities.dart';

class AuthModelMapper {
  static AuthUser userFromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      companyName: json['companyName']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      isPhoneVerified: json['isPhoneVerified'] == true,
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }

  static AuthSession sessionFromJson(Map<String, dynamic> data) {
    final user = data['user'];
    return AuthSession(
      accessToken: data['accessToken']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
      expiresInSeconds: _intValue(data['expiresInSeconds']),
      user: user is Map<String, dynamic>
          ? userFromJson(user)
          : const AuthUser(id: ''),
    );
  }

  static OtpChallenge otpFromJson(Map<String, dynamic> data) {
    return OtpChallenge(
      phone: data['phone']?.toString() ?? '',
      purpose: data['purpose']?.toString() ?? '',
      channel: data['channel']?.toString() ?? '',
      expiresInSeconds: _intValue(data['expiresInSeconds']) ?? 0,
    );
  }

  static int? _intValue(Object? value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
}
