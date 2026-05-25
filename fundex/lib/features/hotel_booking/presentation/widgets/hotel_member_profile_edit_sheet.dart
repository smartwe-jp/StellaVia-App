import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import 'hotel_booking_section_card.dart';

class HotelMemberProfileTextEditSheet extends StatefulWidget {
  const HotelMemberProfileTextEditSheet({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    this.keyboardType,
  });

  final String title;
  final String label;
  final String initialValue;
  final TextInputType? keyboardType;

  @override
  State<HotelMemberProfileTextEditSheet> createState() =>
      _HotelMemberProfileTextEditSheetState();
}

class _HotelMemberProfileTextEditSheetState
    extends State<HotelMemberProfileTextEditSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelMemberProfileSheetFrame(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          HotelBookingTextField(
            controller: _controller,
            hintText: widget.label,
            keyboardType: widget.keyboardType,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_controller.text.trim()),
              style: FilledButton.styleFrom(
                backgroundColor: colors.brandPrimary,
                foregroundColor: colors.onDark,
              ),
              child: Text(context.l10n.hotelMemberProfileSave),
            ),
          ),
        ],
      ),
    );
  }
}

class HotelMemberProfilePhoneEditResult {
  const HotelMemberProfilePhoneEditResult({
    required this.countryCode,
    required this.phoneNumber,
  });

  final String countryCode;
  final String phoneNumber;
}

class HotelMemberProfilePhoneEditSheet extends StatefulWidget {
  const HotelMemberProfilePhoneEditSheet({
    super.key,
    required this.initialCountryCode,
    required this.initialPhoneNumber,
  });

  final String initialCountryCode;
  final String initialPhoneNumber;

  @override
  State<HotelMemberProfilePhoneEditSheet> createState() =>
      _HotelMemberProfilePhoneEditSheetState();
}

class _HotelMemberProfilePhoneEditSheetState
    extends State<HotelMemberProfilePhoneEditSheet> {
  late final TextEditingController _countryCodeController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _countryCodeController = TextEditingController(
      text: widget.initialCountryCode.trim().isEmpty
          ? '+81'
          : _displayCountryCode(widget.initialCountryCode),
    );
    _phoneNumberController = TextEditingController(
      text: widget.initialPhoneNumber,
    );
  }

  @override
  void dispose() {
    _countryCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelMemberProfileSheetFrame(
      title: context.l10n.hotelMemberProfilePhone,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 104,
                child: HotelBookingTextField(
                  controller: _countryCodeController,
                  hintText: context.l10n.hotelMemberProfilePhoneCountryCode,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: HotelBookingTextField(
                  controller: _phoneNumberController,
                  hintText: context.l10n.hotelMemberProfilePhoneNumber,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(
                HotelMemberProfilePhoneEditResult(
                  countryCode: _countryCodeController.text.trim(),
                  phoneNumber: _phoneNumberController.text.trim(),
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: colors.brandPrimary,
                foregroundColor: colors.onDark,
              ),
              child: Text(context.l10n.hotelMemberProfileSave),
            ),
          ),
        ],
      ),
    );
  }

  String _displayCountryCode(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.startsWith('+')) {
      return trimmed;
    }
    return '+$trimmed';
  }
}

class HotelMemberProfileGenderEditSheet extends StatefulWidget {
  const HotelMemberProfileGenderEditSheet({
    super.key,
    required this.initialGender,
  });

  final int? initialGender;

  @override
  State<HotelMemberProfileGenderEditSheet> createState() =>
      _HotelMemberProfileGenderEditSheetState();
}

class _HotelMemberProfileGenderEditSheetState
    extends State<HotelMemberProfileGenderEditSheet> {
  late int? _selectedGender = widget.initialGender;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return HotelMemberProfileSheetFrame(
      title: context.l10n.hotelMemberProfileGender,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioGroup<int>(
            groupValue: _selectedGender,
            onChanged: (value) => setState(() => _selectedGender = value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile<int>(
                  value: 1,
                  activeColor: colors.brandSecondary,
                  title: Text(context.l10n.hotelMemberProfileGenderMale),
                ),
                RadioListTile<int>(
                  value: 0,
                  activeColor: colors.brandSecondary,
                  title: Text(context.l10n.hotelMemberProfileGenderFemale),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selectedGender == null
                  ? null
                  : () => Navigator.of(context).pop(_selectedGender),
              style: FilledButton.styleFrom(
                backgroundColor: colors.brandPrimary,
                foregroundColor: colors.onDark,
              ),
              child: Text(context.l10n.hotelMemberProfileSave),
            ),
          ),
        ],
      ),
    );
  }
}

class HotelMemberProfileSheetFrame extends StatelessWidget {
  const HotelMemberProfileSheetFrame({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.borderSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const SizedBox(width: 44, height: 5),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}
