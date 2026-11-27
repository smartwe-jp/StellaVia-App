import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/home_rank_details_section.dart';
import '../widgets/home_service_sections.dart';
import '../widgets/home_features_guide.dart';
import '../widgets/home_service_faq_section.dart';
import '../widgets/home_service_feature_sections.dart';
import '../widgets/home_mile_stories_section.dart';
import '../widgets/home_simulation_card.dart';

class HomeServiceDetailPage extends ConsumerWidget {
  const HomeServiceDetailPage.features({super.key}) : _features = true;
  const HomeServiceDetailPage.benefits({super.key}) : _features = false;

  final bool _features;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final member = ref.watch(isAuthenticatedProvider).valueOrNull ?? false;
    return Scaffold(
      appBar: AppNavigationBar(
        title: _features ? l.featuresDetailTitle : l.homeServiceTitle,
        backgroundColor: context.appColors.surface,
        foregroundColor: context.appColors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          backgroundColor: context.appColors.surface.withValues(alpha: 0),
          foregroundColor: context.appColors.textPrimary,
          onTap: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          children: [
            if (_features) ...[
              const HomeFeaturesIntro(),
              const HomeServiceFeatureSections(),
            ] else ...[
              const HomeServiceBenefitsSection(),
              const HomeRankDetailsSection(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: HomeSimulationCard(
                  eyebrow: l.benefitsSimEyebrow,
                  title: l.simTitle,
                  onTap: () => context.push('/home/simulation'),
                ),
              ),
              const HomeMileStoriesSection(),
            ],
            if (_features)
              const HomeFeaturesSteps()
            else
              const HomeServiceStartSection(showMemberNote: false),
            if (_features) const HomeServiceFaqSection(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: AppButton(
            label: member ? l.homeFindFunds : l.homeRegisterFree,
            onPressed: () => member
                ? context.go('/funds')
                : context.push('/guest-guide/register'),
          ),
        ),
      ),
    );
  }
}
