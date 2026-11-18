import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../support/hotel_order_text_styles.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';
import '../support/hotel_map_app_picker.dart';
import 'hotel_detail_image_placeholder.dart';

typedef HotelCheckInRoomAction = void Function(String? roomId);

class HotelTodayCheckInDetailContent extends StatelessWidget {
  const HotelTodayCheckInDetailContent({
    super.key,
    required this.detail,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final HotelOrderDetail detail;
  final HotelCheckInRoomAction onCheckIn;
  final HotelCheckInRoomAction onCheckOut;

  @override
  Widget build(BuildContext context) {
    final entries = _entries(detail);
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          sliver: SliverList.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _CheckInRoomDetailCard(
                detail: detail,
                entry: entries[index],
                index: index,
                total: entries.length,
                onCheckIn: onCheckIn,
                onCheckOut: onCheckOut,
              );
            },
          ),
        ),
      ],
    );
  }

  List<_CheckInRoomEntry> _entries(HotelOrderDetail detail) {
    final entries = <_CheckInRoomEntry>[];
    for (final room in detail.rooms) {
      if (room.guests.isEmpty) {
        entries.add(_CheckInRoomEntry(room: room));
        continue;
      }
      for (final guest in room.guests) {
        entries.add(_CheckInRoomEntry(room: room, guest: guest));
      }
    }
    if (entries.isNotEmpty) {
      return entries;
    }
    return <_CheckInRoomEntry>[const _CheckInRoomEntry()];
  }
}

class _CheckInRoomEntry {
  const _CheckInRoomEntry({this.room, this.guest});

  final HotelOrderRoomSummary? room;
  final HotelOrderRoomGuest? guest;
}

enum _CheckInStage { waiting, staying, checkedOut }

