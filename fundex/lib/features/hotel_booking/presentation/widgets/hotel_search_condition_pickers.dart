import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

Future<HotelSearchCriteria?> pickHotelStayDates({
  required BuildContext context,
  required HotelSearchCriteria criteria,
}) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final initialStart = _dateOnly(criteria.checkInDate);
  final initialEnd = _normalizedCheckoutDate(
    initialStart,
    criteria.checkOutDate,
  );
  final firstDate = initialStart.isBefore(today) ? initialStart : today;
  final defaultLastDate = today.add(const Duration(days: 365));
  final lastDate = initialEnd.isAfter(defaultLastDate)
      ? initialEnd
      : defaultLastDate;

  final range = await showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
  );
  if (range == null) {
    return null;
  }
  final checkIn = _dateOnly(range.start);
  final checkOut = _normalizedCheckoutDate(checkIn, range.end);
  return criteria.copyWith(checkInDate: checkIn, checkOutDate: checkOut);
}

Future<HotelSearchCriteria?> editHotelGuests({
  required BuildContext context,
  required HotelSearchCriteria criteria,
  bool includeRooms = true,
}) async {
  var adults = criteria.occupancy;
  var children = criteria.kids;
  var rooms = criteria.roomCount;
  final result = await showModalBottomSheet<(int, int, int)>(
    context: context,
    useRootNavigator: true,
    builder: (context) {
      final colors = Theme.of(context).appColors;
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HotelGuestStepperRow(
                    label: context.l10n.hotelGuestAdults,
                    value: adults,
                    min: 1,
                    onChanged: (value) => setSheetState(() => adults = value),
                  ),
                  HotelGuestStepperRow(
                    label: context.l10n.hotelGuestChildren,
                    value: children,
                    min: 0,
                    onChanged: (value) => setSheetState(() => children = value),
                  ),
                  if (includeRooms)
                    HotelGuestStepperRow(
                      label: context.l10n.hotelGuestRooms,
                      value: rooms,
                      min: 1,
                      onChanged: (value) => setSheetState(() => rooms = value),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.brandPrimary,
                        foregroundColor: colors.onDark,
                      ),
                      onPressed: () =>
                          Navigator.of(context).pop((adults, children, rooms)),
                      child: Text(context.l10n.commonApply),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  if (result == null) {
    return null;
  }
  return criteria.copyWith(
    occupancy: result.$1,
    kids: result.$2,
    roomCount: includeRooms ? result.$3 : criteria.roomCount,
  );
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime _normalizedCheckoutDate(DateTime checkIn, DateTime checkOut) {
  final date = _dateOnly(checkOut);
  if (date.isAfter(checkIn)) {
    return date;
  }
  return checkIn.add(const Duration(days: 1));
}

class HotelGuestStepperRow extends StatelessWidget {
  const HotelGuestStepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: value <= min ? null : () => onChanged(value - 1),
            color: colors.brandPrimary,
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.brandPrimaryDark,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: () => onChanged(value + 1),
            color: colors.brandPrimary,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
