import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/member_profile/presentation/support/mypage_miles_history.dart';
import 'package:fundex/l10n/app_localizations.dart';

void main() {
  const cases = {
    'EARN': (MilesHistoryKind.monthlyEarn, true),
    'EARN_FIRST_INVEST': (MilesHistoryKind.firstInvestEarn, true),
    'EARN_FIRST_IDENTIFY': (MilesHistoryKind.firstIdentifyEarn, true),
    'CONSUME': (MilesHistoryKind.used, false),
    'EXPIRE': (MilesHistoryKind.expired, false),
    'CANCEL_CONSUMED': (MilesHistoryKind.refunded, true),
  };
  for (final entry in cases.entries) {
    test(
      '${entry.key} controls classification and sign regardless of description',
      () {
        for (final amount in [-1234, 1234, 0]) {
          final kind = MilesHistoryKind.of(
            HostMilesTransaction(
              bizType: entry.key,
              typeDescription: entry.value.$2 ? 'expire soon' : 'earn',
              amount: amount,
            ),
          );
          expect(kind, entry.value.$1);
          expect(kind.isCredit, entry.value.$2);
          expect(
            kind.amount(amount, 'en', 'mile'),
            '${entry.value.$2 ? '+' : '-'}${amount == 0 ? '0' : '1,234'}mile',
          );
        }
      },
    );
  }

  test('six transaction labels are distinct in all four locales', () async {
    final labels = {
      const Locale('en'): [
        'Monthly award',
        'First investment reward',
        'First identity verification reward',
        'Used',
        'Expired',
        'Refund',
      ],
      const Locale('ja'): ['毎月定期付与', '初回投資特典', '初回本人確認特典', '利用', '失効', '払い戻し'],
      const Locale('zh'): ['每月定期发放', '首次投资奖励', '首次身份认证奖励', '使用', '失效', '退款'],
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'): [
        '每月定期發放',
        '首次投資獎勵',
        '首次身分認證獎勵',
        '使用',
        '失效',
        '退款',
      ],
    };
    for (final entry in labels.entries) {
      final l = await AppLocalizations.delegate.load(entry.key);
      expect(
        cases.values.map((value) => value.$1.label(l)).toList(),
        entry.value,
      );
    }
  });

  test('legacy descriptions remain compatible', () {
    expect(
      MilesHistoryKind.of(const HostMilesTransaction(typeDescription: 'earn')),
      MilesHistoryKind.earned,
    );
    expect(
      MilesHistoryKind.of(const HostMilesTransaction(bizType: 'SPEND')),
      MilesHistoryKind.used,
    );
    expect(
      MilesHistoryKind.of(
        const HostMilesTransaction(typeDescription: 'expire_soon'),
      ),
      MilesHistoryKind.expiring,
    );
  });
}
