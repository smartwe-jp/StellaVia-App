import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/mypage_membership_providers.dart';
import '../support/mypage_rank_display.dart';

class MyPageMilesExpirySheet extends ConsumerWidget {
  const MyPageMilesExpirySheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(myPageMilesExpiryProvider);
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.myPageRankExpiryTitle,
                  style: context.appTextTheme.sectionTitle,
                ),
              ),
              const CloseButton(),
            ],
          ),
          data.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            error: (_, __) => Column(
              children: [
                Text(l.myPageChartLoadFailed),
                TextButton(
                  onPressed: () => ref.invalidate(myPageMilesExpiryProvider),
                  child: Text(l.commonRetry),
                ),
              ],
            ),
            data: (rows) => rows.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(l.myPageRankExpiryEmpty),
                  )
                : Column(
                    children: [
                      for (final row in rows)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            MyPageRankDisplay.expiryDate(
                              row.expireDate,
                              locale,
                            ),
                          ),
                          trailing: Text(
                            '${MyPageRankDisplay.number(row.amount, locale)} ${l.myPageChartMileUnit}',
                            style: context.appTextTheme.numericBody,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
