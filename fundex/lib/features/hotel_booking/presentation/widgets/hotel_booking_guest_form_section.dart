import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_phone_intl_codes.dart';
import 'hotel_booking_section_card.dart';

class HotelBookingGuestFormSection extends StatelessWidget {
  const HotelBookingGuestFormSection({
    super.key,
    required this.title,
    required this.countryCodes,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.onCountryChanged,
    required this.selectedIntlCode,
    required this.onIntlCodeChanged,
    this.isRequired = false,
    this.roomName,
    this.adults,
    this.kids,
    this.maxAdults,
    this.maxKids,
    this.showPhoneFields = true,
    this.showTitle = true,
    this.wrapInCard = true,
    this.priceTipText = '',
    this.enabled = true,
    this.onSavedContactTap,
    this.onAdultsChanged,
    this.onKidsChanged,
  });

  final String title;
  final List<HotelCountryCode> countryCodes;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? selectedCountryCode;
  final ValueChanged<String?> onCountryChanged;
  final String selectedIntlCode;
  final ValueChanged<String> onIntlCodeChanged;
  final bool isRequired;
  final String? roomName;
  final int? adults;
  final int? kids;
  final int? maxAdults;
  final int? maxKids;
  final bool showPhoneFields;
  final bool showTitle;
  final bool wrapInCard;
  final String priceTipText;
  final bool enabled;
  final VoidCallback? onSavedContactTap;
  final ValueChanged<int>? onAdultsChanged;
  final ValueChanged<int>? onKidsChanged;

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);
    if (!wrapInCard) {
      return child;
    }
    return HotelBookingSectionCard(child: child);
  }

  Widget _buildContent(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showTitle) ...<Widget>[
          _SectionHeader(
            title: title,
            titleStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            onSavedContactTap: onSavedContactTap,
          ),
        ],
        if (roomName != null && roomName!.isNotEmpty) ...<Widget>[
          if (showTitle) const SizedBox(height: 6),
          _SectionHeader(
            title: roomName!,
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            onSavedContactTap: showTitle ? null : onSavedContactTap,
          ),
        ],
        const SizedBox(height: 18),
        _NameFields(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          isRequired: isRequired,
          enabled: enabled,
        ),
        const SizedBox(height: 14),
        _CountryDropdown(
          countryCodes: countryCodes,
          selectedCountryCode: selectedCountryCode,
          onChanged: onCountryChanged,
          isRequired: isRequired,
          enabled: enabled,
        ),
        const SizedBox(height: 14),
        HotelBookingTextField(
          controller: emailController,
          hintText: context.l10n.hotelBookingEmail,
          keyboardType: TextInputType.emailAddress,
          enabled: enabled,
        ),
        if (showPhoneFields) ...<Widget>[
          const SizedBox(height: 14),
          _PhoneFields(
            phoneController: phoneController,
            selectedIntlCode: selectedIntlCode,
            onIntlCodeChanged: onIntlCodeChanged,
            isRequired: isRequired,
            enabled: enabled,
          ),
        ],
        if (adults != null && kids != null) ...<Widget>[
          const SizedBox(height: 18),
          if (priceTipText.isNotEmpty) ...<Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                priceTipText,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.danger,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          _CounterRow(
            label: context.l10n.hotelBookingAdults,
            value: adults!,
            requiredMark: true,
            minValue: 1,
            maxValue: maxAdults,
            onChanged: onAdultsChanged,
          ),
          const SizedBox(height: 10),
          _CounterRow(
            label: context.l10n.hotelBookingChildren,
            value: kids!,
            requiredMark: false,
            minValue: 0,
            maxValue: maxKids,
            onChanged: onKidsChanged,
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.titleStyle,
    required this.onSavedContactTap,
  });

  final String title;
  final TextStyle? titleStyle;
  final VoidCallback? onSavedContactTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          ),
        ),
        if (onSavedContactTap != null) ...<Widget>[
          const SizedBox(width: 12),
          TextButton.icon(
            onPressed: onSavedContactTap,
            icon: const Icon(Icons.person_search_outlined, size: 18),
            label: Text(context.l10n.hotelBookingUseSavedContactAction),
            style: TextButton.styleFrom(
              foregroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }
}

class _NameFields extends StatelessWidget {
  const _NameFields({
    required this.firstNameController,
    required this.lastNameController,
    required this.isRequired,
    required this.enabled,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: context.l10n.hotelBookingGuestName,
      requiredMark: isRequired,
      child: Row(
        children: <Widget>[
          Expanded(
            child: HotelBookingTextField(
              controller: lastNameController,
              hintText: context.l10n.hotelBookingLastName,
              enabled: enabled,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HotelBookingTextField(
              controller: firstNameController,
              hintText: context.l10n.hotelBookingFirstName,
              enabled: enabled,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({
    required this.countryCodes,
    required this.selectedCountryCode,
    required this.onChanged,
    required this.isRequired,
    required this.enabled,
  });

  final List<HotelCountryCode> countryCodes;
  final String? selectedCountryCode;
  final ValueChanged<String?> onChanged;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return _LabeledField(
      label: context.l10n.hotelBookingCountryRegion,
      requiredMark: isRequired,
      child: DropdownButtonFormField<String>(
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
        hint: Text(context.l10n.hotelBookingCountryRegion),
        items: countryCodes
            .map(
              (country) => DropdownMenuItem<String>(
                value: country.code,
                child: Text(
                  country.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(growable: false),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  String? get _resolveValue {
    if (selectedCountryCode == null || selectedCountryCode!.isEmpty) {
      return null;
    }
    final exists = countryCodes.any(
      (country) => country.code == selectedCountryCode,
    );
    return exists ? selectedCountryCode : null;
  }
}

class _PhoneFields extends StatelessWidget {
  const _PhoneFields({
    required this.phoneController,
    required this.selectedIntlCode,
    required this.onIntlCodeChanged,
    required this.isRequired,
    required this.enabled,
  });

  final TextEditingController phoneController;
  final String selectedIntlCode;
  final ValueChanged<String> onIntlCodeChanged;
  final bool isRequired;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return _LabeledField(
      label: context.l10n.hotelBookingPhoneNumber,
      requiredMark: isRequired,
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
              onChanged: enabled
                  ? (value) {
                      if (value != null) {
                        onIntlCodeChanged(value);
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: HotelBookingTextField(
              controller: phoneController,
              hintText: context.l10n.hotelBookingPhoneNumber,
              keyboardType: TextInputType.phone,
              enabled: enabled,
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
            text: label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w800,
            ),
            children: <InlineSpan>[
              if (requiredMark)
                TextSpan(
                  text: ' *',
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

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.requiredMark,
    this.minValue = 0,
    this.maxValue,
    this.onChanged,
  });

  final String label;
  final int value;
  final bool requiredMark;
  final int minValue;
  final int? maxValue;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Expanded(
          child: RichText(
            text: TextSpan(
              text: label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
              children: <InlineSpan>[
                if (requiredMark)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: colors.danger),
                  ),
              ],
            ),
          ),
        ),
        _CounterButton(
          icon: Icons.remove_rounded,
          onTap: value > minValue && onChanged != null
              ? () => onChanged!(value - 1)
              : null,
        ),
        SizedBox(
          width: 44,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _CounterButton(
          icon: Icons.add_rounded,
          onTap: onChanged == null || (maxValue != null && value >= maxValue!)
              ? null
              : () => onChanged!(value + 1),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap == null ? colors.surface : colors.primary,
          border: Border.all(
            color: colors.primaryAlt.withValues(alpha: 0.4),
          ),
        ),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            color: onTap == null ? colors.textTertiary : colors.onDark,
          ),
        ),
      ),
    );
  }
}
