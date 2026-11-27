import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/home_simulation.dart';
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
  HomeSimulationInput? _submittedInput;
  HomeSimulationResult? _result;
  bool _dirty = false;

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  void _run() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusManager.instance.applyFocusChangesIfNeeded();
    final input = ref.read(homeSimulationInputProvider);
    final rules = ref.read(homeRankDetailsRulesProvider);
    final result = ref.read(homeSimulationCalculatorProvider)(
      input,
      rules.data ?? const [],
    );
    if (!_dirty && _result?.miles == result.miles && result.miles != null) {
      ref.invalidate(simulationHotelsProvider(result.miles!));
    }
    setState(() {
      _submittedInput = input;
      _result = result;
      _dirty = false;
    });
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
      _markDirty();
    });
    final l = context.l10n;
    final input = ref.watch(homeSimulationInputProvider);
    final controller = ref.read(homeSimulationInputProvider.notifier);
    final rules = ref.watch(homeRankDetailsRulesProvider);
    final result = _result;
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
                    Text(l.benefitsSimLead, style: context.appTextTheme.body),
                    const SizedBox(height: 12),
                    HomeSimulationInputs(
                      input: input,
                      onTextEdited: _markDirty,
                      onUnits: controller.setUnits,
                      onRate: controller.setRate,
                      onMonths: controller.setMonths,
                      onType: controller.setType,
                    ),
                    const SizedBox(height: 12),
                    if (result == null || _dirty) ...[
                      Text(
                        result == null
                            ? l.simReadyToRun
                            : l.simConditionsChanged,
                        style: context.appTextTheme.bodyStrong,
                      ),
                      const SizedBox(height: 8),
                    ],
                    AppButton(
                      label: l.simRunAction,
                      onPressed: rules.isLoading ? null : _run,
                    ),
                    const SizedBox(height: 12),
                    if (result != null)
                      HomeSimulationResultCard(
                        key: _resultKey,
                        result: result,
                        input: _submittedInput!,
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
              if (!_dirty && result?.miles != null) ...[
                const SizedBox(height: 16),
                SimulationHotelResults(points: result!.miles!),
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
