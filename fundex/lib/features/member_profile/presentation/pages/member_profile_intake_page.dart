import 'dart:io';

import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_permission_dialogs.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/support/intl_code_picker_field.dart';
import '../../domain/entities/member_profile_details.dart';
import '../providers/member_profile_providers.dart';
import '../support/profile_document_image_picker.dart';

enum _MemberProfileFlowMode { onboarding, edit }

class MemberProfileIntakePage extends ConsumerStatefulWidget {
  const MemberProfileIntakePage.onboarding({
    super.key,
    this.nextRoute,
    this.seedPhone,
    this.seedEmail,
  }) : _mode = _MemberProfileFlowMode.onboarding;

  const MemberProfileIntakePage.edit({
    super.key,
    this.seedPhone,
    this.seedEmail,
  }) : _mode = _MemberProfileFlowMode.edit,
       nextRoute = null;

  final _MemberProfileFlowMode _mode;
  final String? nextRoute;
  final String? seedPhone;
  final String? seedEmail;

  bool get allowSkip => _mode == _MemberProfileFlowMode.onboarding;
  bool get isOnboarding => _mode == _MemberProfileFlowMode.onboarding;

  @override
  ConsumerState<MemberProfileIntakePage> createState() =>
      _MemberProfileIntakePageState();
}

