import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import 'hotel_booking_section_card.dart';

class HotelMemberProfileFields extends StatelessWidget {
  const HotelMemberProfileFields({
    super.key,
    required this.profile,
    required this.onEditName,
    required this.onEditEmail,
    required this.onEditPhone,
    required this.onEditGender,
    required this.onEditBirthday,
    required this.onMemberLevelInfoTap,
  });

  final HotelMemberProfile profile;
  final VoidCallback onEditName;
  final VoidCallback onEditEmail;
  final VoidCallback onEditPhone;
  final VoidCallback onEditGender;
  final VoidCallback onEditBirthday;
  final VoidCallback onMemberLevelInfoTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return HotelBookingSectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfileNickname,
            value: profile.memberName,
            editLabel: l10n.hotelMemberProfileEdit,
            unsetLabel: l10n.hotelMemberProfileUnset,
            onEdit: onEditName,
          ),
          const _ProfileDivider(),
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfileEmail,
            value: profile.email,
            editLabel: l10n.hotelMemberProfileEdit,
            unsetLabel: l10n.hotelMemberProfileUnset,
            onEdit: onEditEmail,
          ),
          const _ProfileDivider(),
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfilePhone,
            value: profile.phoneDisplay,
            editLabel: l10n.hotelMemberProfileEdit,
            unsetLabel: l10n.hotelMemberProfileUnset,
            onEdit: onEditPhone,
          ),
          const _ProfileDivider(),
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfileGender,
            value: _genderLabel(context, profile.gender),
            editLabel: l10n.hotelMemberProfileEdit,
            unsetLabel: l10n.hotelMemberProfileUnset,
            onEdit: onEditGender,
          ),
          const _ProfileDivider(),
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfileBirthday,
            value: profile.birthday,
            editLabel: l10n.hotelMemberProfileEdit,
            unsetLabel: l10n.hotelMemberProfileUnset,
            onEdit: onEditBirthday,
          ),
          const _ProfileDivider(),
          HotelMemberProfileFieldRow(
            label: l10n.hotelMemberProfileMemberLevel,
            value: _memberLevelText(context, profile),
            unsetLabel: l10n.hotelMemberProfileUnset,
            trailing: TextButton.icon(
              onPressed: onMemberLevelInfoTap,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.chevron_right_rounded),
              label: Text(l10n.hotelMemberProfileAboutLevel),
            ),
          ),
        ],
      ),
    );
  }

  String _genderLabel(BuildContext context, int? gender) {
    return switch (gender) {
      1 => context.l10n.hotelMemberProfileGenderMale,
      0 => context.l10n.hotelMemberProfileGenderFemale,
      _ => '',
    };
  }

  String _memberLevelText(BuildContext context, HotelMemberProfile profile) {
    final level = profile.membersLevel.trim();
    final discount = profile.discount;
    if (level.isEmpty) {
      return '';
    }
    if (discount == null || discount <= 0) {
      return level;
    }
    return context.l10n.hotelMemberProfileLevelWithDiscount(level, discount);
  }
}

class HotelMemberProfileFieldRow extends StatelessWidget {
  const HotelMemberProfileFieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.unsetLabel,
    this.editLabel,
    this.onEdit,
    this.trailing,
  });

  final String label;
  final String value;
  final String unsetLabel;
  final String? editLabel;
  final VoidCallback? onEdit;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final displayValue = value.trim();
    final hasValue = displayValue.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasValue ? displayValue : unsetLabel,
                  style: textTheme.bodyLarge?.copyWith(
                    color: hasValue
                        ? colors.textSecondary
                        : colors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (trailing != null)
            trailing!
          else if (onEdit != null && editLabel != null)
            SizedBox(
              width: 88,
              height: 44,
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(88, 44),
                  minimumSize: const Size(88, 44),
                  padding: EdgeInsets.zero,
                  side: BorderSide(color: colors.borderSoft),
                  foregroundColor: colors.textPrimary,
                ),
                child: Text(editLabel!),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, thickness: 1, color: colors.borderSoft),
    );
  }
}
