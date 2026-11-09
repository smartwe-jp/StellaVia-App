import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_booking_presenter.dart';
import 'hotel_detail_image_placeholder.dart';

class HotelTodayCheckInCard extends StatelessWidget {
  const HotelTodayCheckInCard({
    super.key,
    required this.item,
    required this.presenter,
    this.onTap,
    this.onCheckIn,
  });

  final HotelTodayCheckIn item;
  final HotelBookingPresenter presenter;
  final VoidCallback? onTap;
  final VoidCallback? onCheckIn;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final title = item.hotelName.isNotEmpty
        ? item.hotelName
        : item.buildingName;
    final subtitle = item.hotelAddress.isNotEmpty
        ? item.hotelAddress
        : item.buildingName;
    final checkIn = _dateTimeParts(item.checkIn);
    final checkOut = _dateTimeParts(item.checkOut);
    final amountText = presenter.price(item.totalAmount);
    final canCheckIn = !item.checkedIn;
    final statusBadge = _statusBadge(context, colors);

    return Material(
      color: colors.brandWhite,
      elevation: 3,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(UiTokens.radius28),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UiTokens.radius28),
            border: Border.all(color: colors.borderSoft),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${context.l10n.hotelOrdersOrderNoPrefix}${item.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (statusBadge != null) ...<Widget>[
                      const SizedBox(width: 8),
                      _CheckInStatusBadge(data: statusBadge),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: colors.borderSoft, height: 1),
                const SizedBox(height: 14),
                Row(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _CheckInHotelImage(imageUrl: item.hotelImageUrl),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title.isEmpty
                                ? context.l10n.hotelUnnamedProperty
                                : title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 5),
                          if (subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          if (item.roomNo.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 5),
                            Text(
                              context.l10n.hotelTodayCheckInRoomNo(item.roomNo),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          _CheckInStayDatePanel(
                            checkIn: checkIn,
                            checkOut: checkOut,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            context.l10n.hotelOrdersAmountLabel,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            amountText.isEmpty ? '--' : amountText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: colors.brandAlert,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _CheckInActionButton(
                      label: canCheckIn
                          ? context.l10n.hotelTodayCheckInAction
                          : context.l10n.hotelTodayCheckInCompleted,
                      foregroundColor: canCheckIn
                          ? colors.onDark
                          : colors.textTertiary,
                      backgroundColor: canCheckIn
                          ? colors.brandPrimary
                          : colors.surfaceAlt,
                      borderColor: canCheckIn
                          ? colors.brandPrimary
                          : colors.borderSoft,
                      onTap: canCheckIn ? onCheckIn : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _CheckInStatusBadgeData? _statusBadge(
    BuildContext context,
    AppSemanticColorTheme colors,
  ) {
    if (item.checkedIn) {
      return _CheckInStatusBadgeData(
        label: context.l10n.hotelTodayCheckInCompleted,
        foregroundColor: colors.textSecondary,
        backgroundColor: colors.surfaceAlt,
        borderColor: colors.borderSoft,
      );
    }
    final status = item.orderStatus.trim();
    if (status.isEmpty) {
      return null;
    }
    return _CheckInStatusBadgeData(
      label: status,
      foregroundColor: colors.successForeground,
      backgroundColor: colors.successSubtle,
      borderColor: colors.successBorder,
    );
  }

  _CheckInDateTimeParts _dateTimeParts(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const _CheckInDateTimeParts(date: '--/--', time: '--:--');
    }
    final parsed = DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
    if (parsed != null) {
      return _CheckInDateTimeParts(
        date: DateFormat('MM/dd').format(parsed),
        time: DateFormat('HH:mm').format(parsed),
      );
    }
    final parts = trimmed.split(RegExp(r'\s+'));
    return _CheckInDateTimeParts(
      date: parts.isEmpty ? trimmed : parts.first,
      time: parts.length > 1 ? parts[1] : '--:--',
    );
  }
}

class _CheckInHotelImage extends StatelessWidget {
  const _CheckInHotelImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        child: AppRemoteImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: const HotelDetailImagePlaceholder(),
          errorWidget: const HotelDetailImagePlaceholder(),
        ),
      ),
    );
  }
}

class _CheckInStatusBadgeData {
  const _CheckInStatusBadgeData({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
}

class _CheckInStatusBadge extends StatelessWidget {
  const _CheckInStatusBadge({required this.data});

  final _CheckInStatusBadgeData data;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: data.backgroundColor,
        shape: StadiumBorder(side: BorderSide(color: data.borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          data.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: data.foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CheckInDateTimeParts {
  const _CheckInDateTimeParts({required this.date, required this.time});

  final String date;
  final String time;
}

class _CheckInStayDatePanel extends StatelessWidget {
  const _CheckInStayDatePanel({required this.checkIn, required this.checkOut});

  final _CheckInDateTimeParts checkIn;
  final _CheckInDateTimeParts checkOut;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _CheckInStayDateColumn(
                label: context.l10n.hotelOrdersCheckInLabel,
                parts: checkIn,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: colors.infoForeground,
              ),
            ),
            Expanded(
              child: _CheckInStayDateColumn(
                label: context.l10n.hotelOrdersCheckOutLabel,
                parts: checkOut,
                alignEnd: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckInStayDateColumn extends StatelessWidget {
  const _CheckInStayDateColumn({
    required this.label,
    required this.parts,
    this.alignEnd = false,
  });

  final String label;
  final _CheckInDateTimeParts parts;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textAlign = alignEnd ? TextAlign.end : TextAlign.start;
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          parts.date,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          parts.time,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.brandPrimaryDark,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
      ],
    );
  }
}

class _CheckInActionButton extends StatelessWidget {
  const _CheckInActionButton({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    this.onTap,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: StadiumBorder(side: BorderSide(color: borderColor)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
