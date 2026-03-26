import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_session.dart';
import 'package:fundex/features/auth/domain/repositories/auth_repository.dart';
import 'package:fundex/features/auth/domain/usecases/login_with_code_usecase.dart';
import 'package:fundex/features/auth/domain/usecases/send_login_code_usecase.dart';
import 'package:fundex/features/auth/presentation/controllers/auth_controller.dart';
import 'package:fundex/features/auth/presentation/state/auth_state.dart';

class _FakeRepository implements AuthRepository {
  bool sendCodeCalled = false;

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {
    sendCodeCalled = true;
  }

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) async {
    return AuthSession(
      accessToken: 'token',
      refreshToken: 'refresh',
      expiresAt: DateTime(2100),
    );
  }

  @override
  Future<bool> refreshSession() async {
    return true;
  }

  @override
  Future<bool> restoreSession() async {
    return true;
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}

void main() {
  test('send code updates state', () async {
    final repo = _FakeRepository();
    final controller = AuthController(
      SendLoginCodeUseCase(repo),
      LoginWithCodeUseCase(repo),
    );

    controller.onAccountChanged('13900000000');
    await controller.sendCode();

    expect(repo.sendCodeCalled, true);
    expect(controller.state.errorKey, isNull);
  });

  test('login returns true and sets session', () async {
    final repo = _FakeRepository();
    final controller = AuthController(
      SendLoginCodeUseCase(repo),
      LoginWithCodeUseCase(repo),
    );

    controller.onAccountChanged('13900000000');
    controller.onCodeChanged('123456');
    final success = await controller.login();

    expect(success, true);
    expect(controller.state.session, isNotNull);
    expect(controller.state.errorKey, isNull);
  });

  test('send code failure sets localized error key', () async {
    final controller = AuthController(
      SendLoginCodeUseCase(
        _ThrowingSendCodeRepository(loginRepository: _FakeRepository()),
      ),
      LoginWithCodeUseCase(_FakeRepository()),
    );

    controller.onAccountChanged('13900000000');
    await controller.sendCode();

    expect(controller.state.errorKey, AuthErrorKey.sendCodeFailed);
  });

  test('login failure keeps backend message', () async {
    final controller = AuthController(
      SendLoginCodeUseCase(_FakeRepository()),
      LoginWithCodeUseCase(_ThrowingLoginRepository()),
    );

    controller.onAccountChanged('user@example.com');
    controller.onCodeChanged('123456');
    await controller.login();

    expect(controller.state.errorKey, AuthErrorKey.loginFailed);
    expect(controller.state.errorMessage, 'アカウントはシステムに存在しません');
  });
}

class _ThrowingSendCodeRepository implements AuthRepository {
  _ThrowingSendCodeRepository({required this.loginRepository});

  final AuthRepository loginRepository;

  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) {
    return loginRepository.loginWithCode(
      account: account,
      code: code,
      intlCode: intlCode,
    );
  }

  @override
  Future<void> logout() {
    return loginRepository.logout();
  }

  @override
  Future<bool> refreshSession() {
    return loginRepository.refreshSession();
  }

  @override
  Future<bool> restoreSession() {
    return loginRepository.restoreSession();
  }

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) {
    return loginRepository.registerAccount(
      account: account,
      code: code,
      intlCode: intlCode,
      contact: contact,
    );
  }

  @override
  Future<void> sendLoginCode({required String account, String? intlCode}) {
    throw Exception('send failed');
  }

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) {
    return loginRepository.sendRegisterCode(
      account: account,
      intlCode: intlCode,
    );
  }
}

class _ThrowingLoginRepository implements AuthRepository {
  @override
  Future<AuthSession> loginWithCode({
    required String account,
    required String code,
    String? intlCode,
  }) {
    throw StateError('アカウントはシステムに存在しません');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<bool> refreshSession() async => true;

  @override
  Future<void> registerAccount({
    required String account,
    required String code,
    required String intlCode,
    String? contact,
  }) async {}

  @override
  Future<bool> restoreSession() async => true;

  @override
  Future<void> sendLoginCode({
    required String account,
    String? intlCode,
  }) async {}

  @override
  Future<void> sendRegisterCode({
    required String account,
    required String intlCode,
  }) async {}
}
