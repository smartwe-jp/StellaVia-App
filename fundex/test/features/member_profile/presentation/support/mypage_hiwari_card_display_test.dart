import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/mypage_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_hiwari_card_display.dart';
import 'package:fundex/l10n/app_localizations_ja.dart';

void main() {
  final l10n = AppLocalizationsJa();

  test(
    'classifies each job and renders its own calculation and payout period',
    () {
      final display = buildMyPageHiwariCardDisplayData(l10n, const [
        MyPageHiwariJob(processId: 'a', fromProcessId: 'b'),
        MyPageHiwariJob(
          processId: 'a',
          fromProcessId: 'a',
          startDate: '2024-10-27',
        ),
        MyPageHiwariJob(
          processId: 'a',
          fromProcessId: 'a',
          startDate: '2024-10-28',
          endDate: '2024-12-31',
          headStartDate: '2024-10-01',
          headEndDate: '2024-12-31',
          num: 7,
        ),
        MyPageHiwariJob(
          processId: 'a',
          fromProcessId: 'a',
          startDate: '2024-10-29',
        ),
      ], operationStart: '2024-10-28 12:00:00');
      expect(display.blocks.map((block) => block.badgeLabel), [
        '譲渡による日割り',
        '入金による日割り',
        '成約による日割り',
        '成約による日割り',
      ]);
      expect(display.blocks[2].rows.map((row) => row.value), [
        '2024/10/28～2024/12/31',
        '2024/10/01～2024/12/31',
        '7',
        '2024/10/28',
      ]);
      expect(display.blocks.first.rows.first.value, '—');
    },
  );

  test('keeps period visible when operation start is missing', () {
    final display = buildMyPageHiwariCardDisplayData(l10n, const [
      MyPageHiwariJob(
        processId: 'a',
        fromProcessId: 'a',
        startDate: '2024-10-28',
      ),
    ], operationStart: null);
    expect(display.blocks.single.badgeLabel, isNull);
    expect(display.blocks.single.rows.first.value, '2024/10/28～—');
  });
}
