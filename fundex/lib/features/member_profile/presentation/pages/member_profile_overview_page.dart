import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
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
      ref.invalidate(currentAuthUserProvider);
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
    final authUser = ref.watch(currentAuthUserProvider).asData?.value;
    final basicProfile = ref.watch(memberBasicProfileProvider);
    final detailsAsync = ref.watch(memberProfileDetailsProvider);
    final currentDetails = detailsAsync.asData?.value;
    final headerPresentation = _resolveMemberProfileOverviewPresentation(
      l10n,
      status: authUser?.status,
      email: _firstFilledString(<String?>[
        basicProfile?.email,
        currentDetails?.email,
      ]),
    );

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
          _MemberProfileOverviewPinnedTitleBar(
            title: l10n.memberProfileOverviewTitle,
            presentation: headerPresentation,
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
                    final resolvedEmail = _firstFilledString(<String?>[
                      basicProfile?.email,
                      profile.email,
                    ]);
                    final presentation =
                        _resolveMemberProfileOverviewPresentation(
                          l10n,
                          status: authUser?.status,
                          email: resolvedEmail,
                        );
                    final (String addressPrefecture, String addressCity) =
                        _splitAddressFields(profile.address);
                    final resolvedFamilyName = _firstFilledString(<String?>[
                      basicProfile?.familyName,
                      profile.familyName,
                    ]);
                    final resolvedGivenName = _firstFilledString(<String?>[
                      basicProfile?.givenName,
                      profile.givenName,
                    ]);
                    final resolvedFamilyNameKana = _firstFilledString(<String?>[
                      basicProfile?.familyNameKana,
                      profile.familyNameKana,
                    ]);
                    final resolvedGivenNameKana = _firstFilledString(<String?>[
                      basicProfile?.givenNameKana,
                      profile.givenNameKana,
                    ]);
                    final resolvedFamilyNameEn = _firstFilledString(<String?>[
                      basicProfile?.familyNameEn,
                      profile.familyNameEn,
                    ]);
                    final resolvedGivenNameEn = _firstFilledString(<String?>[
                      basicProfile?.givenNameEn,
                      profile.givenNameEn,
                    ]);
                    final resolvedSex = profile.sex ?? basicProfile?.sex;
                    final canEditSections = presentation.allowsEditing;
                    return RefreshIndicator(
                      onRefresh: _refreshProfile,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        children: <Widget>[
                          if (!presentation.showProfileContent)
                            _MemberProfileOverviewBlockedState(
                              title: presentation.emptyTitle ?? '',
                              message: presentation.emptyMessage ?? '',
                              actionLabel:
                                  presentation.primaryActionLabel ?? '',
                              tone: presentation.tone,
                              onAction: () =>
                                  context.push('/member-profile/onboarding'),
                            )
                          else ...<Widget>[
                            _MemberProfileOverviewSection(
                              icon: Icons.badge_outlined,
                              title: memberProfileEditStepTitle(
                                l10n,
                                MemberProfileEditStep.basicInfo,
                                plain: true,
                              ),
                              onEdit: canEditSections
                                  ? () => _openSection(
                                      MemberProfileEditStep.basicInfo,
                                    )
                                  : null,
                              children: <Widget>[
                                _OverviewFieldRow(
                                  label: l10n.memberProfileFamilyNameLabel,
                                  value: _displayValue(
                                    resolvedFamilyName,
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileGivenNameLabel,
                                  value: _displayValue(resolvedGivenName, l10n),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileFamilyNameKanaLabel,
                                  value: _displayValue(
                                    resolvedFamilyNameKana,
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileGivenNameKanaLabel,
                                  value: _displayValue(
                                    resolvedGivenNameKana,
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileFamilyNameRomanLabel,
                                  value: _displayValue(
                                    resolvedFamilyNameEn,
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileGivenNameRomanLabel,
                                  value: _displayValue(
                                    resolvedGivenNameEn,
                                    l10n,
                                  ),
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
                                    _sexLabel(l10n, resolvedSex),
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.memberProfileTaxCountryLabel,
                                  value: _displayValue(
                                    profile.taxcountry,
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label: l10n.profileEmailLabel,
                                  value: resolvedEmail.trim().isEmpty
                                      ? l10n.settingsEmailUnavailable
                                      : resolvedEmail,
                                  actionLabel:
                                      presentation.showEmailBindingAction
                                      ? l10n.settingsEmailVerifyAction
                                      : null,
                                  onActionTap:
                                      presentation.showEmailBindingAction
                                      ? () => context.push(
                                          '/profile/settings/two-factor/email',
                                        )
                                      : null,
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
                              onEdit: canEditSections
                                  ? () => _openSection(
                                      MemberProfileEditStep.addressInfo,
                                    )
                                  : null,
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
                              onEdit: canEditSections
                                  ? () => _openSection(
                                      MemberProfileEditStep.suitability,
                                    )
                                  : null,
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
                                    _incomeLabel(
                                      l10n,
                                      profile.annualIncomeCode,
                                    ),
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
                                  label: l10n
                                      .memberProfileInvestmentExperienceLabel,
                                  value: _displayValue(
                                    _experienceSummary(
                                      l10n,
                                      profile.investmentExperienceCodes,
                                    ),
                                    l10n,
                                  ),
                                ),
                                _OverviewFieldRow(
                                  label:
                                      l10n.memberProfileInvestmentPurposeLabel,
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
                              onEdit: canEditSections
                                  ? () =>
                                        _openSection(MemberProfileEditStep.ekyc)
                                  : null,
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
                                  label:
                                      l10n.memberProfilePhotoDocumentBackTitle,
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

  Future<void> _openSection(MemberProfileEditStep step) async {
    if (step == MemberProfileEditStep.ekyc) {
      await refreshRemoteVerificationStatus(ref);
      final faceVerified = await ref
          .read(settingsRealPersonVerifiedProvider.future)
          .catchError((Object _) => false);
      if (!mounted) {
        return;
      }

      if (!faceVerified) {
        final l10n = context.l10n;
        final shouldStartVerification =
            await AppDialogs.showAdaptiveAlert<bool>(
              context: context,
              title: l10n.memberProfileEditRequiresFaceVerificationTitle,
              message: l10n.memberProfileEditRequiresFaceVerificationMessage,
              actions: <AppDialogAction<bool>>[
                AppDialogAction<bool>(label: l10n.commonCancel, value: false),
                AppDialogAction<bool>(
                  label: l10n.identityAuthStartAction,
                  value: true,
                  isDefaultAction: true,
                ),
              ],
            ) ??
            false;
        if (!mounted) {
          return;
        }
        if (shouldStartVerification) {
          context.push('/profile/settings/two-factor/face');
        }
        return;
      }

      final authorized = await ensureSensitiveActionAuthorized(context, ref);
      if (!mounted || !authorized) {
        return;
      }

      context.push(
        '/member-profile/edit/section/${step.routeValue}',
        extra: true,
      );
      return;
    }

    context.push('/member-profile/edit/section/${step.routeValue}');
  }
}

class _MemberProfileOverviewSection extends StatelessWidget {
  const _MemberProfileOverviewSection({
    required this.icon,
    required this.title,
    required this.children,
    this.onEdit,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onEdit;
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
              if (onEdit != null)
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
    this.actionLabel,
    this.onActionTap,
  });

  final String label;
  final String value;
  final bool isLast;
  final String? actionLabel;
  final VoidCallback? onActionTap;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  value,
                  style: appText.body.copyWith(
                    color: colors.textPrimary,
                    height: 1.6,
                  ),
                ),
                if ((actionLabel?.trim().isNotEmpty ?? false) &&
                    onActionTap != null) ...<Widget>[
                  const SizedBox(height: 8),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colors.primary,
                    ),
                    onPressed: onActionTap,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberProfileOverviewPinnedTitleBar extends StatelessWidget {
  const _MemberProfileOverviewPinnedTitleBar({
    required this.title,
    required this.presentation,
  });

  final String title;
  final _MemberProfileOverviewPresentation presentation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final badgeColors = _statusBadgeColors(colors, presentation.tone);

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.borderSoft)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: appText.pageTitle.copyWith(
                    color: colors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
              if (presentation.statusLabel.trim().isNotEmpty) ...<Widget>[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColors.$1,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    presentation.statusLabel,
                    style: appText.chip.copyWith(color: badgeColors.$2),
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

class _MemberProfileOverviewBlockedState extends StatelessWidget {
  const _MemberProfileOverviewBlockedState({
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.tone,
    required this.onAction,
  });

  final String title;
  final String message;
  final String actionLabel;
  final _MemberProfileOverviewStatusTone tone;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final palette = _statusBadgeColors(colors, tone);
    final icon = switch (tone) {
      _MemberProfileOverviewStatusTone.danger => Icons.error_outline_rounded,
      _MemberProfileOverviewStatusTone.warning => Icons.pending_actions_rounded,
      _MemberProfileOverviewStatusTone.success => Icons.verified_rounded,
      _MemberProfileOverviewStatusTone.neutral => Icons.info_outline_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: palette.$1,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: palette.$2, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: appText.sectionTitle.copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: appText.body.copyWith(
              color: colors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
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

enum _MemberProfileOverviewStatusTone { neutral, warning, danger, success }

class _MemberProfileOverviewPresentation {
  const _MemberProfileOverviewPresentation({
    required this.statusLabel,
    required this.tone,
    required this.showProfileContent,
    required this.allowsEditing,
    required this.showEmailBindingAction,
    this.emptyTitle,
    this.emptyMessage,
    this.primaryActionLabel,
  });

  final String statusLabel;
  final _MemberProfileOverviewStatusTone tone;
  final bool showProfileContent;
  final bool allowsEditing;
  final bool showEmailBindingAction;
  final String? emptyTitle;
  final String? emptyMessage;
  final String? primaryActionLabel;
}

_MemberProfileOverviewPresentation _resolveMemberProfileOverviewPresentation(
  AppLocalizations l10n, {
  required int? status,
  required String email,
}) {
  final hasEmail = email.trim().isNotEmpty;
  switch (status) {
    case 2:
    case 5:
      return _MemberProfileOverviewPresentation(
        statusLabel: l10n.memberProfileOverviewStatusPending,
        tone: _MemberProfileOverviewStatusTone.warning,
        showProfileContent: true,
        allowsEditing: false,
        showEmailBindingAction: false,
      );
    case 3:
      return _MemberProfileOverviewPresentation(
        statusLabel: l10n.memberProfileOverviewStatusFailed,
        tone: _MemberProfileOverviewStatusTone.danger,
        showProfileContent: false,
        allowsEditing: false,
        showEmailBindingAction: false,
        emptyTitle: l10n.memberProfileOverviewFailedTitle,
        emptyMessage: l10n.memberProfileOverviewFailedMessage,
        primaryActionLabel: l10n.memberProfileOverviewStartIntakeAction,
      );
    case 4:
      return _MemberProfileOverviewPresentation(
        statusLabel: l10n.memberProfileOverviewStatusVerified,
        tone: _MemberProfileOverviewStatusTone.success,
        showProfileContent: true,
        allowsEditing: true,
        showEmailBindingAction: false,
      );
    case 1:
      return _MemberProfileOverviewPresentation(
        statusLabel: l10n.memberProfileOverviewStatusUnverified,
        tone: _MemberProfileOverviewStatusTone.warning,
        showProfileContent: false,
        allowsEditing: false,
        showEmailBindingAction: false,
        emptyTitle: l10n.memberProfileOverviewUnverifiedTitle,
        emptyMessage: l10n.memberProfileOverviewUnverifiedMessage,
        primaryActionLabel: l10n.memberProfileOverviewStartIntakeAction,
      );
    case 0:
      return _MemberProfileOverviewPresentation(
        statusLabel: hasEmail
            ? l10n.memberProfileOverviewStatusIncomplete
            : l10n.memberProfileOverviewStatusEmailUnbound,
        tone: _MemberProfileOverviewStatusTone.warning,
        showProfileContent: true,
        allowsEditing: true,
        showEmailBindingAction: !hasEmail,
      );
    default:
      return const _MemberProfileOverviewPresentation(
        statusLabel: '',
        tone: _MemberProfileOverviewStatusTone.neutral,
        showProfileContent: true,
        allowsEditing: true,
        showEmailBindingAction: false,
      );
  }
}

(Color, Color) _statusBadgeColors(
  AppSemanticColorTheme colors,
  _MemberProfileOverviewStatusTone tone,
) {
  return switch (tone) {
    _MemberProfileOverviewStatusTone.success => (
      colors.primarySubtle,
      colors.primary,
    ),
    _MemberProfileOverviewStatusTone.danger => (
      colors.dangerSubtle,
      colors.danger,
    ),
    _MemberProfileOverviewStatusTone.warning => (
      colors.warningSubtle,
      colors.warning,
    ),
    _MemberProfileOverviewStatusTone.neutral => (
      colors.surfaceAlt,
      colors.textSecondary,
    ),
  };
}

String _displayValue(String raw, AppLocalizations l10n) {
  final value = raw.trim();
  return value.isEmpty ? l10n.fundDetailUnknownValue : value;
}

String _firstFilledString(List<String?> values) {
  for (final value in values) {
    final normalized = value?.trim() ?? '';
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return '';
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
