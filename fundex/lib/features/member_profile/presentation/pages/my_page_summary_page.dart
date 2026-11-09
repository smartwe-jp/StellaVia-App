import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/network/app_network_connectivity_providers.dart';
import '../../domain/entities/mypage_chart.dart';
import '../providers/mypage_chart_providers.dart';
import '../providers/mypage_membership_providers.dart';
import '../providers/mypage_providers.dart';
import '../widgets/my_page_summary_section.dart';

class MyPageSummaryPage extends ConsumerWidget {
  const MyPageSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.myPageShortcutSummary,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        backgroundColor: context.appColors.surface,
        foregroundColor: context.appColors.textPrimary,
        onTap: () => context.pop(),
      ),
    ),
    body: RefreshIndicator(
      onRefresh: () async {
        if (shouldSkipAppNetworkRefresh(ref)) return;
        ref.invalidate(myPageAccountStatisticProvider);
        await Future.wait([
          ref.read(myPageTierProvider.notifier).refresh(),
          ref.read(myPageMilesAccountProvider.notifier).refresh(),
          for (final kind in MyPageChartKind.values)
            ref.read(myPageChartProvider(kind).notifier).refresh(),
        ]);
      },
      child: const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24),
        child: MyPageSummarySection(),
      ),
    ),
  );
}
