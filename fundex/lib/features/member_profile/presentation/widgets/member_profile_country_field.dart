import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/member_profile_countries.dart';

class MemberProfileCountryField extends StatelessWidget {
  const MemberProfileCountryField({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final current = controller.text;
    final countries = memberProfileCountries(context.l10n);
    if (current.isNotEmpty) countries.putIfAbsent(current, () => current);
    return MemberProfileSelectField<String>(
      label: label,
      value: current.isEmpty ? null : current,
      items: [
        for (final country in countries.entries)
          DropdownMenuItem(
            value: country.key,
            child: Text(
              country.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      isRequired: true,
      onChanged: (value) {
        if (value != null) controller.text = value;
      },
    );
  }
}
