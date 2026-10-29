import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../controllers/home_simulation_controller.dart';
import '../providers/home_miles_providers.dart';
import '../support/home_simulation_theme.dart';
import '../widgets/home_simulation_inputs.dart';
import '../widgets/home_simulation_result.dart';
import '../widgets/home_data_status.dart';

class HomeSimulationPage extends ConsumerWidget {
  const HomeSimulationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final input = ref.watch(homeSimulationInputProvider);
    final controller = ref.read(homeSimulationInputProvider.notifier);
    final rules = ref.watch(homeRankDetailsRulesProvider);
    final calculator = ref.watch(homeSimulationCalculatorProvider);
    final result = calculator(input, rules.data ?? const []);
    final member = ref.watch(isAuthenticatedProvider).asData?.value == true;
    return Scaffold(
      backgroundColor: HomeSimulationTheme.background(context),
      appBar: AppBar(
        backgroundColor: HomeSimulationTheme.background(context),
        title: Text(l.simTitle),
        centerTitle: true,
        leadingWidth: 85,
        leading: TextButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/simulation_back.png',
                width: 10,
                height: 16,
              ),
              const SizedBox(width: 4),
              Flexible(child: Text(l.commonBack)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            children: [
              HomeSimulationInputs(
                input: input,
                onUnits: controller.setUnits,
                onRate: controller.setRate,
                onMonths: controller.setMonths,
                onType: controller.setType,
              ),
              const SizedBox(height: 12),
              HomeSimulationResultCard(result: result, input: input),
              if (rules.isLoading || rules.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: HomeDataStatus(
                    isLoading: rules.isLoading,
                    hasError: rules.hasError,
                    onRetry: () => ref
                        .read(homeRankDetailsRulesProvider.notifier)
                        .refresh(),
                  ),
                ),
              const SizedBox(height: 12),
              Text(l.simEstimateNote, style: context.appTextTheme.caption),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ColoredBox(
        color: context.appColors.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: AppButton(
              label: member ? l.homeFindFunds : l.simRegister,
              minHeight: 50,
              onPressed: () => member
                  ? context.go('/funds')
                  : context.push('/login?openRegister=1'),
            ),
          ),
        ),
      ),
    );
  }
}
