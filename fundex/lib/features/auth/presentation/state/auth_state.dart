import '../../domain/entities/auth_session.dart';

enum AuthErrorKey { sendCodeFailed, loginFailed }

class AuthState {
  const AuthState({
    this.account = '',
    this.code = '',
    this.isSendingCode = false,
    this.isLoggingIn = false,
    this.errorKey,
    this.errorMessage,
    this.session,
  });

  final String account;
  final String code;
  final bool isSendingCode;
  final bool isLoggingIn;
  final AuthErrorKey? errorKey;
  final String? errorMessage;
  final AuthSession? session;

  bool get canSendCode => account.trim().isNotEmpty && !isSendingCode;
  bool get canLogin =>
      account.trim().isNotEmpty && code.trim().isNotEmpty && !isLoggingIn;

  AuthState copyWith({
    String? account,
    String? code,
    bool? isSendingCode,
    bool? isLoggingIn,
    AuthErrorKey? errorKey,
    String? errorMessage,
    bool clearError = false,
    bool clearSession = false,
    AuthSession? session,
  }) {
    return AuthState(
      account: account ?? this.account,
      code: code ?? this.code,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isLoggingIn: isLoggingIn ?? this.isLoggingIn,
      errorKey: clearError ? null : (errorKey ?? this.errorKey),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      session: clearSession ? null : (session ?? this.session),
    );
  }
}
