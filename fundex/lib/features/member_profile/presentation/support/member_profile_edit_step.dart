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

  bool get appearsInOverview => memberProfileOverviewSteps.contains(this);

  String get routeValue => switch (this) {
    MemberProfileEditStep.basicInfo => 'basic-info',
    MemberProfileEditStep.addressInfo => 'address-info',
    MemberProfileEditStep.suitability => 'suitability',
    MemberProfileEditStep.ekyc => 'ekyc',
    MemberProfileEditStep.realPersonAuth => 'real-person-auth',
    MemberProfileEditStep.bankAccount => 'bank-account',
    MemberProfileEditStep.consent => 'consent',
  };
}

const List<MemberProfileEditStep> memberProfileOverviewSteps =
    <MemberProfileEditStep>[
      MemberProfileEditStep.basicInfo,
      MemberProfileEditStep.addressInfo,
      MemberProfileEditStep.suitability,
      MemberProfileEditStep.ekyc,
      MemberProfileEditStep.consent,
    ];

MemberProfileEditStep? memberProfileEditStepFromRouteValue(String? raw) {
  return switch (raw?.trim()) {
    'basic-info' => MemberProfileEditStep.basicInfo,
    'address-info' => MemberProfileEditStep.addressInfo,
    'suitability' => MemberProfileEditStep.suitability,
    'ekyc' => MemberProfileEditStep.ekyc,
    'real-person-auth' => MemberProfileEditStep.consent,
    'bank-account' => MemberProfileEditStep.bankAccount,
    'consent' => MemberProfileEditStep.consent,
    _ => null,
  };
}
