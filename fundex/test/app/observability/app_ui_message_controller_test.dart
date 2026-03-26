import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/observability/app_observability_providers.dart';

void main() {
  group('AppUiMessageController', () {
    test('publishes and clears message by id', () {
      final controller = AppUiMessageController();

      controller.showError(AppUiMessageKey.networkUnavailable);
      final first = controller.state;

      expect(first, isNotNull);
      expect(first!.key, AppUiMessageKey.networkUnavailable);

      controller.clearIfMatches(first.id);
      expect(controller.state, isNull);
    });

    test('publishes custom message when provided', () {
      final controller = AppUiMessageController();

      controller.showError(
        AppUiMessageKey.requestFailed,
        customMessage: 'アカウントはシステムに存在しません',
      );

      expect(controller.state, isNotNull);
      expect(controller.state!.key, AppUiMessageKey.requestFailed);
      expect(controller.state!.customMessage, 'アカウントはシステムに存在しません');
    });
  });
}
