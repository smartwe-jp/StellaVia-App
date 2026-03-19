import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/fund_project.dart';
import '../providers/fund_project_providers.dart';
import '../support/fund_lottery_apply_models.dart';
import '../support/fund_lottery_apply_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_amount_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_completed_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_confirm_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_documents_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_selected_step.dart';
import 'fund_lottery_apply/fund_lottery_apply_submitted_step.dart';

class FundLotteryApplyFlowPage extends ConsumerStatefulWidget {
  const FundLotteryApplyFlowPage({
    super.key,
    required this.projectId,
    this.initialStep = FundLotteryApplyStep.amountInput,
    this.allowSubmittedResultAdvance = true,
  });

  final String projectId;
  final FundLotteryApplyStep initialStep;
  final bool allowSubmittedResultAdvance;

  @override
  ConsumerState<FundLotteryApplyFlowPage> createState() =>
      _FundLotteryApplyFlowPageState();
}

class _FundLotteryApplyFlowPageState
    extends ConsumerState<FundLotteryApplyFlowPage> {
  static const int _defaultUnitAmount = 100000;
  static const int _defaultMaxMultiplier = 10;
  static const int _mockStandbyBalance = 650000;
  static const List<int> _quickAmountMultipliers = <int>[1, 3, 5, 10];

  late final TextEditingController _amountController;

  late FundLotteryApplyStep _currentStep;
  int _amount = 0;
  final Set<int> _checkedDocuments = <int>{};
  bool _agreedToApply = false;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _amountController = TextEditingController();
    _amountController.addListener(_handleAmountChanged);
  }

  @override
  void dispose() {
    _amountController
      ..removeListener(_handleAmountChanged)
      ..dispose();
    super.dispose();
  }

  void _handleAmountChanged() {
    final digits = _amountController.text.runes
        .where((int rune) => rune >= 48 && rune <= 57)
        .map(String.fromCharCode)
        .join();
    final parsed = int.tryParse(digits) ?? 0;
    if (_amount == parsed || !mounted) {
      return;
    }
    setState(() {
      _amount = parsed;
    });
  }

  void _selectQuickAmount(int amount) {
    final formatted = CurrencyInputFormatter.formatCurrency(amount.toString());
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _goToStep(FundLotteryApplyStep step) {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentStep = step;
    });
  }

  void _goNextStep() {
    final next = _currentStep.next;
    if (next == null) {
      return;
    }
    _goToStep(next);
  }

  void _goPreviousOrPop() {
    final previous = _currentStep.previous;
    if (previous == null || previous.index < widget.initialStep.index) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/funds/${widget.projectId}');
      }
      return;
    }
    _goToStep(previous);
  }

  void _goHome() {
    context.go('/home');
  }

  void _showToast(String message) {
    if (!mounted) {
      return;
    }
    AppNotice.show(context, message: message);
  }

  bool get _isBalanceEnough => _amount <= _mockStandbyBalance;

  bool _canProceedStep2(int requiredCount) =>
      _checkedDocuments.length == requiredCount;

  String _buildApplicationNumber() {
    final rolling = widget.projectId.codeUnits.fold<int>(0, (
      int accumulator,
      int unit,
    ) {
      return (accumulator * 31 + unit) % 100000;
    });
    final monthText = DateFormat('yyyy-MM').format(DateTime.now());
    return 'FDX-$monthText-${rolling.toString().padLeft(5, '0')}';
  }

  NumberFormat _currencyFormatter(BuildContext context) {
    return NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
  }

  String _formatCurrency(BuildContext context, int value) {
    return _currencyFormatter(context).format(value);
  }

  String _resolveLotteryDate(BuildContext context, FundProject project) {
    final parsed =
        _parseDate(project.distributionDate) ??
        _parseDate(project.offeringEndDatetime) ??
        _parseDate(project.scheduledStartDate);
    if (parsed == null) {
      return context.l10n.myPageResultAnnouncementTbd;
    }
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ja' || locale.languageCode == 'zh') {
      return DateFormat('yyyy年M月d日', locale.toLanguageTag()).format(parsed);
    }
    return DateFormat('MMM d, yyyy', locale.toLanguageTag()).format(parsed);
  }

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ja' || locale.languageCode == 'zh') {
      return DateFormat(
        'yyyy年M月d日 HH:mm',
        locale.toLanguageTag(),
      ).format(dateTime);
    }
    return DateFormat(
      'MMM d, yyyy HH:mm',
      locale.toLanguageTag(),
    ).format(dateTime);
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }
    final normalized = raw.trim();
    final direct = DateTime.tryParse(normalized);
    if (direct != null) {
      return direct.toLocal();
    }
    final sanitized = normalized.replaceAll('/', '-');
    return DateTime.tryParse(sanitized)?.toLocal();
  }

  double _resolveYield(FundProject project) {
    if ((project.expectedDistributionRatioMax ?? 0) > 0) {
      return project.expectedDistributionRatioMax!;
    }
    if ((project.expectedDistributionRatioMin ?? 0) > 0) {
      return project.expectedDistributionRatioMin!;
    }
    return 8.5;
  }

  String _formatYieldPercent(double value) {
    final hasFraction = value % 1 != 0;
    return hasFraction
        ? '${value.toStringAsFixed(1)}%'
        : '${value.toStringAsFixed(0)}%';
  }

  int _resolveUnitAmount(FundProject project) {
    final unit = project.investmentUnit ?? _defaultUnitAmount;
    if (unit <= 0) {
      return _defaultUnitAmount;
    }
    return unit;
  }

  int _resolveMaximumAmount(FundProject project, int unitAmount) {
    final rawMaximum = project.maximumInvestmentPerPerson;
    if (rawMaximum == null || rawMaximum <= 0) {
      return unitAmount * _defaultMaxMultiplier;
    }

    // Backend data may provide "maximum units per person" instead of amount.
    if (rawMaximum < unitAmount) {
      return rawMaximum * unitAmount;
    }

    return rawMaximum;
  }

  List<int> _buildQuickAmounts({
    required int unitAmount,
    required int maximumAmount,
  }) {
    final values = <int>{};
    for (final multiplier in _quickAmountMultipliers) {
      final value = unitAmount * multiplier;
      if (value <= maximumAmount) {
        values.add(value);
      }
    }

    if (values.isEmpty && unitAmount <= maximumAmount) {
      values.add(unitAmount);
    }

    final sorted = values.toList(growable: false)..sort();
    return sorted;
  }

  bool _isAmountInAllowedRange({
    required int unitAmount,
    required int maximumAmount,
  }) {
    return _amount > 0 && _amount % unitAmount == 0 && _amount <= maximumAmount;
  }

  bool _canProceedStep1({required int unitAmount, required int maximumAmount}) {
    return _isAmountInAllowedRange(
          unitAmount: unitAmount,
          maximumAmount: maximumAmount,
        ) &&
        _isBalanceEnough;
  }

  String _buildAmountLabel(
    BuildContext context, {
    required int unitAmount,
    required int maximumAmount,
  }) {
    return context.l10n.lotteryApplyStep1AmountLabelWithRules(
      _formatCurrency(context, unitAmount),
      _formatCurrency(context, maximumAmount),
    );
  }

  String _resolveApplyErrorMessage(BuildContext context, Object error) {
    if (error is StateError) {
      final message = error.message.toString().trim();
      if (message.isNotEmpty) {
        return message;
      }
    }
    return context.l10n.lotteryApplySubmitFailedFallback;
  }

  Future<void> _submitLotteryApply({
    required FundProject project,
    required int unitAmount,
    required int maximumAmount,
  }) async {
    if (_isApplying) {
      return;
    }

    if (!_isAmountInAllowedRange(
      unitAmount: unitAmount,
      maximumAmount: maximumAmount,
    )) {
      return;
    }

    final units = _amount ~/ unitAmount;
    if (units <= 0) {
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      await ref
          .read(submitFundLotteryApplyUseCaseProvider)
          .call(projectId: project.id, units: units, amount: _amount);
      if (!mounted) {
        return;
      }
      _goNextStep();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showToast(_resolveApplyErrorMessage(context, error));
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  List<FundLotteryDocumentItem> _buildRequiredDocuments(BuildContext context) {
    final l10n = context.l10n;
    return <FundLotteryDocumentItem>[
      FundLotteryDocumentItem(
        title: l10n.lotteryApplyDocumentPreContractTitle,
        subtitle: l10n.lotteryApplyDocumentPreContractSubtitle,
      ),
      FundLotteryDocumentItem(
        title: l10n.lotteryApplyDocumentAgreementTitle,
        subtitle: l10n.lotteryApplyDocumentAgreementSubtitle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final detailAsync = ref.watch(fundProjectDetailProvider(widget.projectId));

    return detailAsync.when(
      loading: () => _FlowLoadingScaffold(title: l10n.lotteryApplyFlowTitle),
      error: (Object _, StackTrace __) => _FlowErrorScaffold(
        title: l10n.lotteryApplyFlowTitle,
        body: l10n.fundListLoadError,
        retryLabel: l10n.fundListRetry,
        onRetry: () =>
            ref.invalidate(fundProjectDetailProvider(widget.projectId)),
      ),
      data: (FundProject project) {
        final applicationNumber = _buildApplicationNumber();
        final projectName = project.projectName.trim().isEmpty
            ? l10n.fundDetailUnknownValue
            : project.projectName.trim();
        final yieldValue = _formatYieldPercent(_resolveYield(project));
        final lotteryDate = _resolveLotteryDate(context, project);
        final unitAmount = _resolveUnitAmount(project);
        final maximumAmount = _resolveMaximumAmount(project, unitAmount);
        final quickAmounts = _buildQuickAmounts(
          unitAmount: unitAmount,
          maximumAmount: maximumAmount,
        );
        final canProceedStep1 = _canProceedStep1(
          unitAmount: unitAmount,
          maximumAmount: maximumAmount,
        );
        final exceededMaximum = _amount > maximumAmount;
        final estimatedDistribution = (_amount * _resolveYield(project) / 100)
            .round();
        final formatter = _currencyFormatter(context);
        final amountText = formatter.format(_amount);
        final deadline = DateTime.now().add(const Duration(days: 8));
        final deadlineAt = DateTime(
          deadline.year,
          deadline.month,
          deadline.day,
          23,
          59,
        );
        final requiredDocuments = _buildRequiredDocuments(context);

        return PopScope<void>(
          canPop: _currentStep.isFirst,
          onPopInvokedWithResult: (bool didPop, void _) {
            if (!didPop && !_currentStep.isFirst) {
              _goPreviousOrPop();
            }
          },
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: AppNavigationBar(
              title: l10n.lotteryApplyFlowTitle,
              backgroundColor: colors.surface,
              foregroundColor: colors.textPrimary,
              leading: SizedBox.square(
                dimension: 32,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _goPreviousOrPop,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 20,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                AppStepProgressBar(
                  stepCount: FundLotteryApplyStep.values.length,
                  currentStep: _currentStep.index,
                  pendingColor: colors.border,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: KeyedSubtree(
                      key: ValueKey<FundLotteryApplyStep>(_currentStep),
                      child: switch (_currentStep) {
                        FundLotteryApplyStep.amountInput =>
                          FundLotteryApplyAmountStep(
                            title: l10n.lotteryApplyStep1Title,
                            balanceLabel: l10n.lotteryApplyStep1BalanceLabel,
                            balanceValue: _formatCurrency(
                              context,
                              _mockStandbyBalance,
                            ),
                            depositActionLabel:
                                l10n.lotteryApplyStep1DepositAction,
                            investmentAmountLabel: _buildAmountLabel(
                              context,
                              unitAmount: unitAmount,
                              maximumAmount: maximumAmount,
                            ),
                            amountController: _amountController,
                            quickAmounts: quickAmounts,
                            selectedAmount: _amount,
                            onQuickAmountTap: _selectQuickAmount,
                            onDepositTap: () =>
                                _showToast(l10n.myPageDepositComingSoon),
                            showBalanceWarning:
                                _amount > 0 &&
                                (exceededMaximum || !_isBalanceEnough),
                            balanceWarningTitle: exceededMaximum
                                ? l10n.lotteryApplyStep1MaximumWarningTitle
                                : l10n.lotteryApplyStep1BalanceWarningTitle,
                            balanceWarningBody: exceededMaximum
                                ? l10n.lotteryApplyStep1MaximumWarningBody
                                : l10n.lotteryApplyStep1BalanceWarningBody,
                            balanceWarningActionLabel: exceededMaximum
                                ? null
                                : l10n.lotteryApplyStep1BalanceWarningAction,
                            onBalanceWarningActionTap: exceededMaximum
                                ? null
                                : () =>
                                      _showToast(l10n.myPageDepositComingSoon),
                            estimatedDistributionLabel: l10n
                                .lotteryApplyStep1EstimatedDistributionLabel,
                            estimatedDistributionAmount: formatter.format(
                              estimatedDistribution,
                            ),
                            estimatedDistributionSuffix: l10n
                                .lotteryApplyStep1EstimatedDistributionSuffix,
                            nextButtonLabel: l10n.lotteryApplyStep1NextAction,
                            onNext: canProceedStep1 ? _goNextStep : null,
                          ),
                        FundLotteryApplyStep.contractDocuments =>
                          FundLotteryApplyDocumentsStep(
                            title: l10n.lotteryApplyStep2Title,
                            description: l10n.lotteryApplyStep2Description,
                            documents: requiredDocuments,
                            checkedIndexes: _checkedDocuments,
                            onToggleDocument: (int index) {
                              setState(() {
                                if (_checkedDocuments.contains(index)) {
                                  _checkedDocuments.remove(index);
                                } else {
                                  _checkedDocuments.add(index);
                                }
                              });
                            },
                            infoBody: l10n.lotteryApplyStep2InfoBody,
                            nextButtonLabel: l10n.lotteryApplyStep2NextAction,
                            onNext: _canProceedStep2(requiredDocuments.length)
                                ? _goNextStep
                                : null,
                          ),
                        FundLotteryApplyStep.confirmApplication =>
                          FundLotteryApplyConfirmStep(
                            title: l10n.lotteryApplyStep3Title,
                            rows: <FundLotterySummaryRow>[
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyFundNameLabel,
                                value: projectName,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyInvestmentAmountLabel,
                                value: amountText,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.fundDetailEstimatedYieldAnnualLabel,
                                value:
                                    '${l10n.lotteryApplyAnnualYieldPrefix} $yieldValue',
                              ),
                              FundLotterySummaryRow(
                                label: l10n.fundListMethodLabel,
                                value: l10n.homeTagLottery,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.fundDetailLotteryDateLabel,
                                value: lotteryDate,
                              ),
                            ],
                            noticeTitle: l10n.lotteryApplyNoticeTitle,
                            noticeBody: l10n.lotteryApplyNoticeBody,
                            agreementLabel: l10n.lotteryApplyAgreementLabel,
                            agreed: _agreedToApply,
                            onAgreementChanged: (bool value) {
                              setState(() {
                                _agreedToApply = value;
                              });
                            },
                            highlightValue: l10n.homeTagLottery,
                            applyButtonLabel: l10n.lotteryApplySubmitAction,
                            isSubmitting: _isApplying,
                            onApply: _agreedToApply && !_isApplying
                                ? () => _submitLotteryApply(
                                    project: project,
                                    unitAmount: unitAmount,
                                    maximumAmount: maximumAmount,
                                  )
                                : null,
                          ),
                        FundLotteryApplyStep.submitted =>
                          FundLotteryApplySubmittedStep(
                            headline: l10n.lotteryApplyStep4Headline,
                            body: l10n.lotteryApplyStep4Body(projectName),
                            announcementLabel:
                                l10n.lotteryApplyResultAnnouncementDateLabel,
                            announcementValue: lotteryDate,
                            rows: <FundLotterySummaryRow>[
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyApplicationNumberLabel,
                                value: applicationNumber,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyInvestmentAmountLabel,
                                value: amountText,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.fundListMethodLabel,
                                value: l10n.homeTagLottery,
                              ),
                            ],
                            hintBody: l10n.lotteryApplyStep4HintBody,
                            backHomeLabel: l10n.lotteryApplyBackHomeAction,
                            onBackHome: _goHome,
                            demoResultLabel:
                                l10n.lotteryApplyDemoCheckResultAction,
                            onDemoCheckResult:
                                widget.allowSubmittedResultAdvance
                                ? _goNextStep
                                : null,
                          ),
                        FundLotteryApplyStep.selected =>
                          FundLotteryApplySelectedStep(
                            headline: l10n.lotteryApplyStep5Headline,
                            body: l10n.lotteryApplyStep5Body(projectName),
                            deadlineLabel: l10n.lotteryApplyDeadlineLabel,
                            deadlineValue: _formatDateTime(context, deadlineAt),
                            coolingOffTitle: l10n.lotteryApplyCoolingOffTitle,
                            coolingOffBody: l10n.lotteryApplyCoolingOffBody,
                            depositRows: <FundLotteryDepositRow>[
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyDepositAmountLabel,
                                value: amountText,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankNameLabel,
                                value: l10n.lotteryApplyMockBankName,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankBranchLabel,
                                value: l10n.lotteryApplyMockBankBranch,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankAccountLabel,
                                value: l10n.lotteryApplyMockBankAccount,
                                copyable: true,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankHolderLabel,
                                value: l10n.lotteryApplyMockBankHolder,
                              ),
                            ],
                            reportDepositButtonLabel:
                                l10n.lotteryApplyReportDepositAction,
                            onReportDeposit: _goNextStep,
                            laterButtonLabel:
                                l10n.lotteryApplyLaterDepositAction,
                            onLaterDeposit: _goHome,
                            copyButtonLabel: l10n.lotteryApplyCopyAction,
                            onCopyValue: (String value) {
                              Clipboard.setData(ClipboardData(text: value));
                              _showToast(l10n.lotteryApplyCopyDoneToast);
                            },
                          ),
                        FundLotteryApplyStep.depositCompleted =>
                          FundLotteryApplyCompletedStep(
                            headline: l10n.lotteryApplyStep6Headline,
                            body: l10n.lotteryApplyStep6Body,
                            receiptLabel: l10n.lotteryApplyReceiptLabel,
                            receiptValue: applicationNumber,
                            backHomeLabel: l10n.lotteryApplyBackHomeAction,
                            onBackHome: _goHome,
                          ),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FlowLoadingScaffold extends StatelessWidget {
  const _FlowLoadingScaffold({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: title,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
      ),
      body: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _FlowErrorScaffold extends StatelessWidget {
  const _FlowErrorScaffold({
    required this.title,
    required this.body,
    required this.retryLabel,
    required this.onRetry,
  });

  final String title;
  final String body;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: title,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                body,
                textAlign: TextAlign.center,
                style: appText.bodyMuted.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onRetry, child: Text(retryLabel)),
            ],
          ),
        ),
      ),
    );
  }
}
