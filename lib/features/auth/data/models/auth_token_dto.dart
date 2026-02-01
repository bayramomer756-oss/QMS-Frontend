import '../../domain/entities/auth_token.dart';

class AuthTokenDto extends AuthToken {
  AuthTokenDto({required super.token, required super.expiration});

  factory AuthTokenDto.fromJson(Map<String, dynamic> json) {
    return AuthTokenDto(
      token: json['token'] as String,
      expiration: DateTime.parse(json['expiration'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'expiration': expiration.toIso8601String()};
  }
}
