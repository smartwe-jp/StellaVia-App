import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_identity_auth/core_identity_auth.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_permission_dialogs.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/identity_auth_sdk_providers.dart';
import '../../../auth/presentation/support/identity_auth_guard.dart';
import '../../../auth/presentation/support/identity_auth_message_resolver.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
import '../../domain/constants/member_profile_upload_markers.dart';
import '../../domain/entities/member_profile_details.dart';
import '../../domain/entities/member_profile_region.dart';
import '../pages/edit_flow_steps/member_profile_address_info_step_page.dart';
import '../pages/edit_flow_steps/member_profile_bank_account_step_page.dart';
import '../pages/edit_flow_steps/member_profile_basic_info_step_page.dart';
import '../pages/edit_flow_steps/member_profile_consent_step_page.dart';
import '../pages/edit_flow_steps/member_profile_ekyc_step_page.dart';
import '../pages/edit_flow_steps/member_profile_real_person_auth_step_page.dart';
import '../pages/edit_flow_steps/member_profile_suitability_step_page.dart';
import '../providers/member_profile_providers.dart';
import '../support/member_profile_edit_step.dart';
import '../support/member_profile_edit_step_presenter.dart';
import '../support/member_profile_option_item.dart';
import '../support/profile_document_image_picker.dart';

enum _MemberProfileEditFlowMode { flow, section }

enum _ProfilePhotoTarget { documentFront, documentBack, selfie }

class MemberProfileEditFlowPage extends ConsumerStatefulWidget {
  const MemberProfileEditFlowPage({super.key})
    : _mode = _MemberProfileEditFlowMode.flow,
      initialStep = null,
      skipInitialAccessGuard = false;

  const MemberProfileEditFlowPage.section({
    super.key,
    required this.initialStep,
    this.skipInitialAccessGuard = false,
  }) : _mode = _MemberProfileEditFlowMode.section;

  final _MemberProfileEditFlowMode _mode;
  final MemberProfileEditStep? initialStep;
  final bool skipInitialAccessGuard;

  bool get isSingleSectionMode => _mode == _MemberProfileEditFlowMode.section;

  @override
  ConsumerState<MemberProfileEditFlowPage> createState() =>
      _MemberProfileEditFlowPageState();
}

