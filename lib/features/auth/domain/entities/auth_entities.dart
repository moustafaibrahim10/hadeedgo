class AuthUser {
  final String id;
  final String? fullName;
  final String? phone;
  final String? email;
  final String? companyName;
  final String? avatarUrl;
  final bool isPhoneVerified;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    this.fullName,
    this.phone,
    this.email,
    this.companyName,
    this.avatarUrl,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
  });
}

class AuthSession {
  final String accessToken;
  final String refreshToken;
  final int? expiresInSeconds;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.expiresInSeconds,
  });
}

class OtpChallenge {
  final String phone;
  final String purpose;
  final String channel;
  final int expiresInSeconds;

  const OtpChallenge({
    required this.phone,
    required this.purpose,
    required this.channel,
    required this.expiresInSeconds,
  });
}
