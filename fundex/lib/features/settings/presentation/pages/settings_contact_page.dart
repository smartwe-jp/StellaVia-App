import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../member_profile/presentation/providers/member_profile_providers.dart';

enum _SettingsContactCategory { investment, account, wallet, ekyc, other }

class SettingsContactPage extends ConsumerStatefulWidget {
  const SettingsContactPage({super.key});

  @override
  ConsumerState<SettingsContactPage> createState() =>
      _SettingsContactPageState();
}

class _SettingsContactPageState extends ConsumerState<SettingsContactPage> {
  static const String _supportPhoneNumber = '06-6940-4777';

  late final TextEditingController _familyNameController;
  late final TextEditingController _givenNameController;
  late final TextEditingController _familyNameKanaController;
  late final TextEditingController _givenNameKanaController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  _SettingsContactCategory? _selectedCategory;
  bool _isSubmitting = false;
  bool _didSeedInitialValues = false;

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
    _givenNameController = TextEditingController();
    _familyNameKanaController = TextEditingController();
    _givenNameKanaController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();
    _loadInitialValues();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _givenNameController.dispose();
    _familyNameKanaController.dispose();
    _givenNameKanaController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
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
      user?.lastName ?? '',
    ]);
    _givenNameController.text = _firstNonEmpty(<String>[
      profile?.givenName ?? '',
      user?.firstName ?? '',
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

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final l10n = context.l10n;
    final familyName = _familyNameController.text.trim();
    final givenName = _givenNameController.text.trim();
    final familyNameKana = _familyNameKanaController.text.trim();
    final givenNameKana = _givenNameKanaController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (familyName.isEmpty || givenName.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationName);
      return;
    }
    if (familyNameKana.isEmpty || givenNameKana.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationKana);
      return;
    }
    if (!_isValidEmail(email)) {
      AppNotice.show(context, message: l10n.settingsContactValidationEmail);
      return;
    }
    if (_selectedCategory == null) {
      AppNotice.show(context, message: l10n.settingsContactValidationCategory);
      return;
    }
    if (message.isEmpty) {
      AppNotice.show(context, message: l10n.settingsContactValidationMessage);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future<void>.delayed(Duration.zero);
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedCategory = null;
        _messageController.clear();
      });
      AppNotice.show(context, message: l10n.settingsContactSubmitSuccess);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _callSupportPhone() async {
    final launched = await launchUrl(
      Uri(scheme: 'tel', path: _supportPhoneNumber),
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) {
      return;
    }
    AppNotice.show(context, message: context.l10n.settingsContactCallFailed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsContactTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: ListView(
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
            label: l10n.settingsContactSubmitAction,
            onPressed: _isSubmitting ? null : _submit,
            isLoading: _isSubmitting,
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(UiTokens.radius16),
            onTap: _callSupportPhone,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: BorderRadius.circular(UiTokens.radius16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('📞'),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          l10n.settingsContactPhoneSectionTitle,
                          style: appText.helper.copyWith(
                            color: colors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _supportPhoneNumber,
                          style: appText.bodyStrong.copyWith(
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.settingsContactPhoneHours,
                          style: appText.micro.copyWith(
                            color: colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
