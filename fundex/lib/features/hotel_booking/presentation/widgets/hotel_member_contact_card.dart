import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_order_text_styles.dart';

class HotelMemberContactCard extends StatelessWidget {
  const HotelMemberContactCard({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onDelete,
  });

  final HotelMemberContact contact;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final name = contact.displayName.isEmpty ? '-' : contact.displayName;
    final country = contact.nationalityText.isNotEmpty
        ? contact.nationalityText
        : contact.nationality;
    final phone = _phoneText(contact);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.brandPrimaryDark.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: colors.surface.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(UiTokens.radius12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.person, color: colors.infoForeground),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: HotelOrderTextStyles.hotelName(
                                  context,
                                ).copyWith(color: colors.textPrimary),
                              ),
                            ),

                            if (contact.isDefault) ...<Widget>[
                              const SizedBox(width: 10),
                              _DefaultBadge(),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InlineInfo(
                          icon: Icons.public_outlined,
                          value: country.isEmpty ? '-' : country,
                        ),
                        const SizedBox(height: 8),
                        _InlineInfo(icon: Icons.call_outlined, value: phone),
                        const SizedBox(height: 8),
                        _InfoLine(
                          icon: Icons.mail_outline_rounded,
                          value: contact.email.isEmpty ? '-' : contact.email,
                        ),
                      ],
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: colors.textTertiary,
                        iconSize: 20,
                        onPressed: () => onTap(),
                      ),

                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                        ),
                        label: Text(
                          context.l10n.hotelMemberContactsDeleteAction,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.danger,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          minimumSize: const Size(0, 34),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: HotelOrderTextStyles.action(
                            context,
                          ).copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _phoneText(HotelMemberContact contact) {
    final mobile = contact.mobile.trim();
    if (mobile.isEmpty) {
      return '-';
    }
    final intlCode = contact.intlCode.trim();
    if (intlCode.isEmpty) {
      return mobile;
    }
    return '+$intlCode $mobile';
  }
}

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primaryAlt.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          context.l10n.hotelMemberContactsDefault,
          style: HotelOrderTextStyles.label(
            context,
          ).copyWith(color: colors.infoForeground),
        ),
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  const _InlineInfo({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: colors.textTertiary, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HotelOrderTextStyles.value(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: <Widget>[
        Icon(icon, color: colors.textTertiary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HotelOrderTextStyles.value(
              context,
            ).copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
