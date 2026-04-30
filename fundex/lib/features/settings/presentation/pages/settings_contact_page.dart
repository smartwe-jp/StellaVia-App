import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';
import '../../data/datasources/settings_contact_remote_data_source.dart';
import '../providers/settings_contact_providers.dart';
import '../providers/settings_content_providers.dart';

enum _SettingsContactCategory { investment, account, wallet, ekyc, other }

class _SettingsContactDraft {
  const _SettingsContactDraft({
    required this.familyName,
    required this.givenName,
    required this.furiganaFamilyName,
    required this.furiganaGivenName,
    required this.email,
    required this.category,
    required this.message,
  });

  final String familyName;
  final String givenName;
  final String furiganaFamilyName;
  final String furiganaGivenName;
  final String email;
  final _SettingsContactCategory category;
  final String message;

  String get displayName => '$familyName $givenName'.trim();
}

class SettingsContactPage extends ConsumerStatefulWidget {
  const SettingsContactPage({super.key});

  @override
  ConsumerState<SettingsContactPage> createState() =>
      _SettingsContactPageState();
}

class _SettingsContactPageState extends ConsumerState<SettingsContactPage> {
  static const String _fallbackSupportPhoneNumber = '06-6940-4777';
  static const String _fallbackSupportEmail = 'info@stellavia.co.jp';