class _MemberProfileEditFlowPageState
    extends ConsumerState<MemberProfileEditFlowPage> {
  static const _ProfilePhotoTarget _documentFrontPhotoTarget =
      _ProfilePhotoTarget.documentFront;
  static const _ProfilePhotoTarget _documentBackPhotoTarget =
      _ProfilePhotoTarget.documentBack;
  static const _ProfilePhotoTarget _selfiePhotoTarget =
      _ProfilePhotoTarget.selfie;

  late final TextEditingController _familyNameController;
  late final TextEditingController _givenNameController;
  late final TextEditingController _familyNameKanaController;
  late final TextEditingController _givenNameKanaController;
  late final TextEditingController _familyNameRomanController;
  late final TextEditingController _givenNameRomanController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _taxCountryController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _prefectureController;
  late final TextEditingController _cityAddressController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _branchNumberController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountHolderController;

  MemberProfileEditStep _currentStep = MemberProfileEditStep.basicInfo;
  DateTime? _birthday;
  int? _sex;
  String? _occupation;
  String? _annualIncome;
  String? _financialAssets;
  String? _investmentPurpose;
  String? _fundSource = 'ok';
  String? _riskTolerance;
  String? _documentType = 'drivers_license';
  String? _accountType = 'ordinary';
  String _phoneIntlCode = '81';
  String _phone = '';
  String _email = '';
  String? _documentPhotoPath;
  String? _documentBackPhotoPath;
  String? _selfiePhotoPath;
  DateTime? _completedAt;
  final Set<String> _selectedExperiences = <String>{};
  bool _electronicConsent = false;
  bool _antiSocialConsent = false;
  bool _privacyConsent = false;
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isUploadingPhoto = false;
  bool _isAddressSearching = false;
  bool _isRunningRealPersonAuth = false;
  bool _isSectionAccessChecking = false;
  String? _realPersonAuthStatusMessage;

  bool get _isIdentityAuthEnabled =>
      ref.read(identityAuthFeatureEnabledProvider);

  bool get _isRealPersonVerified =>
      ref.read(settingsRealPersonVerifiedProvider).asData?.value == true;

  bool get _isSingleSectionMode => widget.isSingleSectionMode;

  @override
  void initState() {
    super.initState();
    if (_isSingleSectionMode) {
      _currentStep = _normalizeStepForIdentityAuth(
        widget.initialStep ?? MemberProfileEditStep.basicInfo,
      );
    }
    _familyNameController = TextEditingController();
    _givenNameController = TextEditingController();
    _familyNameKanaController = TextEditingController();
    _givenNameKanaController = TextEditingController();
    _familyNameRomanController = TextEditingController();
    _givenNameRomanController = TextEditingController();
    _birthdayController = TextEditingController();
    _taxCountryController = TextEditingController();
    _postalCodeController = TextEditingController();
    _prefectureController = TextEditingController();
    _cityAddressController = TextEditingController();
    _bankNameController = TextEditingController();
    _branchNameController = TextEditingController();
    _branchNumberController = TextEditingController();
    _accountNumberController = TextEditingController();
    _accountHolderController = TextEditingController();
    _registerTextFieldListeners();
    _loadInitialData();
    if (_isSingleSectionMode &&
        widget.initialStep == MemberProfileEditStep.ekyc &&
        !widget.skipInitialAccessGuard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_guardSingleSectionAccess());
      });
    }
  }

  @override
  void dispose() {
    _unregisterTextFieldListeners();
    _familyNameController.dispose();
    _givenNameController.dispose();
    _familyNameKanaController.dispose();
    _givenNameKanaController.dispose();
    _familyNameRomanController.dispose();
    _givenNameRomanController.dispose();
    _birthdayController.dispose();
    _taxCountryController.dispose();
    _postalCodeController.dispose();
    _prefectureController.dispose();
    _cityAddressController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _branchNumberController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  void _registerTextFieldListeners() {
    for (final TextEditingController controller in _trackedTextControllers) {
      controller.addListener(_onTrackedFieldChanged);
    }
  }

  void _unregisterTextFieldListeners() {
    for (final TextEditingController controller in _trackedTextControllers) {
      controller.removeListener(_onTrackedFieldChanged);
    }
  }

  List<TextEditingController> get _trackedTextControllers =>
      <TextEditingController>[
        _familyNameController,
        _givenNameController,
        _familyNameKanaController,
        _givenNameKanaController,
        _familyNameRomanController,
        _givenNameRomanController,
        _birthdayController,
        _taxCountryController,
        _postalCodeController,
        _prefectureController,
        _cityAddressController,
        _bankNameController,
        _branchNameController,
        _branchNumberController,
        _accountNumberController,
        _accountHolderController,
      ];

  void _onTrackedFieldChanged() {
    if (!mounted || _isLoading) {
      return;
    }
    setState(() {});
  }

  void _applyUserChange(VoidCallback change) {
    if (!mounted) {
      return;
    }
    setState(change);
  }

  Future<bool> _shouldImportOnboardingDraft(
    MemberProfileDetails? onboardingDraft,
  ) async {
    if (_isSingleSectionMode || onboardingDraft == null || !mounted) {
      return false;
    }
    if (!onboardingDraft.hasAnyInput) {
      return false;
    }
    final l10n = context.l10n;
    final shouldImport = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l10n.memberProfileDraftImportTitle,
      message: l10n.memberProfileDraftImportMessage,
      actions: <AppDialogAction<bool>>[
        AppDialogAction<bool>(
          label: l10n.memberProfileDraftImportSkipAction,
          value: false,
        ),
        AppDialogAction<bool>(
          label: l10n.memberProfileDraftImportAction,
          value: true,
          isDefaultAction: true,
        ),
      ],
    );
    return shouldImport ?? false;
  }

  Future<void> _loadInitialData() async {
    try {
      if (_isSingleSectionMode) {
        await ref.read(syncMemberProfileFromRemoteUseCaseProvider).call();
      }
      final MemberProfileDetails? officialProfile = await ref
          .read(loadMemberProfileDetailsUseCaseProvider)
          .call();
      final MemberProfileDetails? onboardingDraft = _isSingleSectionMode
          ? null
          : await ref
                .read(memberProfileRepositoryProvider)
                .readOnboardingDraft();
      final AuthUser? authUser = await ref
          .read(currentAuthUserProvider.future)
          .catchError((Object _) => null);
      final bool shouldImportDraft = await _shouldImportOnboardingDraft(
        onboardingDraft,
      );
      final MemberProfileDetails? savedProfile = shouldImportDraft
          ? onboardingDraft
          : officialProfile;
      final (String savedPrefectureFromAddress, String savedCityFromAddress) =
          _splitAddressFields(savedProfile?.address ?? '');
      final (String authPrefectureFromAddress, String authCityFromAddress) =
          _splitAddressFields(authUser?.address ?? '');

      final (String legacyFamilyName, String legacyGivenName) =
          _splitJapaneseName(savedProfile?.nameKanji ?? '');
      final (String legacyFamilyNameKana, String legacyGivenNameKana) =
          _splitJapaneseName(savedProfile?.katakana ?? '');
      final (String authFamilyNameKana, String authGivenNameKana) =
          _splitJapaneseName(authUser?.katakana ?? '');
      final Map<String, dynamic>? authBank = authUser?.bank;

      if (!mounted) {
        return;
      }
      final l10n = context.l10n;

      setState(() {
        _familyNameController.text = _firstNonEmpty(<String>[
          savedProfile?.familyName ?? '',
          legacyFamilyName,
          authUser?.lastName ?? '',
        ]);
        _givenNameController.text = _firstNonEmpty(<String>[
          savedProfile?.givenName ?? '',
          legacyGivenName,
          authUser?.firstName ?? '',
        ]);
        _familyNameKanaController.text = _firstNonEmpty(<String>[
          savedProfile?.familyNameKana ?? '',
          legacyFamilyNameKana,
          authFamilyNameKana,
        ]);
        _givenNameKanaController.text = _firstNonEmpty(<String>[
          savedProfile?.givenNameKana ?? '',
          legacyGivenNameKana,
          authGivenNameKana,
        ]);
        _familyNameRomanController.text = _firstNonEmpty(<String>[
          savedProfile?.familyNameEn ?? '',
          authUser?.firstNameEn ?? '',
        ]);
        _givenNameRomanController.text = _firstNonEmpty(<String>[
          savedProfile?.givenNameEn ?? '',
          authUser?.lastNameEn ?? '',
        ]);
        _phone = savedProfile?.phone.trim().isNotEmpty == true
            ? savedProfile!.phone.trim()
            : (authUser?.phone?.trim().isNotEmpty == true
                  ? authUser!.phone!.trim()
                  : (authUser?.mobile?.trim() ?? ''));
        _postalCodeController.text = _firstNonEmpty(<String>[
          savedProfile?.zipCode ?? '',
          authUser?.zipCode ?? '',
        ]);
        _cityAddressController.text = _firstNonEmpty(<String>[
          savedCityFromAddress,
          authCityFromAddress,
          savedProfile?.cityAddress ?? '',
          savedProfile?.address ?? '',
          authUser?.address ?? '',
        ]);
        _birthday = _tryParseBirthday(
          savedProfile?.birthday ?? authUser?.birthday,
        );
        _birthdayController.text = _birthday == null
            ? ''
            : _formatDate(_birthday!);
        _sex = _normalizeSex(savedProfile?.sex ?? authUser?.sex);
        _taxCountryController.text = _firstNonEmpty(<String>[
          savedProfile?.taxcountry ?? '',
          authUser?.taxcountry ?? '',
        ]);
        _prefectureController.text = _firstNonEmpty(<String>[
          savedPrefectureFromAddress,
          authPrefectureFromAddress,
          _prefectureInputValue(l10n, savedProfile?.prefectureCode ?? ''),
        ]);
        _occupation = _emptyToNull(savedProfile?.occupationCode);
        _annualIncome = _emptyToNull(savedProfile?.annualIncomeCode);
        _financialAssets = _emptyToNull(savedProfile?.financialAssetsCode);
        _investmentPurpose = _emptyToNull(savedProfile?.investmentPurposeCode);
        _fundSource = _emptyToNull(savedProfile?.fundSourceCode) ?? 'ok';
        _riskTolerance = _emptyToNull(savedProfile?.riskToleranceCode);
        _documentType =
            _emptyToNull(savedProfile?.ekycDocumentType) ?? 'drivers_license';
        _accountType =
            _normalizeAccountType(
              _emptyToNull(savedProfile?.bankAccountType) ??
                  _emptyToNull(_readBankString(authBank, 'bankAccountType')),
            ) ??
            'ordinary';
        _phoneIntlCode = _firstNonEmpty(<String>[
          savedProfile?.phoneIntlCode ?? '',
          authUser?.intlTelCode ?? '',
          '81',
        ]);
        _email = _firstNonEmpty(<String>[
          savedProfile?.email ?? '',
          authUser?.email ?? '',
        ]);
        _documentPhotoPath = _emptyToNull(savedProfile?.idDocumentPhotoPath);
        _documentBackPhotoPath = _emptyToNull(
          savedProfile?.idDocumentBackPhotoPath,
        );
        _selfiePhotoPath = _emptyToNull(savedProfile?.selfiePhotoPath);
        _bankNameController.text = _firstNonEmpty(<String>[
          savedProfile?.bankName ?? '',
          _readBankString(authBank, 'bankName'),
        ]);
        _branchNameController.text = _firstNonEmpty(<String>[
          savedProfile?.branchBankName ?? '',
          _readBankString(authBank, 'branchBankName'),
        ]);
        _branchNumberController.text = _firstNonEmpty(<String>[
          savedProfile?.branchBankNumber ?? '',
          _readBankString(authBank, 'branchBankNumber'),
        ]);
        _accountNumberController.text = _firstNonEmpty(<String>[
          savedProfile?.bankNumber ?? '',
          _readBankString(authBank, 'bankNumber'),
        ]);
        _accountHolderController.text = _firstNonEmpty(<String>[
          savedProfile?.bankAccountOwnerName ?? '',
          _readBankString(authBank, 'bankAccountOwnerName'),
        ]);
        _selectedExperiences
          ..clear()
          ..addAll(savedProfile?.investmentExperienceCodes ?? const <String>[]);
        _electronicConsent = savedProfile?.electronicDeliveryConsent ?? false;
        _antiSocialConsent = savedProfile?.antiSocialForcesConsent ?? false;
        _privacyConsent = savedProfile?.privacyPolicyConsent ?? false;
        _completedAt = savedProfile?.completedAt;
        final savedStep = savedProfile?.lastEditingStep ?? 0;
        final resolvedStep =
            MemberProfileEditStep.values[savedStep.clamp(
              0,
              MemberProfileEditStep.values.length - 1,
            )];
        _currentStep = _isSingleSectionMode
            ? _normalizeStepForIdentityAuth(
                widget.initialStep ?? MemberProfileEditStep.basicInfo,
                realPersonVerified: _isRealPersonVerified,
              )
            : _normalizeStepForIdentityAuth(resolvedStep);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickBirthday() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _birthday = picked;
      _birthdayController.text = _formatDate(picked);
    });
  }

  Future<void> _guardSingleSectionAccess() async {
    if (!_isSingleSectionMode ||
        widget.initialStep != MemberProfileEditStep.ekyc ||
        widget.skipInitialAccessGuard) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _isSectionAccessChecking = true;
    });

    try {
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
          context.go('/profile/settings/two-factor/face');
        } else {
          context.go('/member-profile/edit');
        }
        return;
      }

      final authorized = await ensureSensitiveActionAuthorized(context, ref);
      if (!mounted) {
        return;
      }
      if (!authorized) {
        context.go('/member-profile/edit');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSectionAccessChecking = false;
        });
      }
    }
  }

  Future<void> _pickAndSaveImage({required _ProfilePhotoTarget target}) async {
    if (_isUploadingPhoto || _isSubmitting || _isRunningRealPersonAuth) {
      return;
    }
    final ProfileDocumentImageSource? source =
        await showModalBottomSheet<ProfileDocumentImageSource>(
          context: context,
          builder: (BuildContext sheetContext) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: Text(context.l10n.profileDocumentTakePhoto),
                    onTap: () {
                      Navigator.of(
                        sheetContext,
                      ).pop(ProfileDocumentImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library_outlined),
                    title: Text(context.l10n.profileDocumentPickFromGallery),
                    onTap: () {
                      Navigator.of(
                        sheetContext,
                      ).pop(ProfileDocumentImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          },
        );
    if (source == null) {
      return;
    }
    final result = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(source);
    if (!mounted) {
      return;
    }
    final String? path = await _resolvePickedImagePath(result, source);
    if (!mounted || path == null || path.trim().isEmpty) {
      return;
    }
    bool shouldAutoStartRealPersonAuth = false;
    setState(() {
      _isUploadingPhoto = true;
    });
    try {
      final uploadedUrl = await ref
          .read(uploadMemberProfilePhotoUseCaseProvider)
          .call(filePath: path.trim(), isSelfie: target == _selfiePhotoTarget);
      if (!mounted) {
        return;
      }
      setState(() {
        if (target == _documentFrontPhotoTarget) {
          _documentPhotoPath = uploadedUrl.trim();
        } else if (target == _documentBackPhotoTarget) {
          _documentBackPhotoPath = uploadedUrl.trim();
        } else {
          _selfiePhotoPath = uploadedUrl.trim();
        }
      });
      await _persistOnboardingDraft();
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: context.l10n.memberProfilePhotoUploadSuccess,
      );
      shouldAutoStartRealPersonAuth =
          target == _selfiePhotoTarget &&
          _currentStep == MemberProfileEditStep.realPersonAuth &&
          _isIdentityAuthEnabled;
    } catch (error) {
      if (!mounted) {
        return;
      }
      if (target == _selfiePhotoTarget) {
        setState(() {
          _selfiePhotoPath = selfieUploadCompletedMarker;
        });
        await _persistOnboardingDraft();
        if (!mounted) {
          return;
        }
        AppNotice.show(
          context,
          message: context.l10n.memberProfileSelfieUploadBypassedNotice,
        );
        shouldAutoStartRealPersonAuth =
            _currentStep == MemberProfileEditStep.realPersonAuth &&
            _isIdentityAuthEnabled;
      } else {
        AppNotice.show(
          context,
          message: _resolveSubmitErrorMessage(
            error,
            context.l10n.uiErrorRequestFailed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
    }

    if (shouldAutoStartRealPersonAuth && mounted) {
      await _runRealPersonAuthStep();
    }
  }

  Future<String?> _resolvePickedImagePath(
    ProfileDocumentImagePickResult result,
    ProfileDocumentImageSource source,
  ) async {
    switch (result.status) {
      case ProfileDocumentImagePickStatus.success:
        return result.path!.trim();
      case ProfileDocumentImagePickStatus.canceled:
        return null;
      case ProfileDocumentImagePickStatus.permissionDenied:
        AppNotice.show(
          context,
          message: source == ProfileDocumentImageSource.camera
              ? context.l10n.profileDocumentCameraPermissionRequired
              : context.l10n.profileDocumentPhotoLibraryPermissionRequired,
        );
        return null;
      case ProfileDocumentImagePickStatus.permissionSettingsRequired:
        await showAppPermissionSettingsDialog(
          context,
          permission: source == ProfileDocumentImageSource.camera
              ? AppPermissionKind.camera
              : AppPermissionKind.photos,
        );
        return null;
      case ProfileDocumentImagePickStatus.failed:
        AppNotice.show(
          context,
          message: context.l10n.profileDocumentPickFailed,
        );
        return null;
    }
  }

  Future<void> _searchAddressByPostalCode() async {
    if (_isAddressSearching ||
        _isSubmitting ||
        _isUploadingPhoto ||
        _isRunningRealPersonAuth) {
      return;
    }

    final l10n = context.l10n;
    final zip = _normalizePostalCode(_postalCodeController.text);
    if (zip.length != 7) {
      AppNotice.show(context, message: l10n.memberProfileAddressSearchZipError);
      return;
    }

    setState(() {
      _isAddressSearching = true;
    });

    try {
      final List<MemberProfileRegion> rows = await ref
          .read(fetchMemberProfileRegionsByZipUseCaseProvider)
          .call(zip: zip);
      if (!mounted) {
        return;
      }

      if (rows.isEmpty) {
        AppNotice.show(context, message: l10n.memberProfileAddressSearchEmpty);
        return;
      }

      if (!mounted) {
        return;
      }

      _applyResolvedAddressRows(rows);
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(error, l10n.uiErrorRequestFailed),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddressSearching = false;
        });
      }
    }
  }

  void _applyResolvedAddressRows(List<MemberProfileRegion> rows) {
    final String resolvedPrefecture = rows
        .where((MemberProfileRegion row) => row.regionType == 0)
        .map((MemberProfileRegion row) => row.displayName)
        .firstWhere((String value) => value.trim().isNotEmpty, orElse: () => '')
        .trim();

    final String resolvedCityAddress = rows
        .where(
          (MemberProfileRegion row) =>
              row.regionType == 1 || row.regionType == 2,
        )
        .map((MemberProfileRegion row) => row.displayName.trim())
        .where((String value) => value.isNotEmpty)
        .join(' ')
        .trim();

    if (resolvedPrefecture.isEmpty && resolvedCityAddress.isEmpty) {
      return;
    }

    setState(() {
      if (resolvedPrefecture.isNotEmpty) {
        _prefectureController.text = resolvedPrefecture;
      }
      if (resolvedCityAddress.isNotEmpty) {
        _cityAddressController.text = resolvedCityAddress;
      }
    });
  }

  Future<void> _goNextStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    if (!_canProceedFromCurrentStep) {
      return;
    }
    if (_isIdentityAuthEnabled &&
        _currentStep == MemberProfileEditStep.realPersonAuth) {
      final verified = await _runRealPersonAuthStep();
      if (!verified) {
        return;
      }
    }
    if (!mounted) {
      return;
    }

    await _advanceToNextStep();
  }

  Future<void> _skipRealPersonAuthStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    if (_currentStep != MemberProfileEditStep.realPersonAuth) {
      return;
    }
    await _advanceToNextStep();
  }

  Future<void> _skipBankAccountStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    if (_currentStep != MemberProfileEditStep.bankAccount) {
      return;
    }
    await _advanceToNextStep();
  }

  Future<void> _goPreviousStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    await _persistOnboardingDraft();
    if (!mounted) {
      return;
    }
    final MemberProfileEditStep? previous = _previousStep(_currentStep);
    if (previous == null) {
      context.pop();
      return;
    }
    setState(() {
      _currentStep = previous;
    });
    await _persistOnboardingDraft();
  }

  Future<void> _completeFlow() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _isSubmitting = true;
    });

    try {
      final profileToSubmit = _buildDraft(
        completedAtOverride: null,
        editingStep: _currentStep.index,
      );
      await ref.read(submitMemberProfileUseCaseProvider).call(profileToSubmit);
      _completedAt = DateTime.now().toUtc();
      await _persistOfficialProfile(markCompleted: true);
      await _refreshVerificationStateAfterProfileSubmit();
      await ref.read(memberProfileRepositoryProvider).clearOnboardingDraft();
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(error, l10n.uiErrorRequestFailed),
      );
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    if (!mounted) {
      return;
    }
    AppNotice.show(context, message: l10n.memberProfileCompletedToast);
    context.pop();
  }

  Future<void> _saveCurrentSection() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    if (!_canProceedFromCurrentStep) {
      return;
    }
    if (_isIdentityAuthEnabled &&
        _currentStep == MemberProfileEditStep.realPersonAuth) {
      final verified = await _runRealPersonAuthStep();
      if (!verified) {
        return;
      }
    }
    if (!mounted) {
      return;
    }

    final l10n = context.l10n;
    setState(() {
      _isSubmitting = true;
    });

    try {
      final draft = _buildDraft(
        completedAtOverride: _completedAt,
        editingStep: _currentStep.index,
      );
      final shouldSubmitRemotely =
          _isSingleSectionMode ||
          _completedAt != null ||
          draft.isEditFlowComplete;
      final shouldMarkCompleted =
          draft.isEditFlowComplete && _completedAt == null;
      if (shouldSubmitRemotely) {
        await ref.read(submitMemberProfileUseCaseProvider).call(draft);
        await ref.read(syncMemberProfileFromRemoteUseCaseProvider).call();
        await _refreshVerificationStateAfterProfileSubmit();
        _invalidateOfficialProfileProviders();
      } else {
        await _persistOfficialProfile(markCompleted: shouldMarkCompleted);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(error, l10n.uiErrorRequestFailed),
      );
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    if (!mounted) {
      return;
    }
    AppNotice.show(context, message: l10n.profileSavedSnackbar);
    context.pop();
  }

  bool get _showAgeWarning {
    final DateTime? birthday = _birthday;
    if (birthday == null) {
      return false;
    }
    final DateTime now = DateTime.now();
    int age = now.year - birthday.year;
    if (DateTime(now.year, birthday.month, birthday.day).isAfter(now)) {
      age -= 1;
    }
    return age < 18;
  }

  bool get _canProceedFromCurrentStep {
    switch (_currentStep) {
      case MemberProfileEditStep.basicInfo:
        return _isBasicInfoStepReady;
      case MemberProfileEditStep.addressInfo:
        return _isAddressInfoStepReady;
      case MemberProfileEditStep.suitability:
        return _isSuitabilityStepReady;
      case MemberProfileEditStep.ekyc:
        return _isEkycStepReady;
      case MemberProfileEditStep.realPersonAuth:
        return !_shouldShowRealPersonAuthStep() ||
            _isSelfieUploaded(_selfiePhotoPath);
      case MemberProfileEditStep.bankAccount:
        return _isBankAccountStepReady;
      case MemberProfileEditStep.consent:
        return _isConsentStepReady;
    }
  }

  Future<bool> _runRealPersonAuthStep() async {
    if (!_shouldShowRealPersonAuthStep()) {
      return true;
    }

    final l10n = context.l10n;
    if (!_isSelfieUploaded(_selfiePhotoPath)) {
      final message = l10n.memberProfileStep5RealPersonSelfieRequired;
      setState(() {
        _realPersonAuthStatusMessage = message;
      });
      AppNotice.show(context, message: message);
      return false;
    }

    setState(() {
      _isRunningRealPersonAuth = true;
      _realPersonAuthStatusMessage = null;
    });

    try {
      final coordinator = ref.read(identityAuthCoordinatorProvider);
      final decision = await coordinator.evaluate(
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
      );
      if (!mounted) {
        return false;
      }

      if (decision.action == IdentityAuthAction.none) {
        return true;
      }
      if (decision.action != IdentityAuthAction.startRealPersonEnrollment) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: decision.reasonCode,
          fallbackMessage: l10n.identityAuthVerifyFailed,
        );
        setState(() {
          _realPersonAuthStatusMessage = message;
        });
        AppNotice.show(context, message: message);
        return false;
      }

      final collector = ref.read(identityAuthLivenessCollectorProvider);
      if (collector == null) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: 'liveness_collector_not_configured',
          fallbackMessage: l10n.identityAuthLivenessNotConfigured,
        );
        setState(() {
          _realPersonAuthStatusMessage = message;
        });
        AppNotice.show(context, message: message);
        return false;
      }

      final collected = await collector.collect();
      if (!mounted) {
        return false;
      }
      if (!collected.isSuccess) {
        final message = resolveIdentityAuthMessage(
          l10n,
          reasonCode: 'liveness_collect_failed',
          errorMessage: collected.errorMessage,
          fallbackMessage: l10n.identityAuthCollectFailed,
        );
        setState(() {
          _realPersonAuthStatusMessage = message;
        });
        if (isIdentityAuthPermissionSettingsRequired(collected.errorMessage)) {
          await showAppPermissionSettingsDialog(
            context,
            permission: AppPermissionKind.camera,
          );
        } else {
          AppNotice.show(context, message: message);
        }
        return false;
      }

      final result = await coordinator.verifyWithPhotoBase64(
        photoBase64: collected.photoBase64,
        entryPoint: IdentityAuthEntryPoint.securityCenterRealPerson,
      );
      if (!mounted) {
        return false;
      }

      if (result.verified) {
        AppNotice.show(context, message: l10n.identityAuthVerifySuccess);
        return true;
      }

      final message = resolveIdentityAuthMessage(
        l10n,
        reasonCode: result.reasonCode,
        errorMessage: result.errorMessage,
        fallbackMessage: l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _realPersonAuthStatusMessage = message;
      });
      AppNotice.show(context, message: message);
      return false;
    } catch (error) {
      if (!mounted) {
        return false;
      }
      final message = resolveIdentityAuthMessage(
        l10n,
        errorMessage: error.toString(),
        fallbackMessage: l10n.identityAuthVerifyFailed,
      );
      setState(() {
        _realPersonAuthStatusMessage = message;
      });
      AppNotice.show(context, message: message);
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isRunningRealPersonAuth = false;
        });
      }
    }
  }

  MemberProfileEditStep _normalizeStepForIdentityAuth(
    MemberProfileEditStep step, {
    bool? realPersonVerified,
  }) {
    if (!_isSingleSectionMode &&
        !_shouldShowRealPersonAuthStep(
          realPersonVerified: realPersonVerified,
        ) &&
        step == MemberProfileEditStep.realPersonAuth) {
      return MemberProfileEditStep.bankAccount;
    }
    return step;
  }

  MemberProfileEditStep? _nextStep(MemberProfileEditStep step) {
    final MemberProfileEditStep? next = step.next;
    if (!_shouldShowRealPersonAuthStep() &&
        next == MemberProfileEditStep.realPersonAuth) {
      return MemberProfileEditStep.bankAccount;
    }
    return next;
  }

  MemberProfileEditStep? _previousStep(MemberProfileEditStep step) {
    final MemberProfileEditStep? previous = step.previous;
    if (!_shouldShowRealPersonAuthStep() &&
        previous == MemberProfileEditStep.realPersonAuth) {
      return MemberProfileEditStep.ekyc;
    }
    return previous;
  }

  bool _shouldShowRealPersonAuthStep({bool? realPersonVerified}) {
    if (!_isIdentityAuthEnabled) {
      return false;
    }
    return !(realPersonVerified ?? _isRealPersonVerified);
  }

  bool get _isBasicInfoStepReady =>
      _isFilled(_familyNameController.text) &&
      _isFilled(_givenNameController.text) &&
      _isFilled(_familyNameKanaController.text) &&
      _isFilled(_givenNameKanaController.text) &&
      _isFilled(_familyNameRomanController.text) &&
      _isFilled(_givenNameRomanController.text) &&
      _sex != null &&
      _isFilled(_taxCountryController.text) &&
      _isFilled(_birthdayController.text);

  bool get _isAddressInfoStepReady =>
      _isFilled(_postalCodeController.text) &&
      _isFilled(_prefectureController.text) &&
      _isFilled(_cityAddressController.text);

  bool get _isSuitabilityStepReady =>
      _isFilled(_occupation) &&
      _isFilled(_annualIncome) &&
      _isFilled(_financialAssets) &&
      _selectedExperiences.isNotEmpty &&
      _isFilled(_investmentPurpose) &&
      _isFilled(_fundSource) &&
      _isFilled(_riskTolerance);

  bool get _isEkycStepReady =>
      _isFilled(_documentType) &&
      _isRemoteImageUrl(_documentPhotoPath) &&
      _isRemoteImageUrl(_documentBackPhotoPath);

  bool get _isBankAccountStepReady =>
      _isFilled(_bankNameController.text) &&
      _isFilled(_branchNameController.text) &&
      _isFilled(_branchNumberController.text) &&
      _isFilled(_accountType) &&
      _isFilled(_accountNumberController.text) &&
      _isFilled(_accountHolderController.text);

  bool get _isConsentStepReady =>
      _electronicConsent && _antiSocialConsent && _privacyConsent;

  Future<void> _advanceToNextStep() async {
    final l10n = context.l10n;
    setState(() {
      _isSubmitting = true;
    });

    try {
      final MemberProfileEditStep? next = _nextStep(_currentStep);
      if (next == null) {
        return;
      }
      setState(() {
        _currentStep = next;
      });
      await _persistOnboardingDraft();
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(error, l10n.uiErrorRequestFailed),
      );
      return;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _invalidateOfficialProfileProviders() {
    ref.invalidate(memberProfileDetailsProvider);
    ref.invalidate(isMemberProfileCompletedProvider);
  }

  Future<void> _refreshVerificationStateAfterProfileSubmit() async {
    try {
      final remoteUser = await ref
          .read(authRemoteDataSourceProvider)
          .fetchCurrentUser();
      if (remoteUser != null) {
        await ref.read(authLocalDataSourceProvider).saveCurrentUser(remoteUser);
      }
    } catch (_) {
      // Keep successful profile submission from being blocked by follow-up sync.
    }

    ref.invalidate(currentAuthUserProvider);
    ref.invalidate(settingsRemoteVerificationStatusProvider);
    ref.invalidate(settingsEmailVerifiedProvider);
    ref.invalidate(settingsVerifiedEmailProvider);
    ref.invalidate(settingsEmailVerificationUpdatedAtProvider);
    ref.invalidate(settingsPhoneVerifiedProvider);
    ref.invalidate(settingsVerifiedPhoneNumberProvider);
    ref.invalidate(settingsPhoneVerificationUpdatedAtProvider);
    ref.invalidate(settingsRealPersonVerifiedProvider);
    ref.invalidate(settingsRealPersonVerificationUpdatedAtProvider);

    try {
      await ref.refresh(currentAuthUserProvider.future).catchError((Object _) {
        return null;
      });
      await ref
          .refresh(settingsRemoteVerificationStatusProvider.future)
          .catchError((Object _) {
            return null;
          });
    } catch (_) {
      // Best effort refresh only.
    }
  }

  Future<void> _persistOfficialProfile({bool markCompleted = false}) async {
    final MemberProfileDetails profile = _buildDraft(
      completedAtOverride: markCompleted
          ? DateTime.now().toUtc()
          : _completedAt,
      editingStep: _currentStep.index,
    );
    await ref.read(saveMemberProfileDetailsUseCaseProvider).call(profile);
    _invalidateOfficialProfileProviders();
    _completedAt = profile.completedAt;
  }

  Future<void> _persistOnboardingDraft({bool markCompleted = false}) async {
    if (_isSingleSectionMode) {
      return;
    }
    final MemberProfileDetails profile = _buildDraft(
      completedAtOverride: markCompleted
          ? DateTime.now().toUtc()
          : _completedAt,
      editingStep: _currentStep.index,
    );
    await ref
        .read(memberProfileRepositoryProvider)
        .saveOnboardingDraft(profile);
    _completedAt = profile.completedAt;
  }

  Future<void> _saveOnboardingDraftTemporarily() async {
    if (_isSingleSectionMode ||
        _isLoading ||
        _isSubmitting ||
        _isUploadingPhoto ||
        _isRunningRealPersonAuth) {
      return;
    }
    final l10n = context.l10n;
    setState(() {
      _isSubmitting = true;
    });
    try {
      await _persistOnboardingDraft();
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: context.l10n.memberProfileAutoSavedToast,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(error, l10n.uiErrorRequestFailed),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  MemberProfileDetails _buildDraft({
    DateTime? completedAtOverride,
    required int editingStep,
  }) {
    final String familyName = _familyNameController.text.trim();
    final String givenName = _givenNameController.text.trim();
    final String familyNameKana = _familyNameKanaController.text.trim();
    final String givenNameKana = _givenNameKanaController.text.trim();
    final String normalizedNameKanji = _joinNonEmpty(<String?>[
      familyName,
      givenName,
    ]);
    final String normalizedKatakana = _joinNonEmpty(<String?>[
      familyNameKana,
      givenNameKana,
    ]);
    final String cityAddress = _cityAddressController.text.trim();
    final String prefecture = _prefectureController.text.trim();
    final String composedAddress = _composeAddress(
      prefecture: prefecture,
      cityAddress: cityAddress,
    );
    return MemberProfileDetails(
      familyName: familyName,
      givenName: givenName,
      familyNameKana: familyNameKana,
      givenNameKana: givenNameKana,
      familyNameEn: _familyNameRomanController.text.trim(),
      givenNameEn: _givenNameRomanController.text.trim(),
      nameKanji: normalizedNameKanji,
      katakana: normalizedKatakana,
      address: composedAddress,
      birthday: _emptyToNull(_birthdayController.text),
      sex: _sex,
      taxcountry: _taxCountryController.text.trim(),
      zipCode: _postalCodeController.text.trim(),
      prefectureCode: prefecture,
      cityAddress: cityAddress,
      phoneIntlCode: _phoneIntlCode,
      phone: _phone,
      email: _email,
      occupationCode: _occupation ?? '',
      annualIncomeCode: _annualIncome ?? '',
      financialAssetsCode: _financialAssets ?? '',
      investmentExperienceCodes: _selectedExperiences.toList()..sort(),
      investmentPurposeCode: _investmentPurpose ?? '',
      fundSourceCode: _fundSource ?? '',
      riskToleranceCode: _riskTolerance ?? '',
      ekycDocumentType: _documentType ?? '',
      idDocumentPhotoPath: _emptyToNull(_documentPhotoPath),
      idDocumentBackPhotoPath: _emptyToNull(_documentBackPhotoPath),
      selfiePhotoPath: _emptyToNull(_selfiePhotoPath),
      bankName: _bankNameController.text.trim(),
      branchBankName: _branchNameController.text.trim(),
      branchBankNumber: _branchNumberController.text.trim(),
      bankNumber: _accountNumberController.text.trim(),
      bankAccountType: _accountType ?? '',
      bankAccountOwnerName: _accountHolderController.text.trim(),
      electronicDeliveryConsent: _electronicConsent,
      antiSocialForcesConsent: _antiSocialConsent,
      privacyPolicyConsent: _privacyConsent,
      lastEditingStep: editingStep,
      completedAt: completedAtOverride,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }

  bool get _showFundSourceWarning {
    return _fundSource == 'warn' || _fundSource == 'ng';
  }

  String get _stepTitle =>
      memberProfileEditStepTitle(context.l10n, _currentStep, plain: true);

  String get _stepDescription =>
      memberProfileEditStepDescription(context.l10n, _currentStep);

  String get _primaryActionLabel => context.l10n.profileSaveButton;

  String get _fundSourceWarningBody {
    final l10n = context.l10n;
    return _fundSource == 'ng'
        ? l10n.memberProfileFundSourceWarningHighRisk
        : l10n.memberProfileFundSourceWarningStandard;
  }

  List<DropdownMenuItem<int>> _sexItems(BuildContext context) {
    final l10n = context.l10n;
    return <DropdownMenuItem<int>>[
      DropdownMenuItem<int>(value: 0, child: Text(l10n.memberProfileSexFemale)),
      DropdownMenuItem<int>(value: 1, child: Text(l10n.memberProfileSexMale)),
    ];
  }

  List<MemberProfileOptionItem> _experienceOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(
        value: 'stocks',
        label: l10n.memberProfileExperienceStocks,
      ),
      MemberProfileOptionItem(
        value: 'mutual_funds',
        label: l10n.memberProfileExperienceMutualFunds,
      ),
      MemberProfileOptionItem(
        value: 'real_estate',
        label: l10n.memberProfileExperienceRealEstate,
      ),
      MemberProfileOptionItem(
        value: 'real_estate_crowdfunding',
        label: l10n.memberProfileExperienceRealEstateCrowdfunding,
      ),
      MemberProfileOptionItem(
        value: 'bonds',
        label: l10n.memberProfileExperienceBonds,
      ),
      MemberProfileOptionItem(
        value: 'fx_crypto',
        label: l10n.memberProfileExperienceFxCrypto,
      ),
      MemberProfileOptionItem(
        value: 'none',
        label: l10n.memberProfileExperienceNone,
      ),
    ];
  }

  List<DropdownMenuItem<String>> _simpleItems(
    List<MemberProfileOptionItem> items,
  ) {
    return items
        .map(
          (MemberProfileOptionItem item) => DropdownMenuItem<String>(
            value: item.value,
            child: Text(item.label),
          ),
        )
        .toList(growable: false);
  }

  List<MemberProfileOptionItem> _occupationOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(
        value: 'employee',
        label: l10n.occupationEmployee,
      ),
      MemberProfileOptionItem(
        value: 'self_employed',
        label: l10n.occupationSelfEmployed,
      ),
      MemberProfileOptionItem(
        value: 'public_servant',
        label: l10n.occupationPublicServant,
      ),
      MemberProfileOptionItem(
        value: 'homemaker',
        label: l10n.occupationHomemaker,
      ),
      MemberProfileOptionItem(value: 'student', label: l10n.occupationStudent),
      MemberProfileOptionItem(
        value: 'pensioner',
        label: l10n.occupationPensioner,
      ),
      MemberProfileOptionItem(value: 'other', label: l10n.commonOther),
    ];
  }

  List<MemberProfileOptionItem> _annualIncomeOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(value: 'lt_3m', label: l10n.incomeUnder3m),
      MemberProfileOptionItem(value: '3_5m', label: l10n.income3to5m),
      MemberProfileOptionItem(value: '5_10m', label: l10n.income5to10m),
      MemberProfileOptionItem(value: 'gt_10m', label: l10n.incomeOver10m),
    ];
  }

  List<MemberProfileOptionItem> _financialAssetOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(value: 'lt_1m', label: l10n.assetsUnder1m),
      MemberProfileOptionItem(value: '1_5m', label: l10n.assets1to5m),
      MemberProfileOptionItem(value: '5_10m', label: l10n.assets5to10m),
      MemberProfileOptionItem(value: 'gt_10m', label: l10n.assetsOver10m),
    ];
  }

  List<MemberProfileOptionItem> _purposeOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(value: 'growth', label: l10n.purposeAssetGrowth),
      MemberProfileOptionItem(
        value: 'income',
        label: l10n.purposeDividendIncome,
      ),
      MemberProfileOptionItem(value: 'idle_cash', label: l10n.purposeIdleFunds),
      MemberProfileOptionItem(
        value: 'diversification',
        label: l10n.purposeDiversification,
      ),
    ];
  }

  List<MemberProfileOptionItem> _fundSourceOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(value: 'ok', label: l10n.fundSourceSurplus),
      MemberProfileOptionItem(value: 'warn', label: l10n.fundSourceLivingFunds),
      MemberProfileOptionItem(value: 'ng', label: l10n.fundSourceBorrowed),
    ];
  }

  List<MemberProfileOptionItem> _riskToleranceOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(
        value: 'accept_loss',
        label: l10n.riskToleranceAcceptLoss,
      ),
      MemberProfileOptionItem(
        value: 'low_risk',
        label: l10n.riskToleranceLowRisk,
      ),
      MemberProfileOptionItem(
        value: 'high_risk',
        label: l10n.riskToleranceHighRisk,
      ),
    ];
  }

  List<MemberProfileOptionItem> _documentTypeOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(
        value: 'drivers_license',
        label: l10n.documentTypeDriversLicense,
      ),
      MemberProfileOptionItem(
        value: 'my_number',
        label: l10n.documentTypeMyNumber,
      ),
      MemberProfileOptionItem(
        value: 'residence_card',
        label: l10n.documentTypeResidenceCard,
      ),
      MemberProfileOptionItem(
        value: 'passport',
        label: l10n.documentTypePassport,
      ),
      MemberProfileOptionItem(value: 'other', label: l10n.documentTypeOther),
    ];
  }

  List<MemberProfileOptionItem> _accountTypeOptions(BuildContext context) {
    final l10n = context.l10n;
    return <MemberProfileOptionItem>[
      MemberProfileOptionItem(
        value: 'ordinary',
        label: l10n.accountTypeOrdinary,
      ),
      MemberProfileOptionItem(
        value: 'checking',
        label: l10n.accountTypeChecking,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isSectionAccessChecking) {
      return Scaffold(
        backgroundColor: Theme.of(context).appColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    ref.listen<AsyncValue<bool>>(settingsRealPersonVerifiedProvider, (
      AsyncValue<bool>? _,
      AsyncValue<bool> next,
    ) {
      if (!mounted) {
        return;
      }
      final normalizedStep = _normalizeStepForIdentityAuth(
        _currentStep,
        realPersonVerified: next.asData?.value == true,
      );
      if (normalizedStep == _currentStep) {
        return;
      }
      setState(() {
        _currentStep = normalizedStep;
      });
    });
    final isRealPersonVerified =
        ref.watch(settingsRealPersonVerifiedProvider).asData?.value == true;
    final showRealPersonAuthStep = _shouldShowRealPersonAuthStep(
      realPersonVerified: isRealPersonVerified,
    );
    final stepCount =
        MemberProfileEditStep.values.length - (showRealPersonAuthStep ? 0 : 1);
    final currentStepIndex = showRealPersonAuthStep
        ? _currentStep.index
        : (_currentStep.index > MemberProfileEditStep.realPersonAuth.index
              ? _currentStep.index - 1
              : _currentStep.index);

    return PopScope<void>(
      canPop: _isSingleSectionMode || _currentStep.isFirst,
      onPopInvokedWithResult: (bool didPop, void _) {
        if (!didPop &&
            !_isSingleSectionMode &&
            !_currentStep.isFirst &&
            !_isSubmitting &&
            !_isUploadingPhoto &&
            !_isRunningRealPersonAuth) {
          _goPreviousStep();
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppNavigationBar(
          title: _isSingleSectionMode
              ? l10n.menuItemEditProfile
              : l10n.memberProfileFlowTitle,
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          leading: SizedBox.square(
            dimension: 32,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: (_isSubmitting || _isUploadingPhoto)
                    ? null
                    : _isRunningRealPersonAuth
                    ? null
                    : _isSingleSectionMode
                    ? () => context.pop()
                    : _goPreviousStep,
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
            if (!_isSingleSectionMode)
              AppStepProgressBar(
                stepCount: stepCount,
                currentStep: currentStepIndex,
                pendingColor: colors.borderSoft,
              ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      layoutBuilder:
                          (
                            Widget? currentChild,
                            List<Widget> previousChildren,
                          ) => Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          ),
                      child: KeyedSubtree(
                        key: ValueKey<MemberProfileEditStep>(_currentStep),
                        child: _buildStep(context),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context) {
    final String? secondaryButtonLabel = _isSingleSectionMode
        ? null
        : context.l10n.memberProfileTemporarySaveAction;
    final VoidCallback? onSecondaryPressed = _isSingleSectionMode
        ? null
        : _saveOnboardingDraftTemporarily;
    switch (_currentStep) {
      case MemberProfileEditStep.basicInfo:
        final bool isActionEnabled = _canProceedFromCurrentStep;
        return MemberProfileBasicInfoStepPage(
          familyNameController: _familyNameController,
          givenNameController: _givenNameController,
          familyNameKanaController: _familyNameKanaController,
          givenNameKanaController: _givenNameKanaController,
          familyNameRomanController: _familyNameRomanController,
          givenNameRomanController: _givenNameRomanController,
          birthdayController: _birthdayController,
          sexValue: _sex,
          sexItems: _sexItems(context),
          taxCountryController: _taxCountryController,
          showAgeWarning: _showAgeWarning,
          primaryButtonEnabled: isActionEnabled,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onBirthdayTap: _pickBirthday,
          onSexChanged: (int? value) {
            _applyUserChange(() {
              _sex = _normalizeSex(value);
            });
          },
          onNext: _isSingleSectionMode ? _saveCurrentSection : _goNextStep,
          onSkip: _isSingleSectionMode
              ? null
              : isActionEnabled
              ? _goNextStep
              : null,
        );
      case MemberProfileEditStep.addressInfo:
        final bool isActionEnabled = _canProceedFromCurrentStep;
        return MemberProfileAddressInfoStepPage(
          postalCodeController: _postalCodeController,
          prefectureController: _prefectureController,
          cityAddressController: _cityAddressController,
          primaryButtonEnabled: isActionEnabled,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onAddressSearch: _isAddressSearching
              ? null
              : _searchAddressByPostalCode,
          onNext: _isSingleSectionMode ? _saveCurrentSection : _goNextStep,
          onSkip: _isSingleSectionMode
              ? null
              : isActionEnabled
              ? _goNextStep
              : null,
        );
      case MemberProfileEditStep.suitability:
        return MemberProfileSuitabilityStepPage(
          occupation: _occupation,
          annualIncome: _annualIncome,
          financialAssets: _financialAssets,
          investmentPurpose: _investmentPurpose,
          fundSource: _fundSource,
          riskTolerance: _riskTolerance,
          occupationItems: _simpleItems(_occupationOptions(context)),
          annualIncomeItems: _simpleItems(_annualIncomeOptions(context)),
          financialAssetItems: _simpleItems(_financialAssetOptions(context)),
          investmentPurposeItems: _simpleItems(_purposeOptions(context)),
          fundSourceItems: _simpleItems(_fundSourceOptions(context)),
          riskToleranceItems: _simpleItems(_riskToleranceOptions(context)),
          investmentExperienceOptions: _experienceOptions(context),
          selectedExperiences: _selectedExperiences,
          showFundSourceWarning: _showFundSourceWarning,
          fundSourceWarningBody: _fundSourceWarningBody,
          primaryButtonEnabled: _canProceedFromCurrentStep,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onOccupationChanged: (String? value) {
            _applyUserChange(() {
              _occupation = value;
            });
          },
          onAnnualIncomeChanged: (String? value) {
            _applyUserChange(() {
              _annualIncome = value;
            });
          },
          onFinancialAssetsChanged: (String? value) {
            _applyUserChange(() {
              _financialAssets = value;
            });
          },
          onInvestmentPurposeChanged: (String? value) {
            _applyUserChange(() {
              _investmentPurpose = value;
            });
          },
          onFundSourceChanged: (String? value) {
            _applyUserChange(() {
              _fundSource = value;
            });
          },
          onRiskToleranceChanged: (String? value) {
            _applyUserChange(() {
              _riskTolerance = value;
            });
          },
          onToggleExperience: (String value) {
            _applyUserChange(() {
              if (_selectedExperiences.contains(value)) {
                _selectedExperiences.remove(value);
              } else {
                _selectedExperiences.add(value);
              }
            });
          },
          onNext: _isSingleSectionMode ? _saveCurrentSection : _goNextStep,
        );
      case MemberProfileEditStep.ekyc:
        return MemberProfileEkycStepPage(
          documentType: _documentType,
          documentTypeItems: _simpleItems(_documentTypeOptions(context)),
          documentFrontUploaded: _isRemoteImageUrl(_documentPhotoPath),
          documentBackUploaded: _isRemoteImageUrl(_documentBackPhotoPath),
          primaryButtonEnabled:
              _canProceedFromCurrentStep &&
              !_isUploadingPhoto &&
              !_isSubmitting,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onDocumentTypeChanged: (String? value) {
            _applyUserChange(() {
              _documentType = value;
            });
          },
          onUploadDocumentFront: (_isSubmitting || _isUploadingPhoto)
              ? null
              : _isRunningRealPersonAuth
              ? null
              : () => _pickAndSaveImage(target: _documentFrontPhotoTarget),
          onUploadDocumentBack: (_isSubmitting || _isUploadingPhoto)
              ? null
              : _isRunningRealPersonAuth
              ? null
              : () => _pickAndSaveImage(target: _documentBackPhotoTarget),
          onNext: _isSingleSectionMode ? _saveCurrentSection : _goNextStep,
        );
      case MemberProfileEditStep.realPersonAuth:
        if (!_shouldShowRealPersonAuthStep() && !_isSingleSectionMode) {
          return const SizedBox.shrink();
        }
        return MemberProfileRealPersonAuthStepPage(
          isProcessing: _isRunningRealPersonAuth,
          selfieUploaded: _isSelfieUploaded(_selfiePhotoPath),
          primaryButtonEnabled:
              _canProceedFromCurrentStep &&
              !_isUploadingPhoto &&
              !_isSubmitting &&
              !_isRunningRealPersonAuth,
          showSkip: !_isSingleSectionMode,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          statusMessage: _realPersonAuthStatusMessage,
          onUploadSelfie: (_isSubmitting || _isUploadingPhoto)
              ? null
              : _isRunningRealPersonAuth
              ? null
              : () => _pickAndSaveImage(target: _selfiePhotoTarget),
          onStartVerification: _isRunningRealPersonAuth
              ? null
              : _isSingleSectionMode
              ? _saveCurrentSection
              : _goNextStep,
          onSkip: _skipRealPersonAuthStep,
        );
      case MemberProfileEditStep.bankAccount:
        final accountTypeItems = _simpleItems(_accountTypeOptions(context));
        final accountTypeValues = accountTypeItems
            .map((DropdownMenuItem<String> item) => item.value)
            .whereType<String>()
            .toSet();
        final safeAccountType = accountTypeValues.contains(_accountType)
            ? _accountType
            : null;
        return MemberProfileBankAccountStepPage(
          bankNameController: _bankNameController,
          branchNameController: _branchNameController,
          branchNumberController: _branchNumberController,
          accountType: safeAccountType,
          accountTypeItems: accountTypeItems,
          accountNumberController: _accountNumberController,
          accountHolderController: _accountHolderController,
          primaryButtonEnabled: _canProceedFromCurrentStep,
          showSkip: !_isSingleSectionMode,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onAccountTypeChanged: (String? value) {
            _applyUserChange(() {
              _accountType = _normalizeAccountType(value);
            });
          },
          onNext: _isSingleSectionMode ? _saveCurrentSection : _goNextStep,
          onSkip: _isSingleSectionMode ? null : _skipBankAccountStep,
        );
      case MemberProfileEditStep.consent:
        return MemberProfileConsentStepPage(
          electronicConsent: _electronicConsent,
          antiSocialConsent: _antiSocialConsent,
          privacyConsent: _privacyConsent,
          titleOverride: _isSingleSectionMode ? _stepTitle : null,
          descriptionOverride: _isSingleSectionMode ? _stepDescription : null,
          secondaryButtonLabelOverride: secondaryButtonLabel,
          onSecondaryPressed: onSecondaryPressed,
          primaryButtonLabelOverride: _isSingleSectionMode
              ? _primaryActionLabel
              : null,
          onElectronicConsentChanged: (bool value) {
            _applyUserChange(() {
              _electronicConsent = value;
            });
          },
          onAntiSocialConsentChanged: (bool value) {
            _applyUserChange(() {
              _antiSocialConsent = value;
            });
          },
          onPrivacyConsentChanged: (bool value) {
            _applyUserChange(() {
              _privacyConsent = value;
            });
          },
          onComplete: (_isSubmitting || _isRunningRealPersonAuth)
              ? null
              : _isSingleSectionMode
              ? _saveCurrentSection
              : _completeFlow,
        );
    }
  }
}

String _resolveSubmitErrorMessage(Object error, String fallbackMessage) {
  const internalFallbackMessages = <String>{
    'Please upload an ID document photo.',
    'Failed to upload profile photo.',
    'Failed to save member profile.',
  };
  if (error is StateError) {
    final dynamic raw = error.message;
    final String text = raw?.toString().trim() ?? '';
    if (text.isNotEmpty && !internalFallbackMessages.contains(text)) {
      return text;
    }
  }
  return fallbackMessage;
}

bool _isFilled(String? value) => (value?.trim().isNotEmpty ?? false);

bool _isRemoteImageUrl(String? value) {
  final normalized = value?.trim() ?? '';
  if (normalized.isEmpty) {
    return false;
  }
  return normalized.startsWith('http://') || normalized.startsWith('https://');
}

int? _normalizeSex(int? value) {
  return value == 0 || value == 1 ? value : null;
}

bool _isSelfieUploaded(String? value) {
  final normalized = value?.trim() ?? '';
  if (normalized.isEmpty) {
    return false;
  }
  if (normalized == selfieUploadCompletedMarker) {
    return true;
  }
  return _isRemoteImageUrl(normalized);
}

String _joinNonEmpty(List<String?> values) {
  return values
      .map((String? value) => value?.trim() ?? '')
      .where((String value) => value.isNotEmpty)
      .join(' ');
}

String _firstNonEmpty(List<String> values) {
  for (final String value in values) {
    if (value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return '';
}

String? _emptyToNull(String? value) {
  final String normalized = value?.trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

DateTime? _tryParseBirthday(String? raw) {
  final String value = raw?.trim() ?? '';
  if (value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value);
}

String _formatDate(DateTime value) {
  final String month = value.month.toString().padLeft(2, '0');
  final String day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String? _resolvePrefecture(String address) {
  final normalized = address.trim();
  if (normalized.isEmpty) {
    return null;
  }
  final match = RegExp(r'^(東京都|北海道|(?:京都|大阪)府|.+?県)').firstMatch(normalized);
  return match?.group(0);
}

String _prefectureInputValue(AppLocalizations l10n, String raw) {
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

  final prefecture = _resolvePrefecture(normalized)?.trim() ?? '';
  if (prefecture.isEmpty) {
    return ('', normalized);
  }

  final cityAddress = normalized.substring(prefecture.length).trim();
  return (prefecture, cityAddress);
}

String _readBankString(Map<String, dynamic>? bank, String key) {
  if (bank == null) {
    return '';
  }
  final Object? value = bank[key];
  if (value == null) {
    return '';
  }
  final String text = value.toString().trim();
  return text;
}

String? _normalizeAccountType(String? raw) {
  final String normalized = raw?.trim().toLowerCase() ?? '';
  if (normalized.isEmpty) {
    return null;
  }
  switch (normalized) {
    case '1':
    case 'ordinary':
    case '普通':
    case '普通預金':
      return 'ordinary';
    case '2':
    case 'checking':
    case 'current':
    case '当座':
    case '当座預金':
      return 'checking';
    default:
      return normalized;
  }
}

(String, String) _splitJapaneseName(String fullName) {
  final List<String> parts = fullName
      .split(RegExp(r'\s+'))
      .where((String part) => part.trim().isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return ('', '');
  }
  if (parts.length == 1) {
    return (parts.first, '');
  }
  return (parts.first, parts.skip(1).join(' '));
}

String _composeAddress({
  required String prefecture,
  required String cityAddress,
}) {
  return _joinNonEmpty(<String?>[prefecture, cityAddress]);
}

String _normalizePostalCode(String value) {
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}
