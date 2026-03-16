import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_identity_auth/core_identity_auth.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/identity_auth_sdk_providers.dart';
import '../../../auth/presentation/support/identity_auth_message_resolver.dart';
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
import '../support/member_profile_option_item.dart';
import '../support/profile_document_image_picker.dart';
import '../support/member_profile_zip_candidate_picker.dart';

class MemberProfileEditFlowPage extends ConsumerStatefulWidget {
  const MemberProfileEditFlowPage({super.key});

  @override
  ConsumerState<MemberProfileEditFlowPage> createState() =>
      _MemberProfileEditFlowPageState();
}

class _MemberProfileEditFlowPageState
    extends ConsumerState<MemberProfileEditFlowPage> {
  late final TextEditingController _nameKanjiController;
  late final TextEditingController _nameKanaController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _phoneController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _cityAddressController;
  late final TextEditingController _bankNameController;
  late final TextEditingController _branchNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountHolderController;

  MemberProfileEditStep _currentStep = MemberProfileEditStep.basicInfo;
  DateTime? _birthday;
  String? _prefecture;
  String? _occupation;
  String? _annualIncome;
  String? _financialAssets;
  String? _investmentPurpose;
  String? _fundSource = 'ok';
  String? _riskTolerance;
  String? _documentType = 'drivers_license';
  String? _accountType = 'ordinary';
  String _phoneIntlCode = '81';
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
  String? _realPersonAuthStatusMessage;

  @override
  void initState() {
    super.initState();
    _nameKanjiController = TextEditingController();
    _nameKanaController = TextEditingController();
    _birthdayController = TextEditingController();
    _phoneController = TextEditingController();
    _postalCodeController = TextEditingController();
    _cityAddressController = TextEditingController();
    _bankNameController = TextEditingController();
    _branchNameController = TextEditingController();
    _accountNumberController = TextEditingController();
    _accountHolderController = TextEditingController();
    _registerTextFieldListeners();
    _loadInitialData();
  }

  @override
  void dispose() {
    _unregisterTextFieldListeners();
    _nameKanjiController.dispose();
    _nameKanaController.dispose();
    _birthdayController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _cityAddressController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
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
        _nameKanjiController,
        _nameKanaController,
        _birthdayController,
        _phoneController,
        _postalCodeController,
        _cityAddressController,
        _bankNameController,
        _branchNameController,
        _accountNumberController,
        _accountHolderController,
      ];

  void _onTrackedFieldChanged() {
    if (!mounted || _isLoading) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadInitialData() async {
    try {
      final MemberProfileDetails? savedProfile = await ref
          .read(loadMemberProfileDetailsUseCaseProvider)
          .call();
      final AuthUser? authUser = await ref
          .read(currentAuthUserProvider.future)
          .catchError((Object _) => null);

      final String savedNameKanji = savedProfile?.nameKanji.trim() ?? '';
      final String legacyNameKanji = _joinNonEmpty(<String?>[
        savedProfile?.familyName,
        savedProfile?.givenName,
      ]);
      final String authNameKanji = _joinNonEmpty(<String?>[
        authUser?.lastName,
        authUser?.firstName,
      ]);
      final String nameKanji = _firstNonEmpty(<String>[
        savedNameKanji,
        legacyNameKanji,
        authNameKanji,
      ]);
      final Map<String, dynamic>? authBank = authUser?.bank;

      if (!mounted) {
        return;
      }

      setState(() {
        _nameKanjiController.text = nameKanji;
        _nameKanaController.text = _firstNonEmpty(<String>[
          savedProfile?.katakana ?? '',
          authUser?.katakana ?? '',
        ]);
        _phoneController.text = savedProfile?.phone.trim().isNotEmpty == true
            ? savedProfile!.phone.trim()
            : (authUser?.phone?.trim().isNotEmpty == true
                  ? authUser!.phone!.trim()
                  : (authUser?.mobile?.trim() ?? ''));
        _postalCodeController.text = _firstNonEmpty(<String>[
          savedProfile?.zipCode ?? '',
          authUser?.zipCode ?? '',
        ]);
        _cityAddressController.text = _firstNonEmpty(<String>[
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
        _prefecture = (savedProfile?.prefectureCode.trim().isNotEmpty ?? false)
            ? savedProfile!.prefectureCode.trim()
            : _resolvePrefecture(
                _firstNonEmpty(<String>[
                  savedProfile?.address ?? '',
                  authUser?.address ?? '',
                ]),
              );
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
        _currentStep =
            MemberProfileEditStep.values[savedStep.clamp(
              0,
              MemberProfileEditStep.values.length - 1,
            )];
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
    await _persistDraft();
  }

  Future<void> _pickAndSaveImage({required bool isDocument}) async {
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
    final String? path = await ref
        .read(profileDocumentImagePickerProvider)
        .pick(source);
    if (!mounted || path == null || path.trim().isEmpty) {
      return;
    }
    setState(() {
      _isUploadingPhoto = true;
    });
    try {
      final uploadedUrl = await ref
          .read(uploadMemberProfilePhotoUseCaseProvider)
          .call(filePath: path.trim(), isSelfie: !isDocument);
      if (!mounted) {
        return;
      }
      setState(() {
        if (isDocument) {
          _documentPhotoPath = uploadedUrl.trim();
        } else {
          _selfiePhotoPath = uploadedUrl.trim();
        }
      });
      await _persistDraft();
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: context.l10n.memberProfilePhotoUploadSuccess,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: _resolveSubmitErrorMessage(
          error,
          context.l10n.uiErrorRequestFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
        });
      }
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

      final MemberProfileRegion? selected = rows.length == 1
          ? rows.first
          : await MemberProfileZipCandidatePicker.show(
              context,
              candidates: rows,
              title: l10n.memberProfileAddressSearchSelectTitle,
              cancelLabel: l10n.commonClose,
            );

      if (!mounted || selected == null) {
        return;
      }

      _applyResolvedAddress(selected.displayName);
      await _persistDraft();
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

  void _applyResolvedAddress(String rawAddress) {
    final normalizedAddress = rawAddress.trim();
    if (normalizedAddress.isEmpty) {
      return;
    }

    final resolvedPrefecture = _resolvePrefecture(normalizedAddress);
    final normalizedCityAddress = _cityAddressWithoutPrefecture(
      normalizedAddress,
      resolvedPrefecture,
    );

    setState(() {
      if (resolvedPrefecture != null) {
        _prefecture = resolvedPrefecture;
      }
      _cityAddressController.text = normalizedCityAddress;
    });
  }

  Future<void> _goNextStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    if (!_canProceedFromCurrentStep) {
      return;
    }
    if (_currentStep == MemberProfileEditStep.realPersonAuth) {
      final verified = await _runRealPersonAuthStep();
      if (!verified) {
        return;
      }
    }
    await _persistDraft();
    if (!mounted) {
      return;
    }
    final MemberProfileEditStep? next = _currentStep.next;
    if (next == null) {
      return;
    }
    setState(() {
      _currentStep = next;
    });
    await _persistDraft();
  }

  Future<void> _goPreviousStep() async {
    if (_isSubmitting || _isUploadingPhoto || _isRunningRealPersonAuth) {
      return;
    }
    await _persistDraft();
    if (!mounted) {
      return;
    }
    final MemberProfileEditStep? previous = _currentStep.previous;
    if (previous == null) {
      context.pop();
      return;
    }
    setState(() {
      _currentStep = previous;
    });
    await _persistDraft();
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
      await _persistDraft(markCompleted: true);
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
        return _isSelfieUploaded(_selfiePhotoPath);
      case MemberProfileEditStep.bankAccount:
        return _isBankAccountStepReady;
      case MemberProfileEditStep.consent:
        return _isConsentStepReady;
    }
  }

  Future<bool> _runRealPersonAuthStep() async {
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
        AppNotice.show(context, message: message);
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

  bool get _isBasicInfoStepReady =>
      _isFilled(_nameKanjiController.text) &&
      _isFilled(_nameKanaController.text) &&
      _isFilled(_birthdayController.text) &&
      _isFilled(_phoneController.text);

  bool get _isAddressInfoStepReady =>
      _isFilled(_postalCodeController.text) &&
      _isFilled(_prefecture) &&
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
      _isSelfieUploaded(_selfiePhotoPath);

  bool get _isBankAccountStepReady =>
      _isFilled(_bankNameController.text) &&
      _isFilled(_branchNameController.text) &&
      _isFilled(_accountType) &&
      _isFilled(_accountNumberController.text) &&
      _isFilled(_accountHolderController.text);

  bool get _isConsentStepReady =>
      _electronicConsent && _antiSocialConsent && _privacyConsent;

  Future<void> _persistDraft({bool markCompleted = false}) async {
    final MemberProfileDetails profile = _buildDraft(
      completedAtOverride: markCompleted
          ? DateTime.now().toUtc()
          : _completedAt,
      editingStep: _currentStep.index,
    );
    await ref.read(saveMemberProfileDetailsUseCaseProvider).call(profile);
    ref.invalidate(memberProfileDetailsProvider);
    ref.invalidate(isMemberProfileCompletedProvider);
    _completedAt = profile.completedAt;
  }

  MemberProfileDetails _buildDraft({
    DateTime? completedAtOverride,
    required int editingStep,
  }) {
    final String normalizedNameKanji = _nameKanjiController.text.trim();
    final (String familyName, String givenName) = _splitJapaneseName(
      normalizedNameKanji,
    );
    final String cityAddress = _cityAddressController.text.trim();
    final String composedAddress = _composeAddress(
      prefectureCode: _prefecture,
      cityAddress: cityAddress,
      l10n: context.l10n,
    );
    return MemberProfileDetails(
      familyName: familyName,
      givenName: givenName,
      nameKanji: normalizedNameKanji,
      katakana: _nameKanaController.text.trim(),
      address: composedAddress,
      birthday: _emptyToNull(_birthdayController.text),
      zipCode: _postalCodeController.text.trim(),
      prefectureCode: _prefecture ?? '',
      cityAddress: cityAddress,
      phoneIntlCode: _phoneIntlCode,
      phone: _phoneController.text.trim(),
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

  String get _fundSourceWarningBody {
    final l10n = context.l10n;
    return _fundSource == 'ng'
        ? l10n.memberProfileFundSourceWarningHighRisk
        : l10n.memberProfileFundSourceWarningStandard;
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

  List<DropdownMenuItem<String>> _prefectureItems(BuildContext context) {
    final l10n = context.l10n;
    return <DropdownMenuItem<String>>[
      DropdownMenuItem<String>(
        value: 'tokyo',
        child: Text(l10n.prefectureTokyo),
      ),
      DropdownMenuItem<String>(
        value: 'osaka',
        child: Text(l10n.prefectureOsaka),
      ),
      DropdownMenuItem<String>(
        value: 'kanagawa',
        child: Text(l10n.prefectureKanagawa),
      ),
      DropdownMenuItem<String>(
        value: 'aichi',
        child: Text(l10n.prefectureAichi),
      ),
      DropdownMenuItem<String>(
        value: 'fukuoka',
        child: Text(l10n.prefectureFukuoka),
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
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return PopScope<void>(
      canPop: _currentStep.isFirst,
      onPopInvokedWithResult: (bool didPop, void _) {
        if (!didPop &&
            !_currentStep.isFirst &&
            !_isSubmitting &&
            !_isUploadingPhoto &&
            !_isRunningRealPersonAuth) {
          _goPreviousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColorTokens.fundexBackground,
        appBar: AppNavigationBar(
          title: l10n.memberProfileFlowTitle,
          backgroundColor: Colors.white,
          foregroundColor: theme.colorScheme.onSurface,
          leading: SizedBox.square(
            dimension: 32,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: (_isSubmitting || _isUploadingPhoto)
                    ? null
                    : _isRunningRealPersonAuth
                    ? null
                    : _goPreviousStep,
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            AppStepProgressBar(
              stepCount: MemberProfileEditStep.values.length,
              currentStep: _currentStep.index,
              pendingColor: const Color(0xFFE2E8F0),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
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
    switch (_currentStep) {
      case MemberProfileEditStep.basicInfo:
        final bool isActionEnabled = _canProceedFromCurrentStep;
        return MemberProfileBasicInfoStepPage(
          nameKanjiController: _nameKanjiController,
          nameKanaController: _nameKanaController,
          birthdayController: _birthdayController,
          phoneController: _phoneController,
          showAgeWarning: _showAgeWarning,
          primaryButtonEnabled: isActionEnabled,
          onBirthdayTap: _pickBirthday,
          onNext: _goNextStep,
          onSkip: isActionEnabled ? _goNextStep : null,
        );
      case MemberProfileEditStep.addressInfo:
        final bool isActionEnabled = _canProceedFromCurrentStep;
        return MemberProfileAddressInfoStepPage(
          postalCodeController: _postalCodeController,
          prefecture: _prefecture,
          cityAddressController: _cityAddressController,
          prefectureItems: _prefectureItems(context),
          primaryButtonEnabled: isActionEnabled,
          onPrefectureChanged: (String? value) {
            setState(() {
              _prefecture = value;
            });
          },
          onAddressSearch: _isAddressSearching
              ? null
              : _searchAddressByPostalCode,
          onNext: _goNextStep,
          onSkip: isActionEnabled ? _goNextStep : null,
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
          onOccupationChanged: (String? value) {
            setState(() {
              _occupation = value;
            });
          },
          onAnnualIncomeChanged: (String? value) {
            setState(() {
              _annualIncome = value;
            });
          },
          onFinancialAssetsChanged: (String? value) {
            setState(() {
              _financialAssets = value;
            });
          },
          onInvestmentPurposeChanged: (String? value) {
            setState(() {
              _investmentPurpose = value;
            });
          },
          onFundSourceChanged: (String? value) {
            setState(() {
              _fundSource = value;
            });
          },
          onRiskToleranceChanged: (String? value) {
            setState(() {
              _riskTolerance = value;
            });
          },
          onToggleExperience: (String value) {
            setState(() {
              if (_selectedExperiences.contains(value)) {
                _selectedExperiences.remove(value);
              } else {
                _selectedExperiences.add(value);
              }
            });
          },
          onNext: _goNextStep,
        );
      case MemberProfileEditStep.ekyc:
        return MemberProfileEkycStepPage(
          documentType: _documentType,
          documentTypeItems: _simpleItems(_documentTypeOptions(context)),
          documentUploaded: _isRemoteImageUrl(_documentPhotoPath),
          selfieUploaded: _isSelfieUploaded(_selfiePhotoPath),
          primaryButtonEnabled:
              _canProceedFromCurrentStep &&
              !_isUploadingPhoto &&
              !_isSubmitting,
          onDocumentTypeChanged: (String? value) {
            setState(() {
              _documentType = value;
            });
          },
          onUploadDocument: (_isSubmitting || _isUploadingPhoto)
              ? null
              : _isRunningRealPersonAuth
              ? null
              : () => _pickAndSaveImage(isDocument: true),
          onUploadSelfie: (_isSubmitting || _isUploadingPhoto)
              ? null
              : _isRunningRealPersonAuth
              ? null
              : () => _pickAndSaveImage(isDocument: false),
          onNext: _goNextStep,
        );
      case MemberProfileEditStep.realPersonAuth:
        return MemberProfileRealPersonAuthStepPage(
          isProcessing: _isRunningRealPersonAuth,
          statusMessage: _realPersonAuthStatusMessage,
          onStartVerification: _isRunningRealPersonAuth ? null : _goNextStep,
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
          accountType: safeAccountType,
          accountTypeItems: accountTypeItems,
          accountNumberController: _accountNumberController,
          accountHolderController: _accountHolderController,
          primaryButtonEnabled: _canProceedFromCurrentStep,
          onAccountTypeChanged: (String? value) {
            setState(() {
              _accountType = _normalizeAccountType(value);
            });
          },
          onNext: _goNextStep,
        );
      case MemberProfileEditStep.consent:
        return MemberProfileConsentStepPage(
          electronicConsent: _electronicConsent,
          antiSocialConsent: _antiSocialConsent,
          privacyConsent: _privacyConsent,
          onElectronicConsentChanged: (bool value) {
            setState(() {
              _electronicConsent = value;
            });
          },
          onAntiSocialConsentChanged: (bool value) {
            setState(() {
              _antiSocialConsent = value;
            });
          },
          onPrivacyConsentChanged: (bool value) {
            setState(() {
              _privacyConsent = value;
            });
          },
          onComplete: (_isSubmitting || _isRunningRealPersonAuth)
              ? null
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
  if (address.startsWith('東京都')) {
    return 'tokyo';
  }
  if (address.startsWith('大阪府')) {
    return 'osaka';
  }
  if (address.startsWith('神奈川県')) {
    return 'kanagawa';
  }
  if (address.startsWith('愛知県')) {
    return 'aichi';
  }
  if (address.startsWith('福岡県')) {
    return 'fukuoka';
  }
  return null;
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
  required String? prefectureCode,
  required String cityAddress,
  required AppLocalizations l10n,
}) {
  final String prefecture = switch (prefectureCode) {
    'tokyo' => l10n.prefectureTokyo,
    'osaka' => l10n.prefectureOsaka,
    'kanagawa' => l10n.prefectureKanagawa,
    'aichi' => l10n.prefectureAichi,
    'fukuoka' => l10n.prefectureFukuoka,
    _ => '',
  };
  return _joinNonEmpty(<String?>[prefecture, cityAddress]);
}

String _normalizePostalCode(String value) {
  return value.replaceAll(RegExp(r'[^0-9]'), '');
}

String _cityAddressWithoutPrefecture(String address, String? prefectureCode) {
  final normalizedAddress = address.trim();
  if (normalizedAddress.isEmpty) {
    return '';
  }

  final prefecture = switch (prefectureCode) {
    'tokyo' => '東京都',
    'osaka' => '大阪府',
    'kanagawa' => '神奈川県',
    'aichi' => '愛知県',
    'fukuoka' => '福岡県',
    _ => '',
  };
  if (prefecture.isNotEmpty && normalizedAddress.startsWith(prefecture)) {
    final cityOnly = normalizedAddress.substring(prefecture.length).trim();
    if (cityOnly.isNotEmpty) {
      return cityOnly;
    }
  }
  return normalizedAddress;
}