  late final TextEditingController _familyNameController;
  late final TextEditingController _givenNameController;
  late final TextEditingController _familyNameKanaController;
  late final TextEditingController _givenNameKanaController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  _SettingsContactCategory? _selectedCategory;
  bool _isSubmitting = false;
  bool _didSeedInitialValues = false;
  bool _didSubmitSuccessfully = false;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
    _givenNameController = TextEditingController();
    _familyNameKanaController = TextEditingController();
    _givenNameKanaController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
    for (final controller in _formControllers) {
      controller.addListener(_handleFormInputChanged);
    }
    _loadInitialValues();
  }

  @override
  void dispose() {
    for (final controller in _formControllers) {
      controller.removeListener(_handleFormInputChanged);
    }
    _familyNameController.dispose();
    _givenNameController.dispose();
    _familyNameKanaController.dispose();
    _givenNameKanaController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  List<TextEditingController> get _formControllers => <TextEditingController>[
    _familyNameController,
    _givenNameController,
    _familyNameKanaController,
    _givenNameKanaController,
    _emailController,
    _messageController,
  ];

  void _handleFormInputChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadInitialValues() async {
    final user = await ref.read(currentAuthUserProvider.future).catchError((
      Object _,
    ) {
      return null;
    });
    final profile = await ref
        .read(memberProfileDetailsProvider.future)
        .catchError((Object _) {
          return null;
        });
    if (!mounted || _didSeedInitialValues) {
      return;
    }

    final authKana = _splitName(user?.katakana);
    _familyNameController.text = _firstNonEmpty(<String>[
      profile?.familyName ?? '',
      user?.firstName ?? '',
    ]);
    _givenNameController.text = _firstNonEmpty(<String>[
      profile?.givenName ?? '',
      user?.lastName ?? '',
    ]);
    _familyNameKanaController.text = _firstNonEmpty(<String>[
      profile?.familyNameKana ?? '',
      authKana.$1,
    ]);
    _givenNameKanaController.text = _firstNonEmpty(<String>[
      profile?.givenNameKana ?? '',
      authKana.$2,
    ]);
    _emailController.text = _firstNonEmpty(<String>[
      profile?.email ?? '',
      user?.email ?? '',
    ]);
    _didSeedInitialValues = true;
    setState(() {});
  }

  (String, String) _splitName(String? raw) {
    final parts = (raw ?? '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((String value) => value.trim().isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return ('', '');
    }
    if (parts.length == 1) {
      return (parts.first, '');
    }
    return (parts.first, parts.skip(1).join(' '));
  }

  String _firstNonEmpty(List<String> values) {
    for (final value in values) {
      final normalized = value.trim();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return '';
  }

  bool _isValidEmail(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(normalized);
  }

  String _categoryLabel(_SettingsContactCategory category) {
    final l10n = context.l10n;
    return switch (category) {
      _SettingsContactCategory.investment =>
        l10n.settingsContactCategoryInvestment,
      _SettingsContactCategory.account => l10n.settingsContactCategoryAccount,
      _SettingsContactCategory.wallet => l10n.settingsContactCategoryWallet,
      _SettingsContactCategory.ekyc => l10n.settingsContactCategoryEkyc,
      _SettingsContactCategory.other => l10n.settingsContactCategoryOther,
    };
  }

  _SettingsContactDraft? _validateDraft() {
    if (_isSubmitting) {
      return null;
    }

    final l10n = context.l10n;
    final familyName = _familyNameController.text.trim();
    final givenName = _givenNameController.text.trim();
    final furiganaFamilyName = _familyNameKanaController.text.trim();
    final furiganaGivenName = _givenNameKanaController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (familyName.isEmpty || givenName.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationName);
      return null;
    }
    if (furiganaFamilyName.isEmpty || furiganaGivenName.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationKana);
      return null;
    }
    if (!_isValidEmail(email)) {
      AppNotice.show(context, message: l10n.settingsContactValidationEmail);
      return null;
    }
    final category = _selectedCategory;
    if (category == null) {
      AppNotice.show(context, message: l10n.settingsContactValidationCategory);
      return null;
    }
    if (message.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationMessage);
      return null;
    }

    return _SettingsContactDraft(
      familyName: familyName,
      givenName: givenName,
      furiganaFamilyName: furiganaFamilyName,
      furiganaGivenName: furiganaGivenName,
      email: email,
      category: category,
      message: message,
    );
  }

  Future<void> _confirmAndSubmit() async {
    final draft = _validateDraft();
    if (draft == null) {
      return;
    }

    FocusScope.of(context).unfocus();
    final confirmed = await _showConfirmDialog(draft);
    if (!mounted || confirmed != true) {
      return;
    }

    await _submit(draft);
  }

  Future<bool?> _showConfirmDialog(_SettingsContactDraft draft) {
    final l10n = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.settingsContactConfirmTitle),
          content: _SettingsContactConfirmContent(
            nameLabel: l10n.settingsContactNameLabel,
            emailLabel: l10n.settingsContactEmailLabel,
            categoryLabel: l10n.settingsContactCategoryLabel,
            messageLabel: l10n.settingsContactMessageLabel,
            name: draft.displayName,
            email: draft.email,
            category: _categoryLabel(draft.category),
            message: draft.message,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settingsContactSubmitAction),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submit(_SettingsContactDraft draft) async {
    if (_isSubmitting) {
      return;
    }

    final l10n = context.l10n;
    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(settingsContactRemoteDataSourceProvider)
          .submitContact(
            SettingsContactSubmission(
              familyName: draft.familyName,
              givenName: draft.givenName,
              furiganaFamilyName: draft.furiganaFamilyName,
              furiganaGivenName: draft.furiganaGivenName,
              email: draft.email,
              questionCategory: _categoryLabel(draft.category),
              question: draft.message,
            ),
          );
      if (!mounted) {
        return;
      }
      setState(() {
        _didSubmitSuccessfully = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotice.show(
        context,
        message: resolveAppRequestErrorMessage(
          error,
          l10n.uiErrorRequestFailed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _callSupportPhone(String phoneNumber) async {
    final target = phoneNumber.trim().isEmpty
        ? _fallbackSupportPhoneNumber
        : phoneNumber.trim();
    final launched = await launchUrl(
      Uri(scheme: 'tel', path: target),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) {
      return;
    }
    AppNotice.show(context, message: context.l10n.settingsContactCallFailed);
  }

  Future<void> _sendSupportEmail(String email) async {
    final target = email.trim().isEmpty ? _fallbackSupportEmail : email.trim();
    final launched = await launchUrl(
      Uri(scheme: 'mailto', path: target),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) {
      return;
    }
    AppNotice.show(context, message: context.l10n.settingsCompanyMailFailed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final operatingCompanyContent = ref
        .watch(settingsOperatingCompanyContentProvider(localeTag))
        .asData
        ?.value;
    final supportPhone = _firstNonEmpty(<String>[
      operatingCompanyContent?.tel ?? '',
      _fallbackSupportPhoneNumber,
    ]);
    final supportEmail = _firstNonEmpty(<String>[
      operatingCompanyContent?.email ?? '',
      _fallbackSupportEmail,
    ]);
    final isFormReady = _isFormReady;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsContactTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: _didSubmitSuccessfully
          ? _SettingsContactSuccessView(
              title: l10n.settingsContactSuccessTitle,
              body: l10n.settingsContactSuccessBody,
              backLabel: l10n.settingsContactSuccessBackAction,
              onBack: () => context.go('/home'),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: <Widget>[
                Text(
                  l10n.settingsContactDescription,
                  style: appText.body.copyWith(
                    color: colors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                MemberProfileSegmentedDualTextFieldRow(
                  label: l10n.settingsContactNameLabel,
                  isRequired: true,
                  labelColor: colors.textPrimary,
                  startSegmentLabel: l10n.profileFamilyNameLabel,
                  startController: _familyNameController,
                  startHintText: l10n.profileFamilyNameHint,
                  endSegmentLabel: l10n.profileGivenNameLabel,
                  endController: _givenNameController,
                  endHintText: l10n.profileGivenNameHint,
                ),
                const SizedBox(height: 16),
                MemberProfileSegmentedDualTextFieldRow(
                  label: l10n.settingsContactKanaLabel,
                  isRequired: true,
                  labelColor: colors.textPrimary,
                  startSegmentLabel: l10n.settingsContactKanaFamilySegment,
                  startController: _familyNameKanaController,
                  startHintText: l10n.memberProfileFamilyNameKanaHint,
                  startInputFormatters: <TextInputFormatter>[
                    MemberProfileInputFormatters.katakanaOnly,
                  ],
                  endSegmentLabel: l10n.settingsContactKanaGivenSegment,
                  endController: _givenNameKanaController,
                  endHintText: l10n.memberProfileGivenNameKanaHint,
                  endInputFormatters: <TextInputFormatter>[
                    MemberProfileInputFormatters.katakanaOnly,
                  ],
                ),
                const SizedBox(height: 16),
                MemberProfileTextField(
                  label: l10n.settingsContactEmailLabel,
                  controller: _emailController,
                  hintText: l10n.settingsContactEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  labelColor: colors.textPrimary,
                ),
                const SizedBox(height: 16),
                _ContactCategoryField(
                  label: l10n.settingsContactCategoryLabel,
                  isRequired: true,
                  value: _selectedCategory,
                  placeholder: l10n.settingsContactCategoryPlaceholder,
                  items: _SettingsContactCategory.values,
                  itemLabelBuilder: _categoryLabel,
                  onChanged: (_SettingsContactCategory? value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                MemberProfileTextField(
                  label: l10n.settingsContactMessageLabel,
                  controller: _messageController,
                  hintText: l10n.settingsContactMessageHint,
                  maxLines: 6,
                  isRequired: true,
                  labelColor: colors.textPrimary,
                ),
                const SizedBox(height: 20),
                PrimaryCtaButton(
                  label: l10n.settingsContactConfirmAction,
                  onPressed: _isSubmitting || !isFormReady
                      ? null
                      : _confirmAndSubmit,
                  isLoading: _isSubmitting,
                ),
                const SizedBox(height: 16),
                _ContactSupportTile(
                  title: l10n.settingsContactPhoneSectionTitle,
                  value: supportPhone,
                  helper: l10n.settingsContactPhoneHours,
                  onTap: () => _callSupportPhone(supportPhone),
                ),
                const SizedBox(height: 8),
                _ContactSupportTile(
                  title: l10n.settingsCompanyEmailLabel,
                  value: supportEmail,
                  onTap: () => _sendSupportEmail(supportEmail),
                ),
              ],
            ),
    );
  }

  bool get _isFormReady {
    return _familyNameController.text.trim().isNotEmpty &&
        _givenNameController.text.trim().isNotEmpty &&
        _familyNameKanaController.text.trim().isNotEmpty &&
        _givenNameKanaController.text.trim().isNotEmpty &&
        _isValidEmail(_emailController.text) &&
        _selectedCategory != null &&
        _messageController.text.trim().isNotEmpty;
  }
}

class _SettingsContactSuccessView extends StatelessWidget {
  const _SettingsContactSuccessView({
    required this.title,
    required this.body,
    required this.backLabel,
    required this.onBack,
  });

  final String title;
  final String body;
  final String backLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return SafeArea(
      top: false,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 48, 32, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border.all(color: colors.border, width: 1.5),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: colors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(height: 58),
              Text(
                title,
                textAlign: TextAlign.center,
                style: appText.pageTitle.copyWith(
                  color: colors.textPrimary,
                  height: 1.75,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 42),
              Text(
                body,
                textAlign: TextAlign.center,
                style: appText.body.copyWith(
                  color: colors.textSecondary,
                  height: 2.05,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 54),
              TextButton(
                onPressed: onBack,
                style: TextButton.styleFrom(
                  foregroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: colors.border, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          backLabel,
                          style: appText.bodyStrong.copyWith(
                            color: colors.primary,
                            letterSpacing: 0.08,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.primary,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSupportTile extends StatelessWidget {
  const _ContactSupportTile({
    required this.title,
    required this.value,
    required this.onTap,
    this.helper,
  });

  final String title;
  final String value;
  final String? helper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final helperText = helper?.trim() ?? '';
    return InkWell(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: appText.helper.copyWith(
                color: colors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: appText.bodyStrong.copyWith(color: colors.primary),
            ),
            if (helperText.isNotEmpty) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                helperText,
                style: appText.micro.copyWith(
                  color: colors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsContactConfirmContent extends StatelessWidget {
  const _SettingsContactConfirmContent({
    required this.nameLabel,
    required this.emailLabel,
    required this.categoryLabel,
    required this.messageLabel,
    required this.name,
    required this.email,
    required this.category,
    required this.message,
  });

  final String nameLabel;
  final String emailLabel;
  final String categoryLabel;
  final String messageLabel;
  final String name;
  final String email;
  final String category;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.55,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SettingsContactConfirmRow(label: nameLabel, value: name),
            const SizedBox(height: 12),
            _SettingsContactConfirmRow(label: emailLabel, value: email),
            const SizedBox(height: 12),
            _SettingsContactConfirmRow(label: categoryLabel, value: category),
            const SizedBox(height: 12),
            Text(
              messageLabel,
              style: appText.micro.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 6),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSoft),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  message,
                  style: appText.body.copyWith(
                    color: colors.textPrimary,
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsContactConfirmRow extends StatelessWidget {
  const _SettingsContactConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: appText.micro.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: appText.bodyStrong.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}

class _ContactCategoryField extends StatelessWidget {
  const _ContactCategoryField({
    required this.label,
    required this.isRequired,
    required this.value,
    required this.placeholder,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
  });

  final String label;
  final bool isRequired;
  final _SettingsContactCategory? value;
  final String placeholder;
  final List<_SettingsContactCategory> items;
  final String Function(_SettingsContactCategory value) itemLabelBuilder;
  final ValueChanged<_SettingsContactCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MemberProfileFieldLabel(
          label: label,
          isRequired: isRequired,
          color: colors.textPrimary,
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<_SettingsContactCategory>(
          initialValue: value,
          onChanged: onChanged,
          items: items
              .map(
                (_SettingsContactCategory item) =>
                    DropdownMenuItem<_SettingsContactCategory>(
                      value: item,
                      child: Text(itemLabelBuilder(item)),
                    ),
              )
              .toList(growable: false),
          hint: Text(
            placeholder,
            style: appText.inputText.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.72),
            ),
          ),
          decoration: memberProfileInputDecoration(context: context),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textSecondary,
          ),
          dropdownColor: colors.surface,
          style: appText.inputText.copyWith(color: colors.textPrimary),
          borderRadius: BorderRadius.circular(12),
        ),
      ],
    );
  }
}
