import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../investment/presentation/widgets/secondary_market_buy_flow_sections.dart';
import '../../domain/entities/member_profile_details.dart';
import '../providers/member_profile_providers.dart';
import '../support/member_profile_edit_step.dart';
import '../support/member_profile_edit_step_presenter.dart';

class MemberProfileOverviewPage extends ConsumerStatefulWidget {
  const MemberProfileOverviewPage({super.key});

  @override
  ConsumerState<MemberProfileOverviewPage> createState() =>
      _MemberProfileOverviewPageState();
}

class _MemberProfileOverviewPageState
    extends ConsumerState<MemberProfileOverviewPage> {
  bool _isSyncingRemote = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile(silent: true);
    });
  }

  Future<void> _refreshProfile({bool silent = false}) async {
    if (_isSyncingRemote) {
      return;
    }
    setState(() {
      _isSyncingRemote = true;
    });
    try {
      await ref.read(syncMemberProfileFromRemoteUseCaseProvider).call();
      ref.invalidate(memberProfileDetailsProvider);
      ref.invalidate(isMemberProfileCompletedProvider);
    } catch (_) {
      if (mounted && !silent) {
        AppNotice.show(context, message: context.l10n.uiErrorRequestFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncingRemote = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final detailsAsync = ref.watch(memberProfileDetailsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuItemEditProfile,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          SecondaryMarketTradePinnedTitleBar(
            title: l10n.memberProfileOverviewTitle,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                detailsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => _MemberProfileOverviewError(
                    onRetry: () => _refreshProfile(),
                  ),
                  data: (MemberProfileDetails? details) {
                    final profile = details ?? const MemberProfileDetails();
                    final (String addressPrefecture, String addressCity) =
                        _splitAddressFields(profile.address);
                    return RefreshIndicator(
                      onRefresh: _refreshProfile,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        children: <Widget>[
                          _MemberProfileOverviewSection(
                            icon: Icons.badge_outlined,
                            title: memberProfileEditStepTitle(
                              l10n,
                              MemberProfileEditStep.basicInfo,
                              plain: true,
                            ),
                            onEdit: () =>
                                _openSection(MemberProfileEditStep.basicInfo),
                            children: <Widget>[
                              _OverviewFieldRow(
                                label: l10n.memberProfileFamilyNameLabel,
                                value: _displayValue(profile.familyName, l10n),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileGivenNameLabel,
                                value: _displayValue(profile.givenName, l10n),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileFamilyNameKanaLabel,
                                value: _displayValue(
                                  profile.familyNameKana,
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileGivenNameKanaLabel,
                                value: _displayValue(
                                  profile.givenNameKana,
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileFamilyNameRomanLabel,
                                value: _displayValue(
                                  profile.familyNameEn,
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileGivenNameRomanLabel,
                                value: _displayValue(profile.givenNameEn, l10n),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileBirthdayLabel,
                                value: _displayValue(
                                  profile.birthday ?? '',
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileSexLabel,
                                value: _displayValue(
                                  _sexLabel(l10n, profile.sex),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileTaxCountryLabel,
                                value: _displayValue(profile.taxcountry, l10n),
                              ),
                              _OverviewFieldRow(
                                label: l10n.profileEmailLabel,
                                value: _displayValue(profile.email, l10n),
                                isLast: true,
                              ),
                            ],
                          ),
                          _MemberProfileOverviewSection(
                            icon: Icons.location_on_outlined,
                            title: memberProfileEditStepTitle(
                              l10n,
                              MemberProfileEditStep.addressInfo,
                              plain: true,
                            ),
                            onEdit: () =>
                                _openSection(MemberProfileEditStep.addressInfo),
                            children: <Widget>[
                              _OverviewFieldRow(
                                label: l10n.memberProfilePostalCodeLabel,
                                value: _displayValue(profile.zipCode, l10n),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfilePrefectureLabel,
                                value: _displayValue(
                                  _prefectureLabel(
                                    l10n,
                                    addressPrefecture.trim().isNotEmpty
                                        ? addressPrefecture
                                        : profile.prefectureCode,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileCityAddressLabel,
                                value: _displayValue(
                                  addressCity.trim().isNotEmpty
                                      ? addressCity
                                      : (profile.cityAddress.trim().isNotEmpty
                                            ? profile.cityAddress
                                            : profile.address),
                                  l10n,
                                ),
                                isLast: true,
                              ),
                            ],
                          ),
                          _MemberProfileOverviewSection(
                            icon: Icons.insights_outlined,
                            title: memberProfileEditStepTitle(
                              l10n,
                              MemberProfileEditStep.suitability,
                              plain: true,
                            ),
                            onEdit: () =>
                                _openSection(MemberProfileEditStep.suitability),
                            children: <Widget>[
                              _OverviewFieldRow(
                                label: l10n.memberProfileOccupationLabel,
                                value: _displayValue(
                                  _occupationLabel(
                                    l10n,
                                    profile.occupationCode,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileAnnualIncomeLabel,
                                value: _displayValue(
                                  _incomeLabel(l10n, profile.annualIncomeCode),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileFinancialAssetsLabel,
                                value: _displayValue(
                                  _financialAssetLabel(
                                    l10n,
                                    profile.financialAssetsCode,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label:
                                    l10n.memberProfileInvestmentExperienceLabel,
                                value: _displayValue(
                                  _experienceSummary(
                                    l10n,
                                    profile.investmentExperienceCodes,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileInvestmentPurposeLabel,
                                value: _displayValue(
                                  _purposeLabel(
                                    l10n,
                                    profile.investmentPurposeCode,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileFundSourceLabel,
                                value: _displayValue(
                                  _fundSourceLabel(
                                    l10n,
                                    profile.fundSourceCode,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfileRiskToleranceLabel,
                                value: _displayValue(
                                  _riskLabel(l10n, profile.riskToleranceCode),
                                  l10n,
                                ),
                                isLast: true,
                              ),
                            ],
                          ),
                          _MemberProfileOverviewSection(
                            icon: Icons.verified_user_outlined,
                            title: memberProfileEditStepTitle(
                              l10n,
                              MemberProfileEditStep.ekyc,
                              plain: true,
                            ),
                            onEdit: () =>
                                _openSection(MemberProfileEditStep.ekyc),
                            children: <Widget>[
                              _OverviewFieldRow(
                                label: l10n.memberProfileDocumentTypeLabel,
                                value: _displayValue(
                                  _documentTypeLabel(
                                    l10n,
                                    profile.ekycDocumentType,
                                  ),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label:
                                    l10n.memberProfilePhotoDocumentFrontTitle,
                                value: _statusValue(
                                  (profile.idDocumentPhotoPath
                                          ?.trim()
                                          .isNotEmpty ??
                                      false),
                                  l10n,
                                ),
                              ),
                              _OverviewFieldRow(
                                label: l10n.memberProfilePhotoDocumentBackTitle,
                                value: _statusValue(
                                  (profile.idDocumentBackPhotoPath
                                          ?.trim()
                                          .isNotEmpty ??
                                      false),
                                  l10n,
                                ),
                                isLast: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (_isSyncingRemote)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openSection(MemberProfileEditStep step) {
    context.push('/member-profile/edit/section/${step.routeValue}');
  }
}

class _MemberProfileOverviewSection extends StatelessWidget {
  const _MemberProfileOverviewSection({
    required this.icon,
    required this.title,
    required this.onEdit,
    required this.children,
  });

  final IconData icon;
  final String title;
  final VoidCallback onEdit;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.primarySubtle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(icon, size: 18, color: colors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: appText.sectionTitle.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colors.primary,
                ),
                onPressed: onEdit,
                child: Text(context.l10n.commonEditText),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, thickness: 1, color: colors.borderSoft),
          const SizedBox(height: 6),
          ...children,
        ],
      ),
    );
  }
}

class _OverviewFieldRow extends StatelessWidget {
  const _OverviewFieldRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: colors.borderSoft),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 118,
            child: Text(
              label,
              style: appText.meta.copyWith(
                color: colors.textTertiary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: appText.body.copyWith(
                color: colors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberProfileOverviewError extends StatelessWidget {
  const _MemberProfileOverviewError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error_outline_rounded, size: 28, color: colors.warning),
            const SizedBox(height: 12),
            Text(
              context.l10n.uiErrorRequestFailed,
              style: appText.bodyStrong.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(context.l10n.fundListRetry),
            ),
          ],
        ),
      ),
    );
  }
}

String _displayValue(String raw, AppLocalizations l10n) {
  final value = raw.trim();
  return value.isEmpty ? l10n.fundDetailUnknownValue : value;
}

String _statusValue(bool value, AppLocalizations l10n) {
  return value ? '✓' : l10n.fundDetailUnknownValue;
}

String _sexLabel(AppLocalizations l10n, int? sex) {
  return switch (sex) {
    0 => l10n.memberProfileSexFemale,
    1 => l10n.memberProfileSexMale,
    _ => '',
  };
}

String _prefectureLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'tokyo' => l10n.prefectureTokyo,
    'osaka' => l10n.prefectureOsaka,
    'kanagawa' => l10n.prefectureKanagawa,
    'aichi' => l10n.prefectureAichi,
    'fukuoka' => l10n.prefectureFukuoka,
    _ => raw.trim(),
  };
}

(String, String) _splitAddressFields(String rawAddress) {
  final normalized = rawAddress.trim();
  if (normalized.isEmpty) {
    return ('', '');
  }

  final parts = normalized
      .split(RegExp(r'\s+'))
      .where((String part) => part.trim().isNotEmpty)
      .toList(growable: false);
  if (parts.length >= 2) {
    return (parts.first.trim(), parts.skip(1).join(' ').trim());
  }

  final match = RegExp(r'^(東京都|北海道|(?:京都|大阪)府|.+?県)').firstMatch(normalized);
  if (match == null) {
    return ('', normalized);
  }

  final prefecture = match.group(0)?.trim() ?? '';
  final cityAddress = normalized.substring(prefecture.length).trim();
  return (prefecture, cityAddress);
}

String _occupationLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'employee' => l10n.occupationEmployee,
    'self_employed' => l10n.occupationSelfEmployed,
    'public_servant' => l10n.occupationPublicServant,
    'homemaker' => l10n.occupationHomemaker,
    'student' => l10n.occupationStudent,
    'pensioner' => l10n.occupationPensioner,
    'other' => l10n.commonOther,
    _ => raw.trim(),
  };
}

String _incomeLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'lt_3m' => l10n.incomeUnder3m,
    '3_5m' => l10n.income3to5m,
    '5_10m' => l10n.income5to10m,
    'gt_10m' => l10n.incomeOver10m,
    _ => raw.trim(),
  };
}

String _financialAssetLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'lt_1m' => l10n.assetsUnder1m,
    '1_5m' => l10n.assets1to5m,
    '5_10m' => l10n.assets5to10m,
    'gt_10m' => l10n.assetsOver10m,
    _ => raw.trim(),
  };
}

String _purposeLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'growth' => l10n.purposeAssetGrowth,
    'income' => l10n.purposeDividendIncome,
    'idle_cash' => l10n.purposeIdleFunds,
    'diversification' => l10n.purposeDiversification,
    _ => raw.trim(),
  };
}

String _fundSourceLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'ok' => l10n.fundSourceSurplus,
    'warn' => l10n.fundSourceLivingFunds,
    'ng' => l10n.fundSourceBorrowed,
    _ => raw.trim(),
  };
}

String _riskLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'accept_loss' => l10n.riskToleranceAcceptLoss,
    'low_risk' => l10n.riskToleranceLowRisk,
    'high_risk' => l10n.riskToleranceHighRisk,
    _ => raw.trim(),
  };
}

String _documentTypeLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'drivers_license' => l10n.documentTypeDriversLicense,
    'my_number' => l10n.documentTypeMyNumber,
    'residence_card' => l10n.documentTypeResidenceCard,
    'passport' => l10n.documentTypePassport,
    'other' => l10n.documentTypeOther,
    _ => raw.trim(),
  };
}

String _experienceSummary(AppLocalizations l10n, List<String> values) {
  final labels = values
      .map((String code) => _experienceLabel(l10n, code))
      .where((String value) => value.isNotEmpty)
      .toList(growable: false);
  if (labels.isEmpty) {
    return '';
  }
  return labels.join(' / ');
}

String _experienceLabel(AppLocalizations l10n, String raw) {
  return switch (raw.trim()) {
    'stocks' => l10n.memberProfileExperienceStocks,
    'mutual_funds' => l10n.memberProfileExperienceMutualFunds,
    'real_estate' => l10n.memberProfileExperienceRealEstate,
    'real_estate_crowdfunding' =>
      l10n.memberProfileExperienceRealEstateCrowdfunding,
    'bonds' => l10n.memberProfileExperienceBonds,
    'fx_crypto' => l10n.memberProfileExperienceFxCrypto,
    'none' => l10n.memberProfileExperienceNone,
    _ => raw.trim(),
  };
}
