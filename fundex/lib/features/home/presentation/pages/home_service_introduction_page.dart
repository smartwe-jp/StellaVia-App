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
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: _ServiceTextScaler(media.textScaler)),
      child: Scaffold(
        appBar: AppNavigationBar(
          title: context.l10n.homeServiceTitle,
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
        body: SafeArea(
          top: false,
          bottom: false,
          child: SingleChildScrollView(
            key: const PageStorageKey('home_service_introduction'),
            child: Column(
              children: [
                const HomeServiceAboutSection(),
                const HomeServiceBenefitsSection(),
                const HomeServiceReturnsSection(),
                HomeRankDetailsSection(rankTextScaler: media.textScaler),
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
      ),
    );
  }
}

// Apply the page's two-point type step before the system accessibility scale.
class _ServiceTextScaler extends TextScaler {
  const _ServiceTextScaler(this.system);
  final TextScaler system;

  @override
  double scale(double fontSize) => system.scale(fontSize + 2);

  @override
  double get textScaleFactor => scale(14) / 14;
}
