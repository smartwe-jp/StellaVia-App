import 'dart:async';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
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
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../../wallet/presentation/support/wallet_application_payment_refresh.dart';
import '../../../wallet/presentation/support/wallet_deposit_transfer_notice_support.dart';
import '../../../wallet/presentation/support/wallet_standby_purchase_dialog.dart';

class FundLotteryApplyFlowPage extends ConsumerStatefulWidget {
  const FundLotteryApplyFlowPage({
    super.key,
    required this.projectId,
    this.initialStep = FundLotteryApplyStep.amountInput,
    this.allowSubmittedResultAdvance = true,
    this.initialSeed,
  });

  final String projectId;
  final FundLotteryApplyStep initialStep;
  final bool allowSubmittedResultAdvance;
  final FundLotteryApplyFlowSeed? initialSeed;

  @override
  ConsumerState<FundLotteryApplyFlowPage> createState() =>
      _FundLotteryApplyFlowPageState();
}

class _FundLotteryApplyFlowPageState
    extends ConsumerState<FundLotteryApplyFlowPage> {
  static const String _identityVerificationBypassSourceMessage =
      'あなたの身分証明書がないか、期限切れになっているため、正常に操作できません。身分証明書の情報を更新してください。';
  static const String _identityVerificationBypassNotice =
      'テスト環境のため、このまま次へ進みます。';
  static const int _minimumUnits = 1;
  static const int _defaultUnitAmount = 100000;
  static const int _defaultMaxMultiplier = 10;
  static const int _mockStandbyBalance = 650000;

  late final TextEditingController _unitsController;

  late FundLotteryApplyStep _currentStep;
  int _selectedUnits = _minimumUnits;
  int _currentMaximumUnits = _defaultMaxMultiplier;
  bool _isSyncingUnitsController = false;
  bool _didCheckApplyAccess = false;
  final Set<int> _checkedDocuments = <int>{};
  final Set<int> _openedDocuments = <int>{};
  bool _agreedToApply = false;
  bool _isApplying = false;
  bool _isReportingDeposit = false;
  bool _isPurchasingWithStandbyBalance = false;
  bool _hasReportedDepositCompleted = false;
  bool _blocksBackOnSubmittedStep = false;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    _selectedUnits = _resolveInitialUnits();
    _unitsController = TextEditingController(text: _selectedUnits.toString());
    _unitsController.addListener(_handleUnitsChanged);
    if (_requiresVerifiedApplicationAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_ensureVerifiedApplicationAccess());
      });
    }
  }

  int _resolveInitialUnits() {
    final units = widget.initialSeed?.units;
    if (units == null || units < _minimumUnits) {
      return _minimumUnits;
    }
    return units;
  }

  @override
  void dispose() {
    _unitsController
      ..removeListener(_handleUnitsChanged)
      ..dispose();
    super.dispose();
  }

  void _handleUnitsChanged() {
    if (_isSyncingUnitsController) {
      return;
    }
    final digits = _unitsController.text.runes
        .where((int rune) => rune >= 48 && rune <= 57)
        .map(String.fromCharCode)
        .join();
    final parsed = int.tryParse(digits) ?? _minimumUnits;
    if (digits.isEmpty || parsed < _minimumUnits) {
      _showToast(
        context.l10n.lotteryApplyStep1MinimumUnitsNotice(
          _minimumUnits.toString(),
        ),
      );
      _setSelectedUnits(_minimumUnits);
      return;
    }
    if (parsed > _currentMaximumUnits) {
      _showToast(
        context.l10n.lotteryApplyStep1MaximumUnitsNotice(
          _currentMaximumUnits.toString(),
        ),
      );
      _setSelectedUnits(_currentMaximumUnits);
      return;
    }
    if (_selectedUnits == parsed || !mounted) {
      return;
    }
    setState(() {
      _selectedUnits = parsed;
    });
  }

  void _setSelectedUnits(int units) {
    final normalized = units < _minimumUnits ? _minimumUnits : units;
    final text = normalized.toString();
    _isSyncingUnitsController = true;
    _unitsController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _isSyncingUnitsController = false;
    if (!mounted || _selectedUnits == normalized) {
      return;
    }
    setState(() {
      _selectedUnits = normalized;
    });
  }

  void _incrementUnits() {
    if (_selectedUnits >= _currentMaximumUnits) {
      _showToast(
        context.l10n.lotteryApplyStep1MaximumUnitsNotice(
          _currentMaximumUnits.toString(),
        ),
      );
      return;
    }
    _setSelectedUnits(_selectedUnits + 1);
  }

  void _decrementUnits() {
    if (_selectedUnits <= _minimumUnits) {
      _showToast(
        context.l10n.lotteryApplyStep1MinimumUnitsNotice(
          _minimumUnits.toString(),
        ),
      );
      return;
    }
    _setSelectedUnits(_selectedUnits - 1);
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

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      _goHome();
    }
  }

  void _goToMyPageApplyingList() {
    context.go(
      '/profile/my/section-list?type=${MyPageSectionType.pendingApplications.queryValue}&filter=${MyPageApplyHistoryFilter.applying.queryValue}',
    );
  }

  void _showToast(String message) {
    if (!mounted) {
      return;
    }
    AppNotice.show(context, message: message);
  }

  bool get _requiresVerifiedApplicationAccess =>
      widget.initialStep.index < FundLotteryApplyStep.submitted.index;

  bool get _shouldLockSubmittedBackNavigation =>
      _currentStep == FundLotteryApplyStep.submitted &&
      _blocksBackOnSubmittedStep;

  Future<void> _showFundApplyVerificationRequiredDialog() {
    final l10n = context.l10n;
    return AppDialogs.showAdaptiveAlert<void>(
      context: context,
      title: l10n.fundApplyVerificationRequiredTitle,
      message: l10n.fundApplyVerificationRequiredMessage,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
      ],
    );
  }

  Future<void> _ensureVerifiedApplicationAccess() async {
    if (_didCheckApplyAccess || !_requiresVerifiedApplicationAccess) {
      return;
    }
    _didCheckApplyAccess = true;
    final isAuthenticated = ref.read(isAuthenticatedProvider).asData?.value;
    if (isAuthenticated != true) {
      if (!mounted) {
        return;
      }
      context.go('/login');
      return;
    }

    var isFundApplyVerified = false;
    try {
      await refreshMemberProfileVerificationState(ref);
      isFundApplyVerified = await ref.read(isFundApplyVerifiedProvider.future);
    } catch (_) {
      isFundApplyVerified = false;
    }
    if (!mounted || isFundApplyVerified) {
      return;
    }

    await _showFundApplyVerificationRequiredDialog();
    if (!mounted) {
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go('/funds/${widget.projectId}');
  }

  bool _canProceedStep2(int requiredCount) =>
      _checkedDocuments.length == requiredCount;

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

  String _formatBankValue(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return '--';
    }
    return trimmed;
  }

  String _formatBankAccountValue(FundProjectLiveJapanBank? bank) {
    final accountType = bank?.bankAccountType?.trim();
    final bankNumber = bank?.bankNumber?.trim();
    final parts = <String>[
      if (accountType != null && accountType.isNotEmpty) accountType,
      if (bankNumber != null && bankNumber.isNotEmpty) bankNumber,
    ];
    if (parts.isEmpty) {
      return '--';
    }
    return parts.join(' ');
  }

  int _resolveTotalAmount(int calculatedTotalAmount) {
    final seedAmount = widget.initialSeed?.amount;
    if (widget.initialStep.index >= FundLotteryApplyStep.submitted.index &&
        seedAmount != null &&
        seedAmount > 0) {
      return seedAmount;
    }
    return calculatedTotalAmount;
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

  int _resolveUnitAmount(
    FundProject project,
    FundProjectApplyDetail applyDetail,
  ) {
    final unit =
        applyDetail.investmentUnit ??
        project.investmentUnit ??
        _defaultUnitAmount;
    if (unit <= 0) {
      return _defaultUnitAmount;
    }
    return unit;
  }

  int _resolveMaximumUnits(FundProjectApplyDetail applyDetail) {
    final units = _resolveOpenApplyInvestor(applyDetail)?.availableApplyTotal;
    if (units == null || units < 0) {
      return 0;
    }
    return units;
  }

  FundProjectApplyInvestor? _resolveOpenApplyInvestor(
    FundProjectApplyDetail applyDetail,
  ) {
    for (final investor in applyDetail.investorList) {
      if (investor.isOpen == true) {
        return investor;
      }
    }
    return null;
  }

  bool _isAmountInAllowedRange({
    required int units,
    required int unitAmount,
    required int maximumAmount,
  }) {
    final totalAmount = units * unitAmount;
    return units > 0 && totalAmount > 0 && totalAmount <= maximumAmount;
  }

  bool _canProceedStep1({
    required int units,
    required int unitAmount,
    required int maximumAmount,
  }) {
    return _isAmountInAllowedRange(
      units: units,
      unitAmount: unitAmount,
      maximumAmount: maximumAmount,
    );
  }

  String _buildAmountLabel(
    BuildContext context, {
    required int unitAmount,
    required int maximumUnits,
  }) {
    return context.l10n.lotteryApplyStep1AmountLabelWithRules(
      _formatCurrency(context, unitAmount),
      '${maximumUnits.toString()}${context.l10n.lotteryApplyStep1UnitSuffix}',
    );
  }

  String _resolveApplyErrorMessage(BuildContext context, Object error) {
    return _resolveRequestErrorMessage(
      context,
      error,
      fallbackMessage: context.l10n.lotteryApplySubmitFailedFallback,
    );
  }

  String _resolveRequestErrorMessage(
    BuildContext context,
    Object error, {
    required String fallbackMessage,
  }) {
    final message = _extractApplyErrorMessage(error);
    if (message != null) {
      return message;
    }
    return fallbackMessage;
  }

  String? _extractApplyErrorMessage(Object error) {
    if (error is! StateError) {
      return null;
    }
    final message = error.message.toString().trim();
    if (message.isEmpty) {
      return null;
    }
    return message;
  }

  bool _shouldBypassIdentityVerificationError(Object error) {
    final message = _extractApplyErrorMessage(error);
    if (message == null) {
      return false;
    }
    return message.contains(_identityVerificationBypassSourceMessage);
  }

  Future<void> _submitLotteryApply({
    required FundProject project,
    required int units,
    required int unitAmount,
    required int maximumAmount,
  }) async {
    if (_isApplying) {
      return;
    }

    if (!_isAmountInAllowedRange(
      units: units,
      unitAmount: unitAmount,
      maximumAmount: maximumAmount,
    )) {
      return;
    }

    final totalAmount = units * unitAmount;
    if (units <= 0) {
      return;
    }

    setState(() {
      _isApplying = true;
    });

    try {
      await ref
          .read(submitFundLotteryApplyUseCaseProvider)
          .call(projectId: project.id, units: units, amount: totalAmount);
      if (!mounted) {
        return;
      }
      _blocksBackOnSubmittedStep = true;
      _goNextStep();
    } catch (error) {
      if (!mounted) {
        return;
      }
      if (_shouldBypassIdentityVerificationError(error)) {
        _showToast(_identityVerificationBypassNotice);
        _blocksBackOnSubmittedStep = true;
        _goNextStep();
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

  Future<void> _reportDepositCompleted({required int amount}) async {
    if (_isReportingDeposit || _isPurchasingWithStandbyBalance) {
      return;
    }

    setState(() {
      _isReportingDeposit = true;
    });

    try {
      await ref.read(confirmWalletPaymentUseCaseProvider).call(amount: amount);
      if (!mounted) {
        return;
      }
      setState(() {
        _hasReportedDepositCompleted = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showToast(
        _resolveRequestErrorMessage(
          context,
          error,
          fallbackMessage: context.l10n.lotteryApplyReportDepositFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isReportingDeposit = false;
        });
      }
    }
  }

  Future<void> _purchaseWithStandbyBalance({
    required int amount,
    required String amountText,
    required String projectName,
  }) async {
    if (amount <= 0 || _isPurchasingWithStandbyBalance || _isReportingDeposit) {
      return;
    }
    final processId = widget.initialSeed?.processId?.trim();
    if (processId == null || processId.isEmpty) {
      _showToast(context.l10n.lotteryApplyStandbyPurchaseMissingProcess);
      return;
    }
    final confirmed = await showWalletStandbyPurchaseConfirmDialog(
      context,
      projectName: projectName,
      amountText: amountText,
    );
    if (!mounted || !confirmed) {
      return;
    }
    final failureMessage = context.l10n.lotteryApplyStandbyPurchaseFailure;

    setState(() {
      _isPurchasingWithStandbyBalance = true;
    });

    try {
      final succeeded = await ref
          .read(autoFundDeductionUseCaseProvider)
          .call(processId: processId);
      if (!succeeded) {
        throw StateError(failureMessage);
      }
      await refreshWalletApplicationPaymentState(
        ref,
        projectId: widget.projectId,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _hasReportedDepositCompleted = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showToast(
        _resolveRequestErrorMessage(
          context,
          error,
          fallbackMessage: context.l10n.lotteryApplyStandbyPurchaseFailure,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPurchasingWithStandbyBalance = false;
        });
      }
    }
  }

  List<FundLotteryDocumentGroup> _buildRequiredDocuments(
    BuildContext context,
    FundProject project,
  ) {
    var selectionIndex = 0;
    return project.pdfDocuments
        .map((FundProjectPdfDocument document) {
          final groupTitle = _documentGroupTitle(context, document);
          final items = _availablePdfUrls(document)
              .asMap()
              .entries
              .map((MapEntry<int, FundProjectPdfUrl> entry) {
                final currentSelectionIndex = selectionIndex++;
                final itemTitle = _documentLinkTitle(
                  context,
                  entry.value,
                  entry.key,
                );
                final item = FundLotteryDocumentItem(
                  selectionIndex: currentSelectionIndex,
                  title: itemTitle,
                  subtitle:
                      _formatDocumentCreatedAt(context, entry.value) ??
                      context.l10n.fundDetailDocumentReady,
                  onOpen: () {
                    if (mounted) {
                      setState(() {
                        _openedDocuments.add(currentSelectionIndex);
                      });
                    }
                    _openPdfDocument(
                      context,
                      groupTitle: groupTitle,
                      linkTitle: itemTitle,
                      item: entry.value,
                    );
                  },
                );
                return item;
              })
              .toList(growable: false);
          return FundLotteryDocumentGroup(title: groupTitle, items: items);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final detailAsync = ref.watch(fundProjectDetailProvider(widget.projectId));
    final applyDetailAsync = ref.watch(
      fundProjectApplyDetailProvider(widget.projectId),
    );
    final accountStatisticAsync = ref.watch(myPageAccountStatisticProvider);

    return detailAsync.when(
      loading: () => _FlowLoadingScaffold(title: l10n.lotteryApplyFlowTitle),
      error: (Object _, StackTrace __) => _FlowErrorScaffold(
        title: l10n.lotteryApplyFlowTitle,
        body: l10n.fundListLoadError,
        retryLabel: l10n.fundListRetry,
        onRetry: () {
          ref.invalidate(fundProjectDetailProvider(widget.projectId));
          ref.invalidate(fundProjectApplyDetailProvider(widget.projectId));
        },
      ),
      data: (FundProject project) {
        if (applyDetailAsync.isLoading) {
          return _FlowLoadingScaffold(title: l10n.lotteryApplyFlowTitle);
        }
        if (applyDetailAsync.hasError || !applyDetailAsync.hasValue) {
          return _FlowErrorScaffold(
            title: l10n.lotteryApplyFlowTitle,
            body: l10n.fundListLoadError,
            retryLabel: l10n.fundListRetry,
            onRetry: () {
              ref.invalidate(fundProjectDetailProvider(widget.projectId));
              ref.invalidate(fundProjectApplyDetailProvider(widget.projectId));
            },
          );
        }
        final applyDetail = applyDetailAsync.requireValue;
        final projectName = project.projectName.trim().isEmpty
            ? l10n.fundDetailUnknownValue
            : project.projectName.trim();
        final lotteryDate = _resolveLotteryDate(context, project);
        final unitAmount = _resolveUnitAmount(project, applyDetail);
        final resolvedMaximumUnits = _resolveMaximumUnits(applyDetail);
        final maximumAmount = resolvedMaximumUnits * unitAmount;
        _currentMaximumUnits = resolvedMaximumUnits;
        final calculatedTotalAmount = _selectedUnits * unitAmount;
        final totalAmount = _resolveTotalAmount(calculatedTotalAmount);
        final canProceedStep1 = _canProceedStep1(
          units: _selectedUnits,
          unitAmount: unitAmount,
          maximumAmount: maximumAmount,
        );
        final exceededMaximum = calculatedTotalAmount > maximumAmount;
        final estimatedDistribution =
            (totalAmount * _resolveYield(project) / 100).round();
        final formatter = _currencyFormatter(context);
        final amountText = formatter.format(totalAmount);
        final standbyBalance =
            accountStatisticAsync.asData?.value?.firstLevelAccountTotal ?? 0;
        final standbyShortage = totalAmount > standbyBalance
            ? totalAmount - standbyBalance
            : 0;
        final canPurchaseWithStandbyBalance =
            totalAmount > 0 && standbyBalance >= totalAmount;
        final deadline = DateTime.now().add(const Duration(days: 8));
        final deadlineAt = DateTime(
          deadline.year,
          deadline.month,
          deadline.day,
          23,
          59,
        );
        final requiredDocuments = _buildRequiredDocuments(context, project);
        final requiredDocumentCount = requiredDocuments.fold<int>(
          0,
          (int total, FundLotteryDocumentGroup group) =>
              total + group.items.length,
        );
        final liveJapanBank = project.liveJapanBank;
        final transferNoticeAccountId =
            formatWalletDepositTransferNoticeAccountId(
              ref.watch(currentAuthUserProvider).valueOrNull,
            );

        return PopScope<void>(
          canPop: _currentStep.isFirst,
          onPopInvokedWithResult: (bool didPop, void _) {
            if (!didPop &&
                !_currentStep.isFirst &&
                !_shouldLockSubmittedBackNavigation) {
              _goPreviousOrPop();
            }
          },
          child: Scaffold(
            backgroundColor: colors.surface,
            appBar: AppNavigationBar(
              title: l10n.lotteryApplyFlowTitle,
              backgroundColor: colors.surface,
              foregroundColor: colors.textPrimary,
              leading: _shouldLockSubmittedBackNavigation
                  ? null
                  : SizedBox.square(
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
                              maximumUnits: resolvedMaximumUnits,
                            ),
                            unitPriceLabel:
                                l10n.lotteryApplyStep1UnitPriceLabel,
                            unitPriceValue: _formatCurrency(
                              context,
                              unitAmount,
                            ),
                            unitCountLabel:
                                l10n.lotteryApplyStep1UnitCountLabel,
                            unitCountController: _unitsController,
                            onDecreaseUnits: _decrementUnits,
                            onIncreaseUnits: _incrementUnits,
                            unitSuffix: l10n.lotteryApplyStep1UnitSuffix,
                            totalAmountLabel:
                                l10n.lotteryApplyStep1TotalAmountLabel,
                            totalAmountValue: amountText,
                            onDepositTap: () =>
                                _showToast(l10n.myPageDepositComingSoon),
                            showBalanceWarning:
                                totalAmount > 0 && exceededMaximum,
                            balanceWarningTitle:
                                l10n.lotteryApplyStep1MaximumWarningTitle,
                            balanceWarningBody:
                                l10n.lotteryApplyStep1MaximumWarningBody,
                            balanceWarningActionLabel: null,
                            onBalanceWarningActionTap: null,
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
                            documentGroups: requiredDocuments,
                            checkedIndexes: _checkedDocuments,
                            openedIndexes: _openedDocuments,
                            onToggleDocument: (int index) {
                              if (!_openedDocuments.contains(index)) {
                                _showToast(
                                  l10n.lotteryApplyStep2OpenDocumentFirstNotice,
                                );
                                return;
                              }
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
                            onNext: _canProceedStep2(requiredDocumentCount)
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
                              // FundLotterySummaryRow(
                              //   label: l10n.fundDetailEstimatedYieldAnnualLabel,
                              //   value:
                              //       '${l10n.lotteryApplyAnnualYieldPrefix} $yieldValue',
                              // ),
                              FundLotterySummaryRow(
                                label: l10n.fundListMethodLabel,
                                value: l10n.homeTagLottery,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyStep1UnitCountLabel,
                                value:
                                    '${_selectedUnits.toString()}${l10n.lotteryApplyStep1UnitSuffix}',
                              ),
                              // FundLotterySummaryRow(
                              //   label: l10n.fundDetailLotteryDateLabel,
                              //   value: lotteryDate,
                              // ),
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
                                    units: _selectedUnits,
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
                                label: l10n.lotteryApplyFundNameLabel,
                                value: projectName,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyInvestmentAmountLabel,
                                value: amountText,
                              ),
                              FundLotterySummaryRow(
                                label: l10n.lotteryApplyStep1UnitCountLabel,
                                value:
                                    '${_selectedUnits.toString()}${l10n.lotteryApplyStep1UnitSuffix}',
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
                                ? _goToMyPageApplyingList
                                : _back,
                          ),
                        FundLotteryApplyStep.selected =>
                          FundLotteryApplySelectedStep(
                            headline: _hasReportedDepositCompleted
                                ? l10n.lotteryApplyDepositReportConfirmedTitle
                                : l10n.lotteryApplyStep5Headline,
                            body: _hasReportedDepositCompleted
                                ? l10n.lotteryApplyDepositReportConfirmedBody
                                : l10n.lotteryApplyStep5Body(projectName),
                            deadlineLabel: l10n.lotteryApplyDeadlineLabel,
                            deadlineValue: _formatDateTime(context, deadlineAt),
                            coolingOffTitle: l10n.lotteryApplyCoolingOffTitle,
                            coolingOffBody: l10n.lotteryApplyCoolingOffBody,
                            bankTips: l10n.walletDepositTransferNotice(
                              transferNoticeAccountId,
                            ),
                            bankTipsTransferName: transferNoticeAccountId,
                            transferNameCopyButtonLabel:
                                l10n.walletDepositTransferNameCopyAction,
                            depositRows: <FundLotteryDepositRow>[
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyDepositAmountLabel,
                                value: amountText,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankNameLabel,
                                value: _formatBankValue(
                                  liveJapanBank?.bankName,
                                ),
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankBranchLabel,
                                value: _formatBankValue(
                                  liveJapanBank?.branchBankName,
                                ),
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankAccountLabel,
                                value: _formatBankAccountValue(liveJapanBank),
                                copyable: true,
                              ),
                              FundLotteryDepositRow(
                                label: l10n.lotteryApplyBankHolderLabel,
                                value: _formatBankValue(
                                  liveJapanBank?.bankAccountOwnerName,
                                ),
                              ),
                            ],
                            jumpDepositButtonLabel:
                                l10n.lotteryApplyStep1DepositAction,
                            standbyBalanceLabel:
                                l10n.lotteryApplyStandbyBalanceLabel,
                            standbyBalanceValue: formatter.format(
                              standbyBalance,
                            ),
                            standbyPurchaseButtonLabel:
                                l10n.lotteryApplyStandbyPurchaseAction,
                            standbyShortageLabel:
                                l10n.lotteryApplyStandbyShortageLabel,
                            standbyShortageValue: standbyShortage > 0
                                ? formatter.format(standbyShortage)
                                : null,
                            canPurchaseWithStandbyBalance:
                                canPurchaseWithStandbyBalance &&
                                !_isReportingDeposit,
                            isPurchasingWithStandbyBalance:
                                _isPurchasingWithStandbyBalance,
                            onPurchaseWithStandbyBalance: () =>
                                _purchaseWithStandbyBalance(
                                  amount: totalAmount,
                                  amountText: amountText,
                                  projectName: projectName,
                                ),
                            reportDepositButtonLabel:
                                l10n.lotteryApplyReportDepositAction,
                            isReportingDeposit: _isReportingDeposit,
                            isReportCompleted: _hasReportedDepositCompleted,
                            onReportDeposit: () =>
                                _reportDepositCompleted(amount: totalAmount),
                            onJumpDeposit: () =>
                                context.push('/wallet/deposit'),
                            laterButtonLabel:
                                l10n.lotteryApplyLaterDepositAction,
                            onLaterDeposit: _goHome,
                            reportCompletedBackButtonLabel:
                                l10n.lotteryApplyDepositReportBackAction,
                            onReportCompletedBack: _back,
                            copyButtonLabel: l10n.lotteryApplyCopyAction,
                            accountInfoCopyButtonLabel:
                                l10n.lotteryApplyCopyAccountInfoAction,
                            copyDoneMessage: l10n.lotteryApplyCopyDoneToast,
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
                            receiptValue: projectName,
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

List<FundProjectPdfUrl> _availablePdfUrls(FundProjectPdfDocument document) {
  final list = <FundProjectPdfUrl>[];
  for (final item in document.urls) {
    final url = item.url?.trim();
    if (url != null && url.isNotEmpty) {
      list.add(item);
    }
  }
  return List<FundProjectPdfUrl>.unmodifiable(list);
}

String _documentGroupTitle(
  BuildContext context,
  FundProjectPdfDocument document,
) {
  final title = document.description?.trim();
  if (title != null && title.isNotEmpty) {
    return title;
  }
  return context.l10n.fundDetailDocumentsTitle;
}

String _documentLinkTitle(
  BuildContext context,
  FundProjectPdfUrl item,
  int index,
) {
  final name = item.name?.trim();
  if (name != null && name.isNotEmpty) {
    return name;
  }
  return context.l10n.fundDetailDocumentPickerItem(index + 1);
}

String? _formatDocumentCreatedAt(BuildContext context, FundProjectPdfUrl item) {
  final raw = item.createTime?.trim();
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    return raw;
  }
  final formatter = DateFormat.yMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).add_Hm();
  return formatter.format(parsed.toLocal());
}

void _openPdfDocument(
  BuildContext context, {
  required String groupTitle,
  required String linkTitle,
  required FundProjectPdfUrl item,
}) {
  final selectedUrl = item.url?.trim();
  if (selectedUrl == null || selectedUrl.isEmpty) {
    return;
  }
  final l10n = context.l10n;
  final viewerTexts = AppPdfViewerTexts(
    pageTitle: l10n.pdfViewerPageTitle,
    openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
    openExternalLabel: l10n.pdfViewerOpenExternalLabel,
    loadingLabel: l10n.pdfViewerLoadingLabel,
    loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
    retryLabel: l10n.fundListRetry,
    invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
    openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
  );
  openAppPdfViewer(
    context,
    url: selectedUrl,
    title: linkTitle.isNotEmpty ? linkTitle : groupTitle,
    texts: viewerTexts,
  );
}