class _CheckInRoomDetailCard extends StatelessWidget {
  const _CheckInRoomDetailCard({
    required this.detail,
    required this.entry,
    required this.index,
    required this.total,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final HotelOrderDetail detail;
  final _CheckInRoomEntry entry;
  final int index;
  final int total;
  final HotelCheckInRoomAction onCheckIn;
  final HotelCheckInRoomAction onCheckOut;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final summary = detail.summary;
    final title = summary.hotelName.isNotEmpty
        ? summary.hotelName
        : summary.buildingName;
    final address = detail.address.isNotEmpty
        ? detail.address
        : summary.hotelAddress;
    final imageUrl = _firstNotEmpty(<String>[
      entry.room?.imageUrl ?? '',
      detail.imageUrl,
      summary.hotelImageUrl,
    ]);
    final guest = entry.guest;
    final room = entry.room;
    final roomType = _firstNotEmpty(<String>[
      guest?.roomTypeName ?? '',
      room?.name ?? '',
    ]);
    final guestName = _firstNotEmpty(<String>[
      guest?.name ?? '',
      detail.guestName,
      summary.hotelName,
    ]);
    final guestCount = guest?.guestCount ?? detail.adultCount ?? 1;
    final statusText = _firstNotEmpty(<String>[
      guest?.checkedInText ?? '',
      detail.checkedInText,
    ]);
    final stage = _stageFor(context, guest, detail, statusText);
    final checkInStatus = statusText.isNotEmpty
        ? statusText
        : switch (stage) {
            _CheckInStage.staying => context.l10n.hotelTodayCheckInStaying,
            _CheckInStage.checkedOut =>
              context.l10n.hotelTodayCheckOutCompleted,
            _CheckInStage.waiting => context.l10n.hotelTodayCheckInWaiting,
          };
    final password = _firstNotEmpty(<String>[
      guest?.password ?? '',
      detail.gatePassword,
    ]);
    final roomId = _firstNotEmpty(<String>[guest?.roomId ?? '', detail.roomId]);
    final roomNo = _firstNotEmpty(<String>[guest?.roomNo ?? '', detail.roomNo]);
    final showRoomPassword = stage == _CheckInStage.staying;
    final showAction = stage != _CheckInStage.checkedOut;
    final isCheckOutAction = stage == _CheckInStage.staying;

    return Material(
      color: colors.brandWhite,
      elevation: 2,
      shadowColor: colors.brandPrimaryDark.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(UiTokens.radius20),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _RoomCountBadge(text: '${index + 1}/$total'),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        title.isEmpty
                            ? context.l10n.hotelUnnamedProperty
                            : title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: HotelOrderTextStyles.hotelName(
                          context,
                        ).copyWith(color: colors.textPrimary),
                      ),
                      if (address.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 6),
                        _CheckInDetailAddressLine(
                          address: address,
                          coordinate: _coordinateFor(detail),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(UiTokens.radius12),
              child: AspectRatio(
                aspectRatio: 2.25,
                child: AppRemoteImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: const HotelDetailImagePlaceholder(iconSize: 40),
                  errorWidget: const HotelDetailImagePlaceholder(iconSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInTimeLabel,
              value: _formatDateTime(summary.checkIn),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckOutTimeLabel,
              value: _formatDateTime(summary.checkOut),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInRoomTypeLabel,
              value: roomType,
            ),
            if (roomNo.isNotEmpty)
              _InfoRow(
                label: context.l10n.hotelTodayCheckInRoomNoLabel,
                value: roomNo,
              ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInGuestLabel,
              value: guestName,
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInGuestCountLabel,
              value: guestCount.toString(),
            ),
            _InfoRow(
              label: context.l10n.hotelTodayCheckInStatusLabel,
              value: checkInStatus,
            ),
            if (showRoomPassword)
              _InfoRow(
                label: context.l10n.hotelTodayCheckInRoomPasswordLabel,
                value: password.trim().isEmpty
                    ? context.l10n.hotelTodayCheckInNoData
                    : password,
                emphasize: true,
              ),
            const _WifiInfoRow(),
            if (showAction) ...<Widget>[
              const SizedBox(height: 18),
              _CheckInSubmitButton(
                label: isCheckOutAction
                    ? context.l10n.hotelTodayCheckOutAction
                    : context.l10n.hotelTodayCheckInAction,
                onPressed: () {
                  if (isCheckOutAction) {
                    onCheckOut(roomId);
                    return;
                  }
                  onCheckIn(roomId);
                },
                danger: isCheckOutAction,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return '--';
    }
    final parsed = DateTime.tryParse(trimmed.replaceFirst(' ', 'T'));
    if (parsed == null) {
      return trimmed;
    }
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsed);
  }

  String _firstNotEmpty(List<String> values) {
    for (final value in values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return '';
  }

  FundPropertyCoordinate? _coordinateFor(HotelOrderDetail detail) {
    final latitude = detail.latitude;
    final longitude = detail.longitude;
    if (latitude == null || longitude == null) {
      return null;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    return FundPropertyCoordinate(latitude: latitude, longitude: longitude);
  }

  _CheckInStage _stageFor(
    BuildContext context,
    HotelOrderRoomGuest? guest,
    HotelOrderDetail detail,
    String statusText,
  ) {
    final status = guest?.checkedInStatus ?? detail.checkedInStatus;
    if (status == 1) {
      return _CheckInStage.staying;
    }
    if (status == 2) {
      return _CheckInStage.checkedOut;
    }
    final text = statusText.trim().toLowerCase();
    if (text.isEmpty) {
      return _CheckInStage.waiting;
    }
    final stayingLabels = <String>[
      context.l10n.hotelTodayCheckInStaying,
      '宿泊中',
      '入住中',
      'staying',
      'checked in',
    ];
    if (stayingLabels.any((label) => text.contains(label.toLowerCase()))) {
      return _CheckInStage.staying;
    }
    final checkedOutLabels = <String>[
      context.l10n.hotelTodayCheckOutCompleted,
      'チェックアウト',
      '退房',
      'checked out',
      'checkout',
    ];
    if (checkedOutLabels.any((label) => text.contains(label.toLowerCase()))) {
      return _CheckInStage.checkedOut;
    }
    return _CheckInStage.waiting;
  }
}

class _CheckInDetailAddressLine extends StatelessWidget {
  const _CheckInDetailAddressLine({
    required this.address,
    required this.coordinate,
  });

  final String address;
  final FundPropertyCoordinate? coordinate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return InkWell(
      onTap: () => showHotelMapAppPicker(
        context: context,
        queryLabel: address,
        coordinate: coordinate,
      ),
      borderRadius: BorderRadius.circular(UiTokens.radius8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on_outlined,
              size: 18,
              color: colors.brandSecondary,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                address,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: HotelOrderTextStyles.value(
                  context,
                ).copyWith(color: colors.brandSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCountBadge extends StatelessWidget {
  const _RoomCountBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        child: Text(
          text,
          style: HotelOrderTextStyles.value(
            context,
          ).copyWith(color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: HotelOrderTextStyles.label(context).copyWith(
              color: emphasize ? colors.infoForeground : colors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value.trim().isEmpty ? '--' : value.trim(),
              textAlign: TextAlign.end,
              style: HotelOrderTextStyles.value(context).copyWith(
                color: emphasize ? colors.infoForeground : colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WifiInfoRow extends StatelessWidget {
  const _WifiInfoRow();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              context.l10n.hotelTodayCheckInWifiLabel,
              style: HotelOrderTextStyles.label(
                context,
              ).copyWith(color: colors.textPrimary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              context.l10n.hotelTodayCheckInWifiValue,
              textAlign: TextAlign.end,
              style: HotelOrderTextStyles.value(
                context,
              ).copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckInSubmitButton extends StatelessWidget {
  const _CheckInSubmitButton({
    required this.label,
    required this.onPressed,
    required this.danger,
  });

  final String label;
  final VoidCallback onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return SizedBox(
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: danger ? colors.danger : colors.brandPrimary,
          foregroundColor: colors.onDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiTokens.radius12),
          ),
        ),
        child: Text(
          label,
          style: HotelOrderTextStyles.action(
            context,
          ).copyWith(color: colors.onDark),
        ),
      ),
    );
  }
}
