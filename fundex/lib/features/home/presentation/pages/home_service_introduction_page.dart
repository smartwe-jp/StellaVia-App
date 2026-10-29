import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/home_rank_details_section.dart';
import '../widgets/home_service_sections.dart';

class HomeServiceIntroductionPage extends ConsumerWidget {
  const HomeServiceIntroductionPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = ref.watch(isAuthenticatedProvider).valueOrNull ?? false;
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: AppBar(
        title: Text(context.l10n.homeServiceTitle),
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
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          key: const PageStorageKey('home_service_introduction'),
          child: Column(
            children: [
              const HomeServiceAboutSection(),
              const HomeServiceReturnsSection(),
              HomeRankDetailsSection(
                onDetails: () => context.push('/home/ranks'),
              ),
              const HomeServiceStartSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: AppButton(
            label: member
                ? context.l10n.homeFindFunds
                : context.l10n.homeRegisterFree,
            minHeight: 52,
            onPressed: () {
              if (member) {
                context.go('/funds');
              } else {
                context.push('/login?openRegister=1');
              }
            },
          ),
        ),
      ),
    );
  }
}
