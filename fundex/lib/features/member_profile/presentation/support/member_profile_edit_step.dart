enum MemberProfileEditStep {
  basicInfo,
  addressInfo,
  suitability,
  ekyc,
  realPersonAuth,
  bankAccount,
  consent,
}

extension MemberProfileEditStepX on MemberProfileEditStep {
  int get index {
    return MemberProfileEditStep.values.indexOf(this);
  }

  bool get isFirst => this == MemberProfileEditStep.basicInfo;
  bool get isLast => this == MemberProfileEditStep.consent;

  MemberProfileEditStep? get next {
    final current = index;
    if (current >= MemberProfileEditStep.values.length - 1) {
      return null;
    }
    return MemberProfileEditStep.values[current + 1];
  }

  MemberProfileEditStep? get previous {
    final current = index;
    if (current == 0) {
      return null;
    }
    return MemberProfileEditStep.values[current - 1];
  }
}
