import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/mypage_providers.dart';
import '../support/mypage_secondary_market_models.dart';
import '../support/mypage_section_support.dart';

class SecondaryMarketSellEntry extends ConsumerWidget {
  const SecondaryMarketSellEntry({super.key, required this.record});
  final MyPageActiveFundDetailSeed? record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seed = buildDisplayedRecordSellSeed(record);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          label: context.l10n.myPageResaleTabOrder,
          onPressed: seed == null || seed.availableUnits <= 0
              ? null
              : () async {
                  if (kDebugMode) {
                    debugPrint(
                      '[SecondaryMarketSellEntry] projectId=${seed.projectId} '
                      'processId=${seed.fromProcessId} '
                      'investNum=${record?.investNum} '
                      'investNumValid=${record?.investNumValid} '
                      'investNumRemaining=${record?.investNumRemaining} '
                      'sellLimit=${seed.availableUnits}',
                    );
                  }
                  await context.push('/my/secondary-market/sell', extra: seed);
                  if (context.mounted) {
                    ref.invalidate(myPageInvestmentListProvider);
                  }
                },
        ),
      ),
    );
  }
}
