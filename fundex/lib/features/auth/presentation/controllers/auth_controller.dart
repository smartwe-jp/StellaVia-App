import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../domain/usecases/login_with_code_usecase.dart';
import '../../domain/usecases/send_login_code_usecase.dart';
import '../state/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._sendCode, this._login) : super(const AuthState());

  final SendLoginCodeUseCase _sendCode;
  final LoginWithCodeUseCase _login;

  void onAccountChanged(String value) {
    state = state.copyWith(account: value, clearError: true);
  }

  void onCodeChanged(String value) {
    state = state.copyWith(code: value, clearError: true);
  }

  Future<bool> sendCode({String? intlCode}) async {
    if (!state.canSendCode) return false;
    state = state.copyWith(isSendingCode: true, clearError: true);

    try {
      await _sendCode.call(account: state.account.trim(), intlCode: intlCode);
      state = state.copyWith(isSendingCode: false);
      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingCode: false,
        errorKey: AuthErrorKey.sendCodeFailed,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return false;
    }
  }

  Future<bool> login({String? intlCode}) async {
    if (!state.canLogin) return false;
    state = state.copyWith(
      isLoggingIn: true,
      clearError: true,
      clearSession: true,
    );

    try {
      final session = await _login.call(
        account: state.account.trim(),
        code: state.code.trim(),
        intlCode: intlCode,
      );
      state = state.copyWith(isLoggingIn: false, session: session);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoggingIn: false,
        errorKey: AuthErrorKey.loginFailed,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return false;
    }
  }
}
