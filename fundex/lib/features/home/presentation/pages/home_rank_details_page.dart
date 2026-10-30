import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../widgets/home_rank_details_section.dart';

class HomeRankDetailsPage extends StatelessWidget {
  const HomeRankDetailsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppNavigationBar(
      title: context.l10n.homeRankDetails,
      backgroundColor: context.appColors.surface,
      foregroundColor: context.appColors.textPrimary,
      leading: AppNavigationIconButton(
        icon: Icons.arrow_back_rounded,
        backgroundColor: context.appColors.surface.withValues(alpha: 0),
        foregroundColor: context.appColors.textPrimary,
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
    ),
    body: const SafeArea(
      top: false,
      child: SingleChildScrollView(
        key: PageStorageKey('home_rank_details'),
        child: HomeRankDetailsSection(),
      ),
    ),
  );
}
