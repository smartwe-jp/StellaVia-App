import '../entities/auth_session.dart';

class RegistrationSignInRequired implements Exception {
  const RegistrationSignInRequired([this.serverMessage]);
  final String? serverMessage;
}

abstract class AuthRepository {
  Future<void> sendLoginCode({required String account, String? intlCode});
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  });
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  });
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
    String? inviteCode,
  });
  Future<bool> restoreSession();
  Future<bool> refreshSession();
  Future<void> logout();
}
