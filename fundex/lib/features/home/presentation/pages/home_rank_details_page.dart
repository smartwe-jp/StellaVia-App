import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../widgets/home_rank_details_section.dart';

class HomeRankDetailsPage extends StatelessWidget {
  const HomeRankDetailsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.appColors.surface,
    appBar: AppBar(
      title: Text(context.l10n.homeRankDetails),
      leading: BackButton(
        onPressed: () {
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
