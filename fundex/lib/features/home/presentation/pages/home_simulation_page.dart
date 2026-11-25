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
import '../widgets/simulation_hotel_results.dart';
import '../providers/simulation_hotels_provider.dart';
import '../widgets/home_simulation_result.dart';
import '../widgets/home_data_status.dart';

class HomeSimulationPage extends ConsumerStatefulWidget {
  const HomeSimulationPage({super.key});
  @override
  ConsumerState<HomeSimulationPage> createState() => _HomeSimulationPageState();
}

class _HomeSimulationPageState extends ConsumerState<HomeSimulationPage> {
  final _resultKey = GlobalKey();
  bool _showHotels = false;

  void _run(int? points) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_showHotels && points != null) {
      ref.invalidate(simulationHotelsProvider(points));
    }
    setState(() => _showHotels = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _resultKey.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 250),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(homeSimulationInputProvider, (_, __) {
      if (!_showHotels) setState(() => _showHotels = true);
    });
    final l = context.l10n;
    final input = ref.watch(homeSimulationInputProvider);
    final controller = ref.read(homeSimulationInputProvider.notifier);
    final rules = ref.watch(homeRankDetailsRulesProvider);
    final calculator = ref.watch(homeSimulationCalculatorProvider);
    final result = calculator(input, rules.data ?? const []);
    final member = ref.watch(isAuthenticatedProvider).asData?.value == true;
    return Scaffold(
      backgroundColor: HomeSimulationTheme.background(context),
      appBar: AppNavigationBar(
        title: l.simTitle,
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
      bottomNavigationBar: member
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                child: AppButton(
                  label: l.simRegister,
                  minHeight: 50,
                  onPressed: () => context.push('/guest-guide/register'),
                ),
              ),
            ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom:
                UiTokens.spacing20 +
                (member ? MediaQuery.paddingOf(context).bottom : 0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UiTokens.spacing20,
                ),
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
                    AppButton(
                      label: l.simRunAction,
                      onPressed: () => _run(result.miles),
                    ),
                    const SizedBox(height: 12),
                    HomeSimulationResultCard(
                      key: _resultKey,
                      result: result,
                      input: input,
                    ),
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
                    Text(
                      l.simEstimateNote,
                      style: context.appTextTheme.caption,
                    ),
                  ],
                ),
              ),
              if (_showHotels && result.miles != null) ...[
                const SizedBox(height: 16),
                SimulationHotelResults(points: result.miles!),
              ],
              if (member) ...[
                const SizedBox(height: UiTokens.spacing16),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiTokens.spacing20,
                  ),
                  child: AppButton(
                    label: l.homeFindFunds,
                    minHeight: 50,
                    onPressed: () => context.go('/funds'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
