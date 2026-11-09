import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/mypage_membership_providers.dart';
import '../providers/mypage_miles_history_provider.dart';
import '../widgets/my_page_miles_history_list.dart';

class MyPageMilesHistoryPage extends ConsumerWidget {
  const MyPageMilesHistoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    backgroundColor: context.appColors.surface,
    appBar: AppNavigationBar(
      title: context.l10n.myPageMilesHistoryTitle,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        backgroundColor: context.appColors.surface,
        foregroundColor: context.appColors.textPrimary,
        onTap: () => context.pop(),
      ),
    ),
    body: _HistoryBody(
      key: ValueKey(ref.watch(myPageMembershipIdentityProvider)),
    ),
  );
}

class _HistoryBody extends ConsumerStatefulWidget {
  const _HistoryBody({super.key});
  @override
  ConsumerState<_HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends ConsumerState<_HistoryBody> {
  int page = 1, limit = 10;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final provider = myPageMilesHistoryProvider((page: page, limit: limit));
    final result = ref.watch(provider);
    final history = result.asData?.value;
    final pageButtonStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(56, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AppDropdownSelector<int>(
                value: limit,
                tooltip: l.myPageMilesHistoryCount(limit),
                options: [
                  for (final count in [10, 20, 50, 100])
                    AppDropdownOption(
                      value: count,
                      label: l.myPageMilesHistoryCount(count),
                    ),
                ],
                onChanged: (count) => setState(() {
                  limit = count;
                  page = 1;
                }),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: result.when(
                skipLoadingOnReload: false,
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (_, __) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l.myPageMilesHistoryError),
                      TextButton(
                        onPressed: () => ref.invalidate(provider),
                        child: Text(l.commonRetry),
                      ),
                    ],
                  ),
                ),
                data: (value) => MyPageMilesHistoryList(
                  key: ValueKey((page, limit)),
                  history: value,
                ),
              ),
            ),
            if (page > 1 ||
                (history != null && history.groups.isNotEmpty) ||
                (history?.pages ?? 0) > 1)
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton(
                      style: pageButtonStyle,
                      onPressed: page > 1 && !result.isLoading
                          ? () => setState(() => page--)
                          : null,
                      child: Text(l.myPageMilesHistoryPrev),
                    ),
                    Text('$page / ${history?.pages ?? '—'}'),
                    OutlinedButton(
                      style: pageButtonStyle,
                      onPressed:
                          history != null &&
                              page < history.pages &&
                              !result.isLoading
                          ? () => setState(() => page++)
                          : null,
                      child: Text(l.myPageMilesHistoryNext),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
