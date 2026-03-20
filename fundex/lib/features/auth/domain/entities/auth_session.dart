import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

@freezed
abstract class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthSession;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
