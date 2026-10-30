import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../providers/hotel_booking_providers.dart';
import '../support/hotel_phone_intl_codes.dart';
import 'hotel_booking_section_card.dart';

class HotelMemberContactFormPage extends ConsumerStatefulWidget {
  const HotelMemberContactFormPage({super.key, this.contact});

  final HotelMemberContact? contact;

  @override
  ConsumerState<HotelMemberContactFormPage> createState() =>
      _HotelMemberContactFormPageState();
}

class _HotelMemberContactFormPageState
    extends ConsumerState<HotelMemberContactFormPage> {
  late final TextEditingController _lastNameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late String _intlCode;
  late String? _nationality;
  late bool _isDefault;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final contact = widget.contact;
    _lastNameController = TextEditingController(text: contact?.lastName ?? '');
    _firstNameController = TextEditingController(
      text: contact?.firstName ?? '',
    );
    _phoneController = TextEditingController(text: contact?.mobile ?? '');
    _emailController = TextEditingController(text: contact?.email ?? '');
    _intlCode = resolveHotelPhoneIntlCode(contact?.intlCode ?? '81');
    _nationality = (contact?.nationality.trim().isEmpty ?? true)
        ? null
        : contact!.nationality.trim();
    _isDefault = contact?.isDefault ?? false;
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final countriesState = ref.watch(hotelCountryCodesProvider);
    return Scaffold(
      appBar: AppNavigationBar(
        title: widget.contact == null
            ? context.l10n.hotelMemberContactsAddAction
            : context.l10n.hotelMemberContactsEditTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.close_rounded,
          onTap: () => Navigator.of(context).maybePop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: <Widget>[
          HotelBookingSectionCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: <Widget>[
                _LabeledField(
                  label: context.l10n.hotelBookingLastName,
                  requiredMark: true,
                  child: HotelBookingTextField(controller: _lastNameController),
                ),
                const SizedBox(height: 18),
                _LabeledField(
                  label: context.l10n.hotelBookingFirstName,
                  requiredMark: true,
                  child: HotelBookingTextField(
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(height: 18),
                _CountryField(
                  countries: _countryItems(
                    countriesState.valueOrNull ?? const [],
                  ),
                  selectedCode: _nationality,
                  isLoading: countriesState.isLoading,
                  onChanged: (value) => setState(() => _nationality = value),
                ),
                const SizedBox(height: 18),
                _PhoneField(
                  intlCode: _intlCode,
                  phoneController: _phoneController,
                  onIntlCodeChanged: (value) =>
                      setState(() => _intlCode = value),
                ),
                const SizedBox(height: 18),
                _LabeledField(
                  label: context.l10n.hotelBookingEmail,
                  requiredMark: true,
                  child: HotelBookingTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          HotelBookingSectionCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    context.l10n.hotelMemberContactsDefault,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Switch(
                  value: _isDefault,
                  activeThumbColor: colors.primary,
                  onChanged: (value) => setState(() => _isDefault = value),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: PrimaryCtaButton(
          label: context.l10n.hotelMemberContactsSaveAction,
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _submit,
          borderRadius: BorderRadius.circular(999),
          backgroundColor: colors.primary,
          shadowColor: colors.primary.withValues(alpha: 0.22),
        ),
      ),
    );
  }

  List<HotelCountryCode> _countryItems(List<HotelCountryCode> countries) {
    final current = widget.contact;
    if (_nationality == null ||
        countries.any((country) => country.code == _nationality)) {
      return countries;
    }
    return <HotelCountryCode>[
      HotelCountryCode(
        code: _nationality!,
        name: current?.nationalityText.trim().isNotEmpty == true
            ? current!.nationalityText
            : _nationality!,
      ),
      ...countries,
    ];
  }

  Future<void> _submit() async {
    final lastName = _lastNameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final nationality = _nationality?.trim() ?? '';
    if (lastName.isEmpty ||
        firstName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        nationality.isEmpty) {
      _showMessage(context.l10n.hotelMemberContactsRequiredMessage);
      return;
    }

    setState(() => _isSaving = true);
    try {
      final source = widget.contact;
      await AppLoadingDialog.run(
        context,
        () => ref.read(saveHotelMemberContactUseCaseProvider)(
          HotelMemberContactDraft(
            id: source?.id,
            memberId: source?.memberId,
            name: source == null ? null : '$lastName $firstName',
            firstName: firstName,
            lastName: lastName,
            email: email,
            intlCode: _intlCode,
            mobile: phone,
            nationality: nationality,
            isDefault: _isDefault,
            dr: source?.dr,
            nationalityText: source?.nationality == nationality
                ? source?.nationalityText
                : null,
          ),
        ),
      );
      if (!mounted) {
        return;
      }
      ref.invalidate(hotelMemberContactsProvider);
      _showMessage(context.l10n.hotelMemberContactsSavedMessage);
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) {
        return;
      }
      _showMessage(context.l10n.hotelMemberContactsSaveFailedMessage);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message) {
    AppNotice.show(context, message: message);
  }
}

class _CountryField extends StatelessWidget {
  const _CountryField({
    required this.countries,
    required this.selectedCode,
    required this.isLoading,
    required this.onChanged,
  });

  final List<HotelCountryCode> countries;
  final String? selectedCode;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return _LabeledField(
      label: context.l10n.hotelBookingCountryRegion,
      requiredMark: false,
      child: DropdownButtonFormField<String>(
        key: ValueKey<String>('country-${countries.length}-$selectedCode'),
        initialValue: _resolveValue,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiTokens.radius8),
            borderSide: BorderSide(color: colors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(UiTokens.radius8),
            borderSide: BorderSide(color: colors.brandSecondary, width: 1.4),
          ),
        ),
        hint: Text(
          isLoading
              ? context.l10n.hotelMemberContactsCountryLoading
              : context.l10n.hotelBookingCountryRegion,
        ),
        items: countries
            .map(
              (country) => DropdownMenuItem<String>(
                value: country.code,
                child: Text(country.name, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(growable: false),
        onChanged: countries.isEmpty ? null : onChanged,
      ),
    );
  }

  String? get _resolveValue {
    if (selectedCode == null || selectedCode!.isEmpty) {
      return null;
    }
    final exists = countries.any((country) => country.code == selectedCode);
    return exists ? selectedCode : null;
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.intlCode,
    required this.phoneController,
    required this.onIntlCodeChanged,
  });

  final String intlCode;
  final TextEditingController phoneController;
  final ValueChanged<String> onIntlCodeChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final selectedIntlCode = resolveHotelPhoneIntlCode(intlCode);
    return _LabeledField(
      label: context.l10n.hotelBookingPhoneNumber,
      requiredMark: false,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 104,
            child: DropdownButtonFormField<String>(
              initialValue: selectedIntlCode,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(UiTokens.radius8),
                  borderSide: BorderSide(color: colors.brandSecondary),
                ),
              ),
              items: hotelPhoneIntlCodes
                  .map(
                    (code) => DropdownMenuItem<String>(
                      value: code,
                      child: Text(code),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  onIntlCodeChanged(value);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HotelBookingTextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    required this.requiredMark,
  });

  final String label;
  final Widget child;
  final bool requiredMark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            children: <TextSpan>[
              TextSpan(text: label),
              if (requiredMark)
                TextSpan(
                  text: '*',
                  style: TextStyle(color: colors.danger),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
