import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/app/push/app_push_action.dart';
import 'package:fundex/app/push/app_push_runtime.dart';

void main() {
  group('parseAppPushCommand', () {
    test('parses app update command from nested JSON data', () {
      final command = parseAppPushCommand(
        const AppPushNotificationEvent(
          kind: 'foreground',
          payload: <String, Object?>{
            'data':
                '{"PUSH_ACTION":"app_update","PUSH_ID":"update-1",'
                '"TITLE":"Update title","BODY":"Update body",'
                '"IOS_URL":"https://apps.apple.com/app/example",'
                '"ANDROID_URL":"https://play.google.com/store/apps/details?id=example",'
                '"MIN_BUILD":"10","MAX_BUILD":"20","DISMISSIBLE":"false"}',
          },
        ),
      );

      expect(command, isNotNull);
      expect(command!.action, AppPushAction.appUpdate);
      expect(command.token, 'update-1');
      expect(command.title, 'Update title');
      expect(command.body, 'Update body');
      expect(command.iosUrl, 'https://apps.apple.com/app/example');
      expect(
        command.androidUrl,
        'https://play.google.com/store/apps/details?id=example',
      );
      expect(command.minBuild, 10);
      expect(command.maxBuild, 20);
      expect(command.dismissible, isFalse);
    });

    test('parses campaign command from root payload', () {
      final command = parseAppPushCommand(
        const AppPushNotificationEvent(
          kind: 'opened',
          payload: <String, Object?>{
            'ACTION': 'campaign',
            'MESSAGE_ID': 'campaign-1',
            'TITLE': 'Campaign title',
            'BODY': 'Campaign body',
            'IMAGE_URL': 'https://example.com/campaign.jpg',
            'PRIMARY_LABEL': 'Close',
          },
        ),
      );

      expect(command, isNotNull);
      expect(command!.action, AppPushAction.campaignDialog);
      expect(command.token, 'campaign-1');
      expect(command.imageUrl, 'https://example.com/campaign.jpg');
      expect(command.primaryLabel, 'Close');
    });

    test('ignores retired registration reward notifications', () {
      for (final payload in [
        {
          'extraMap': {'TARGET_PAGE': 'homeCelebration'},
        },
        {'PUSH_ACTION': 'home_celebration'},
        {'ACTION': 'celebration'},
      ]) {
        final event = AppPushNotificationEvent(
          kind: 'foreground',
          payload: payload,
        );
        expect(parseAppPushCommand(event), isNull);
      }
    });

    test('ignores payload without supported action', () {
      final command = parseAppPushCommand(
        const AppPushNotificationEvent(
          kind: 'foreground',
          payload: <String, Object?>{'TITLE': 'Normal notification'},
        ),
      );

      expect(command, isNull);
    });
  });
}