class _MemberProfileIntakePageState
    extends ConsumerState<MemberProfileIntakePage> {
  static final RegExp _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _phoneRegExp = RegExp(r'^[0-9+\-()\s]{6,20}$');

  late final TextEditingController _familyNameController;
  late final TextEditingController _givenNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  int _stepIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isPickingPhoto = false;
  String _selectedIntlCode = AuthApiDefaults.defaultIntlCode;
  String? _documentPhotoPath;
  DateTime? _lastSkippedAt;
  DateTime? _lastUpdatedAt;
  bool _hasLoadedInitialData = false;

  bool get _isEditMode => widget._mode == _MemberProfileFlowMode.edit;
  bool get _isLastStep => _stepIndex == 2;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
    _givenNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _givenNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final savedProfile = await ref
          .read(loadMemberProfileDetailsUseCaseProvider)
          .call();

      final authUser = await ref
          .read(currentAuthUserProvider.future)
          .catchError((_) {
            return null;
          });

      final merged = (savedProfile ?? const MemberProfileDetails())
          .mergeWithSeed(phone: widget.seedPhone, email: widget.seedEmail)
          .mergeWithSeed(
            phoneIntlCode: authUser?.intlTelCode,
            phone: authUser?.phone ?? authUser?.mobile,
            email: authUser?.email,
          );

      if (!mounted) {
        return;
      }

      _familyNameController.text = merged.familyName;
      _givenNameController.text = merged.givenName;
      _addressController.text = merged.address;
      _phoneController.text = merged.phone;
      _emailController.text = merged.email;
      _selectedIntlCode = (merged.phoneIntlCode.trim().isEmpty)
          ? AuthApiDefaults.defaultIntlCode
          : merged.phoneIntlCode;
      _documentPhotoPath = merged.idDocumentPhotoPath;
      _lastSkippedAt = merged.lastSkippedAt;
      _lastUpdatedAt = merged.lastUpdatedAt;
      _hasLoadedInitialData = true;
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _normalized(String value) => value.trim();

  MemberProfileDetails _buildDraft({DateTime? lastSkippedAtOverride}) {
    final now = DateTime.now().toUtc();
    final photoPath = _documentPhotoPath?.trim();
    return MemberProfileDetails(
      familyName: _normalized(_familyNameController.text),
      givenName: _normalized(_givenNameController.text),
      address: _normalized(_addressController.text),
      phoneIntlCode: _selectedIntlCode.trim().isEmpty
          ? AuthApiDefaults.defaultIntlCode
          : _selectedIntlCode.trim(),
      phone: _normalized(_phoneController.text),
      email: _normalized(_emailController.text),
      idDocumentPhotoPath: (photoPath == null || photoPath.isEmpty)
          ? null
          : photoPath,
      lastUpdatedAt: now,
      lastSkippedAt: lastSkippedAtOverride ?? _lastSkippedAt,
    );
  }

  Future<void> _showValidationMessage(String message) {
    final l10n = context.l10n;
    return AppDialogs.showAdaptiveAlert<void>(
      context: context,
      title: l10n.profileIntakeValidationTitle,
      message: message,
      actions: <AppDialogAction<void>>[
        AppDialogAction<void>(label: l10n.commonOk, isDefaultAction: true),
      ],
    );
  }

  String? _validateStep(int stepIndex, BuildContext context) {
    final l10n = context.l10n;
    if (stepIndex == 0) {
      if (_normalized(_familyNameController.text).isEmpty) {
        return l10n.profileFamilyNameRequired;
      }
      if (_normalized(_givenNameController.text).isEmpty) {
        return l10n.profileGivenNameRequired;
      }
      return null;
    }
    if (stepIndex == 1) {
      if (_normalized(_addressController.text).isEmpty) {
        return l10n.profileAddressRequired;
      }
      final phone = _normalized(_phoneController.text);
      if (phone.isEmpty || !_phoneRegExp.hasMatch(phone)) {
        return l10n.profilePhoneRequired;
      }
      final email = _normalized(_emailController.text);
      if (email.isEmpty || !_emailRegExp.hasMatch(email)) {
        return l10n.profileEmailRequired;
      }
      return null;
    }
    if (_documentPhotoPath == null || _documentPhotoPath!.trim().isEmpty) {
      return l10n.profileDocumentPhotoRequired;
    }
    return null;
  }

  Future<void> _goNextStep() async {
    final message = _validateStep(_stepIndex, context);
    if (message != null) {
      await _showValidationMessage(message);
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _stepIndex = (_stepIndex + 1).clamp(0, 2);
    });
  }

  void _goPrevStep() {
    if (_stepIndex == 0) {
      return;
    }
    setState(() {
      _stepIndex -= 1;
    });
  }

  Future<void> _pickDocumentPhoto(ProfileDocumentImageSource source) async {
    if (_isPickingPhoto) {
      return;
    }
    setState(() {
      _isPickingPhoto = true;
    });
    try {
      final result = await ref
          .read(profileDocumentImagePickerProvider)
          .pick(source);
      if (!mounted) {
        return;
      }
      final path = await _resolvePickedImagePath(result, source);
      if (path == null || path.trim().isEmpty || !mounted) {
        return;
      }
      setState(() {
        _documentPhotoPath = path;
      });
    } catch (_) {
      if (mounted) {
        await _showValidationMessage(context.l10n.profileDocumentPickFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingPhoto = false;
        });
      }
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
        await _showValidationMessage(
          source == ProfileDocumentImageSource.camera
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
      case ProfileDocumentImagePickStatus.sizeLimitExceeded:
        await _showValidationMessage(context.l10n.profileImageSizeTooLarge);
        return null;
      case ProfileDocumentImagePickStatus.failed:
        await _showValidationMessage(context.l10n.profileDocumentPickFailed);
        return null;
    }
  }

  Future<void> _openDocumentPhotoActions() {
    final l10n = context.l10n;
    return AppBottomSheet.showAdaptive<void>(
      context: context,
      builder: (BuildContext sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              l10n.profileDocumentPhotoLabel,
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: UiTokens.spacing12),
            _BottomSheetActionTile(
              label: l10n.profileDocumentTakePhoto,
              icon: Icons.photo_camera_outlined,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickDocumentPhoto(ProfileDocumentImageSource.camera);
              },
            ),
            const SizedBox(height: UiTokens.spacing8),
            _BottomSheetActionTile(
              label: l10n.profileDocumentPickFromGallery,
              icon: Icons.photo_library_outlined,
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickDocumentPhoto(ProfileDocumentImageSource.gallery);
              },
            ),
            if (_documentPhotoPath != null &&
                _documentPhotoPath!.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: UiTokens.spacing8),
              _BottomSheetActionTile(
                label: l10n.profileDocumentRemovePhoto,
                icon: Icons.delete_outline_rounded,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _documentPhotoPath = null;
                  });
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final validationMessage =
        _validateStep(0, context) ??
        _validateStep(1, context) ??
        _validateStep(2, context);
    if (validationMessage != null) {
      await _showValidationMessage(validationMessage);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final profile = _buildDraft();
    await ref.read(saveMemberProfileDetailsUseCaseProvider).call(profile);
    ref.invalidate(memberProfileDetailsProvider);
    ref.invalidate(isMemberProfileCompletedProvider);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
      _lastUpdatedAt = profile.lastUpdatedAt;
      _lastSkippedAt = profile.lastSkippedAt;
    });

    if (widget.isOnboarding) {
      await AppDialogs.showAdaptiveAlert<void>(
        context: context,
        title: context.l10n.profileSavedTitle,
        message: context.l10n.profileSavedAndContinueLoginMessage,
        actions: <AppDialogAction<void>>[
          AppDialogAction<void>(
            label: context.l10n.commonOk,
            isDefaultAction: true,
          ),
        ],
      );
      if (!mounted) {
        return;
      }
      context.go(widget.nextRoute ?? '/login');
      return;
    }

    AppNotice.show(context, message: context.l10n.profileSavedSnackbar);
  }

  Future<void> _skipForNow() async {
    final profile = _buildDraft(lastSkippedAtOverride: DateTime.now().toUtc());
    await ref.read(saveMemberProfileDetailsUseCaseProvider).call(profile);
    await ref
        .read(markMemberProfileSkippedUseCaseProvider)
        .call(current: profile);
    ref.invalidate(memberProfileDetailsProvider);
    ref.invalidate(isMemberProfileCompletedProvider);
    if (!mounted) {
      return;
    }
    context.go(widget.nextRoute ?? '/login');
  }

  List<_ProfileStepItem> _buildSteps(BuildContext context) {
    final l10n = context.l10n;
    return <_ProfileStepItem>[
      _ProfileStepItem(
        title: l10n.profileStepName,
        subtitle: l10n.profileStepNameSubtitle,
      ),
      _ProfileStepItem(
        title: l10n.profileStepContact,
        subtitle: l10n.profileStepContactSubtitle,
      ),
      _ProfileStepItem(
        title: l10n.profileStepDocument,
        subtitle: l10n.profileStepDocumentSubtitle,
      ),
    ];
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_stepIndex) {
      case 0:
        return _buildNameStep(context);
      case 1:
        return _buildContactStep(context);
      case 2:
        return _buildDocumentStep(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildNameStep(BuildContext context) {
    final l10n = context.l10n;
    return SurfacePanelCard(
      title: l10n.profileStepName,
      subtitle: l10n.profileStepNameSubtitle,
      child: Column(
        children: <Widget>[
          _ProfileTextField(
            key: const Key('profile_family_name_input'),
            controller: _familyNameController,
            labelText: l10n.profileFamilyNameLabel,
            hintText: l10n.profileFamilyNameHint,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: UiTokens.spacing12),
          _ProfileTextField(
            key: const Key('profile_given_name_input'),
            controller: _givenNameController,
            labelText: l10n.profileGivenNameLabel,
            hintText: l10n.profileGivenNameHint,
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep(BuildContext context) {
    final l10n = context.l10n;
    return SurfacePanelCard(
      title: l10n.profileStepContact,
      subtitle: l10n.profileStepContactSubtitle,
      child: Column(
        children: <Widget>[
          IntlCodePickerField(
            key: const Key('profile_intl_code_picker'),
            selectedIntlCode: _selectedIntlCode,
            onChanged: (String value) {
              setState(() {
                _selectedIntlCode = value;
              });
            },
          ),
          const SizedBox(height: UiTokens.spacing12),
          PhoneTextField(
            controller: _phoneController,
            inputKey: const Key('profile_phone_input'),
            labelText: l10n.profilePhoneLabel,
            hintText: l10n.profilePhoneHint,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: UiTokens.spacing12),
          EmailTextField(
            controller: _emailController,
            inputKey: const Key('profile_email_input'),
            labelText: l10n.profileEmailLabel,
            hintText: l10n.profileEmailHint,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: UiTokens.spacing12),
          _ProfileTextField(
            key: const Key('profile_address_input'),
            controller: _addressController,
            labelText: l10n.profileAddressLabel,
            hintText: l10n.profileAddressHint,
            maxLines: 3,
            minLines: 2,
            keyboardType: TextInputType.streetAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentStep(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hasPhoto =
        _documentPhotoPath != null && _documentPhotoPath!.trim().isNotEmpty;

    return SurfacePanelCard(
      title: l10n.profileStepDocument,
      subtitle: l10n.profileStepDocumentSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            key: const Key('profile_document_photo_card'),
            onTap: _isPickingPhoto ? null : _openDocumentPhotoActions,
            child: Container(
              height: 212,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiTokens.radius20),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.18),
                ),
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.35,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: hasPhoto
                  ? Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.file(
                          File(_documentPhotoPath!),
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: PhotoCountBadge(
                            label: context.l10n.profileDocumentAttachedBadge,
                          ),
                        ),
                      ],
                    )
                  : _EmptyDocumentPhotoPlaceholder(
                      onTap: _openDocumentPhotoActions,
                      isLoading: _isPickingPhoto,
                    ),
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          CompactActionButton(
            key: const Key('profile_document_pick_button'),
            label: hasPhoto
                ? l10n.profileDocumentChangePhoto
                : l10n.profileDocumentAddPhoto,
            onPressed: _isPickingPhoto ? null : _openDocumentPhotoActions,
            isLoading: _isPickingPhoto,
            width: double.infinity,
          ),
          const SizedBox(height: UiTokens.spacing8),
          Text(l10n.profileDocumentHint, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = _buildSteps(context);
    final draft = _buildDraft();
    final nextButtonLabel = _isLastStep
        ? l10n.profileSaveButton
        : l10n.profileNextStep;

    return Scaffold(
      key: Key(
        widget.isOnboarding
            ? 'member_profile_onboarding_page'
            : 'member_profile_edit_page',
      ),
      appBar: AppBar(
        title: Text(
          widget.isOnboarding
              ? l10n.profileOnboardingTitle
              : l10n.profileEditTitle,
        ),
        actions: <Widget>[
          if (widget.allowSkip)
            TextButton(
              key: const Key('profile_skip_button'),
              onPressed: _isSaving ? null : _skipForNow,
              child: Text(l10n.profileSkipButton),
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SurfacePanelCard(
                      title: widget.isOnboarding
                          ? l10n.profileOnboardingCardTitle
                          : l10n.profileEditCardTitle,
                      subtitle: widget.isOnboarding
                          ? l10n.profileOnboardingCardSubtitle
                          : l10n.profileEditCardSubtitle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _ProfileStepHeader(
                            steps: steps,
                            currentStep: _stepIndex,
                          ),
                          if (_hasLoadedInitialData &&
                              _lastUpdatedAt != null) ...<Widget>[
                            const SizedBox(height: UiTokens.spacing12),
                            Text(
                              l10n.profileLastSavedHint,
                              style: Theme.of(context).appTextTheme.helper,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: KeyedSubtree(
                        key: ValueKey<int>(_stepIndex),
                        child: _buildStepContent(context),
                      ),
                    ),
                    const SizedBox(height: UiTokens.spacing12),
                    if (_isEditMode && !draft.isComplete)
                      SurfacePanelCard(
                        title: l10n.profileIncompleteBannerTitle,
                        subtitle: l10n.profileIncompleteBannerSubtitle,
                        child: Text(
                          l10n.profileIncompleteBannerBody,
                          style: Theme.of(context).appTextTheme.helper,
                        ),
                      ),
                    if (_isEditMode && !draft.isComplete)
                      const SizedBox(height: UiTokens.spacing12),
                    Row(
                      children: <Widget>[
                        if (_stepIndex > 0)
                          Expanded(
                            child: CompactActionButton(
                              key: const Key('profile_back_step_button'),
                              label: l10n.profilePrevStep,
                              onPressed: _isSaving ? null : _goPrevStep,
                              width: double.infinity,
                            ),
                          ),
                        if (_stepIndex > 0)
                          const SizedBox(width: UiTokens.spacing8),
                        Expanded(
                          child: PrimaryCtaButton(
                            key: const Key('profile_next_or_save_button'),
                            label: nextButtonLabel,
                            isLoading: _isSaving,
                            horizontalPadding: 0,
                            onPressed: _isSaving
                                ? null
                                : (_isLastStep ? _saveProfile : _goNextStep),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ProfileStepItem {
  const _ProfileStepItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class _ProfileStepHeader extends StatelessWidget {
  const _ProfileStepHeader({required this.steps, required this.currentStep});

  final List<_ProfileStepItem> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final travelTheme = theme.extension<AppFTKTheme>()!;

    return Column(
      children: List<Widget>.generate(steps.length, (int index) {
        final step = steps[index];
        final isActive = index == currentStep;
        final isDone = index < currentStep;

        return Padding(
          padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isActive || isDone)
                      ? travelTheme.primaryButtonColor
                      : colors.borderSoft,
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check, size: 14, color: colors.onDark)
                      : Text(
                          '${index + 1}',
                          style: appText.inputLabel.copyWith(
                            color: isActive
                                ? colors.onDark
                                : colors.textSecondary,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: UiTokens.spacing8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        step.title,
                        style: appText.inputLabel.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(step.subtitle, style: appText.helper),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isMultiline = maxLines > 1;
    return TextField(
      key: key,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction:
          textInputAction ??
          (isMultiline ? TextInputAction.newline : TextInputAction.next),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: isMultiline,
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UiTokens.radius16),
        ),
      ),
      style: appText.inputText,
    );
  }
}

class _EmptyDocumentPhotoPlaceholder extends StatelessWidget {
  const _EmptyDocumentPhotoPlaceholder({
    required this.onTap,
    required this.isLoading,
  });

  final Future<void> Function() onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final travelTheme = theme.extension<AppFTKTheme>()!;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : Icon(
                      Icons.add_a_photo_outlined,
                      size: 30,
                      color: travelTheme.primaryButtonColor,
                    ),
              const SizedBox(height: UiTokens.spacing8),
              Text(
                l10n.profileDocumentAddPhoto,
                style: appText.inputLabel.copyWith(color: colors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetActionTile extends StatelessWidget {
  const _BottomSheetActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: UiTokens.spacing12,
            vertical: UiTokens.spacing12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiTokens.radius16),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 20),
              const SizedBox(width: UiTokens.spacing8),
              Expanded(child: Text(label, style: appText.body)),
            ],
          ),
        ),
      ),
    );
  }
}
