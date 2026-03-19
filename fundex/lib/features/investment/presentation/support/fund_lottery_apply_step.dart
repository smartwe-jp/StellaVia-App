enum FundLotteryApplyStep {
  amountInput,
  contractDocuments,
  confirmApplication,
  submitted,
  selected,
  depositCompleted,
}

extension FundLotteryApplyStepX on FundLotteryApplyStep {
  String get queryValue {
    switch (this) {
      case FundLotteryApplyStep.amountInput:
        return 'amount-input';
      case FundLotteryApplyStep.contractDocuments:
        return 'contract-documents';
      case FundLotteryApplyStep.confirmApplication:
        return 'confirm-application';
      case FundLotteryApplyStep.submitted:
        return 'submitted';
      case FundLotteryApplyStep.selected:
        return 'selected';
      case FundLotteryApplyStep.depositCompleted:
        return 'deposit-completed';
    }
  }

  int get index => FundLotteryApplyStep.values.indexOf(this);

  bool get isFirst => this == FundLotteryApplyStep.amountInput;

  FundLotteryApplyStep? get next {
    final current = index;
    if (current >= FundLotteryApplyStep.values.length - 1) {
      return null;
    }
    return FundLotteryApplyStep.values[current + 1];
  }

  FundLotteryApplyStep? get previous {
    final current = index;
    if (current == 0) {
      return null;
    }
    return FundLotteryApplyStep.values[current - 1];
  }
}

FundLotteryApplyStep? fundLotteryApplyStepFromQueryValue(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  final normalized = value.trim();
  for (final step in FundLotteryApplyStep.values) {
    if (step.queryValue == normalized) {
      return step;
    }
  }
  return null;
}
