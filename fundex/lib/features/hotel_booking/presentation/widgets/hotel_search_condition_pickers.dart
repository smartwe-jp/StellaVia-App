import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

Future<HotelSearchCriteria?> pickHotelStayDates({
  required BuildContext context,
  required HotelSearchCriteria criteria,
  Map<String, Object?> priceCalendarByDate = const <String, Object?>{},
  Set<DateTime> stayBenefitSelectableDates = const <DateTime>{},
  HotelStayDateSelectionMode selectionMode = HotelStayDateSelectionMode.range,
  String? guidanceText,
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

  final range = await showModalBottomSheet<DateTimeRange>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (context) => HotelStayDateRangePicker(
      initialStartDate: initialStart,
      initialEndDate: initialEnd,
      firstDate: firstDate,
      lastDate: lastDate,
      priceCalendarByDate: priceCalendarByDate,
      stayBenefitSelectableDates: stayBenefitSelectableDates,
      selectionMode: selectionMode,
      guidanceText: guidanceText,
    ),
  );
  if (range == null) {
    return null;
  }
  final checkIn = _dateOnly(range.start);
  final checkOut = _normalizedCheckoutDate(checkIn, range.end);
  return criteria.copyWith(checkInDate: checkIn, checkOutDate: checkOut);
}

enum HotelStayDateSelectionMode { range, stayBenefitSingleNight }

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

class HotelStayDateRangePicker extends StatefulWidget {
  const HotelStayDateRangePicker({
    super.key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.firstDate,
    required this.lastDate,
    required this.priceCalendarByDate,
    this.stayBenefitSelectableDates = const <DateTime>{},
    this.selectionMode = HotelStayDateSelectionMode.range,
    this.guidanceText,
  });

  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Map<String, Object?> priceCalendarByDate;
  final Set<DateTime> stayBenefitSelectableDates;
  final HotelStayDateSelectionMode selectionMode;
  final String? guidanceText;

  @override
  State<HotelStayDateRangePicker> createState() =>
      _HotelStayDateRangePickerState();
}

class _HotelStayDateRangePickerState extends State<HotelStayDateRangePicker> {
  late DateTime _visibleMonth;
  late Set<String> _stayBenefitSelectableDateKeys;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final initialStart = _dateOnly(widget.initialStartDate);
    _startDate = initialStart;
    _endDate = _normalizedCheckoutDate(initialStart, widget.initialEndDate);
    _visibleMonth = DateTime(initialStart.year, initialStart.month);
    _stayBenefitSelectableDateKeys = widget.stayBenefitSelectableDates
        .map((date) => _wireDate(_dateOnly(date)))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final localeName = Localizations.localeOf(context).toLanguageTag();
    final monthText = DateFormat.yMMMM(localeName).format(_visibleMonth);
    final canGoPrevious = DateTime(
      _visibleMonth.year,
      _visibleMonth.month - 1,
    ).isAfter(DateTime(widget.firstDate.year, widget.firstDate.month - 1));
    final canGoNext = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
    ).isBefore(DateTime(widget.lastDate.year, widget.lastDate.month + 1));

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: _SelectedDateHeaderItem(
                    label: context.l10n.hotelBookingCheckInDate,
                    value: _formatOptionalFullDate(localeName, _startDate),
                  ),
                ),
                SizedBox(
                  width: 1,
                  height: 46,
                  child: ColoredBox(color: colors.borderSoft),
                ),
                Expanded(
                  child: _SelectedDateHeaderItem(
                    label: context.l10n.hotelBookingCheckOutDate,
                    value: _formatOptionalFullDate(localeName, _endDate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: colors.borderSoft),
            const SizedBox(height: 8),
            if (_shouldShowGuidance) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                widget.guidanceText!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.infoForeground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            Row(
              children: <Widget>[
                IconButton(
                  onPressed: canGoPrevious ? _goPreviousMonth : null,
                  icon: const Icon(Icons.chevron_left_rounded, size: 28),
                ),
                Expanded(
                  child: Text(
                    monthText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: canGoNext ? _goNextMonth : null,
                  icon: const Icon(Icons.chevron_right_rounded, size: 28),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _WeekdayHeader(localeName: localeName),
            const SizedBox(height: 6),
            _MonthGrid(
              visibleMonth: _visibleMonth,
              startDate: _startDate,
              endDate: _endDate,
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              priceCalendarByDate: widget.priceCalendarByDate,
              stayBenefitSelectableDateKeys: _stayBenefitSelectableDateKeys,
              selectionMode: widget.selectionMode,
              onDateTap: _selectDate,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.brandPrimary,
                  foregroundColor: colors.onDark,
                ),
                onPressed: () {
                  final startDate = _startDate;
                  if (startDate == null) {
                    return;
                  }
                  final endDate =
                      _endDate ?? startDate.add(const Duration(days: 1));
                  Navigator.of(
                    context,
                  ).pop(DateTimeRange(start: startDate, end: endDate));
                },
                child: Text(context.l10n.commonApply),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatOptionalFullDate(String localeName, DateTime? date) {
    return date == null
        ? '--'
        : DateFormat('yyyy-MM-dd', localeName).format(date);
  }

  bool get _shouldShowGuidance {
    final text = widget.guidanceText?.trim();
    return widget.selectionMode ==
            HotelStayDateSelectionMode.stayBenefitSingleNight &&
        text != null &&
        text.isNotEmpty;
  }

  void _goPreviousMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    final selected = _dateOnly(date);
    setState(() {
      if (widget.selectionMode ==
          HotelStayDateSelectionMode.stayBenefitSingleNight) {
        _startDate = selected;
        _endDate = selected.add(const Duration(days: 1));
        return;
      }

      final startDate = _startDate;
      final endDate = _endDate;
      if (startDate == null) {
        _startDate = selected;
        _endDate = null;
        return;
      }

      if (endDate != null) {
        _startDate = selected;
        _endDate = null;
        return;
      }

      if (selected.isAfter(startDate)) {
        _endDate = selected;
        return;
      }

      _startDate = selected;
      _endDate = null;
    });
  }
}

class _SelectedDateHeaderItem extends StatelessWidget {
  const _SelectedDateHeaderItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.localeName});

  final String localeName;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final firstWeek = _monthGridDates(DateTime(2026, 2));
    return Row(
      children: firstWeek
          .take(7)
          .map((date) {
            return Expanded(
              child: Text(
                DateFormat.E(localeName).format(date),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colors.brandSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.visibleMonth,
    required this.startDate,
    required this.endDate,
    required this.firstDate,
    required this.lastDate,
    required this.priceCalendarByDate,
    required this.stayBenefitSelectableDateKeys,
    required this.selectionMode,
    required this.onDateTap,
  });

  final DateTime visibleMonth;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Map<String, Object?> priceCalendarByDate;
  final Set<String> stayBenefitSelectableDateKeys;
  final HotelStayDateSelectionMode selectionMode;
  final ValueChanged<DateTime> onDateTap;

  @override
  Widget build(BuildContext context) {
    final dates = _monthGridDates(visibleMonth);
    final rows = <Widget>[];
    for (var row = 0; row < 6; row++) {
      rows.add(
        Row(
          children: dates
              .skip(row * 7)
              .take(7)
              .map(
                (date) => Expanded(
                  child: _CalendarDayCell(
                    date: date,
                    visibleMonth: visibleMonth,
                    startDate: startDate,
                    endDate: endDate,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    priceText: _priceTextFor(date, priceCalendarByDate),
                    isStayBenefitSelectable: stayBenefitSelectableDateKeys
                        .contains(_wireDate(date)),
                    selectionMode: selectionMode,
                    onTap: onDateTap,
                  ),
                ),
              )
              .toList(growable: false),
        ),
      );
    }
    return Column(children: rows);
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.date,
    required this.visibleMonth,
    required this.startDate,
    required this.endDate,
    required this.firstDate,
    required this.lastDate,
    required this.priceText,
    required this.isStayBenefitSelectable,
    required this.selectionMode,
    required this.onTap,
  });

  final DateTime date;
  final DateTime visibleMonth;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String priceText;
  final bool isStayBenefitSelectable;
  final HotelStayDateSelectionMode selectionMode;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dateOnly = _dateOnly(date);
    final isStayBenefitMode =
        selectionMode == HotelStayDateSelectionMode.stayBenefitSingleNight;
    final inDateBounds =
        !dateOnly.isBefore(_dateOnly(firstDate)) &&
        !dateOnly.isAfter(_dateOnly(lastDate));
    final enabled =
        inDateBounds && (!isStayBenefitMode || isStayBenefitSelectable);
    final isCurrentMonth = date.month == visibleMonth.month;
    final isStart = startDate != null && _sameDay(date, startDate!);
    final isEnd = endDate != null && _sameDay(date, endDate!);
    final isSelectedEdge = isStart || isEnd;
    final isInRange =
        startDate != null &&
        endDate != null &&
        date.isAfter(startDate!) &&
        date.isBefore(endDate!);
    final backgroundColor = isSelectedEdge
        ? colors.brandPrimary
        : isInRange
        ? colors.primaryAlt
        : colors.surface;
    final foregroundColor = (isSelectedEdge || isInRange)
        ? colors.onDark
        : isStayBenefitMode && isStayBenefitSelectable && isCurrentMonth
        ? colors.primary
        : enabled && isCurrentMonth
        ? colors.textPrimary
        : colors.textTertiary;
    final priceColor = (isSelectedEdge || isInRange)
        ? colors.onDark
        : enabled && isCurrentMonth
        ? colors.textTertiary
        : colors.textTertiary.withValues(alpha: 0.58);
    final shouldShowStayBenefitRing =
        isStayBenefitMode &&
        isStayBenefitSelectable &&
        isCurrentMonth &&
        !isSelectedEdge &&
        !isInRange;
    final borderRadius = shouldShowStayBenefitRing
        ? BorderRadius.circular(999)
        : _rangeRadius(isStart: isStart, isEnd: isEnd);

    return AspectRatio(
      aspectRatio: 0.92,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
        child: Material(
          color: backgroundColor,
          shape: shouldShowStayBenefitRing
              ? CircleBorder(side: BorderSide(color: colors.primary))
              : null,
          borderRadius: shouldShowStayBenefitRing ? null : borderRadius,
          child: InkWell(
            onTap: enabled ? () => onTap(dateOnly) : null,
            customBorder: shouldShowStayBenefitRing
                ? const CircleBorder()
                : null,
            borderRadius: shouldShowStayBenefitRing ? null : borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    date.day.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: foregroundColor,
                      fontWeight: isSelectedEdge
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    priceText,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: priceColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _rangeRadius({required bool isStart, required bool isEnd}) {
    const radius = Radius.circular(UiTokens.radius8);
    if (isStart && isEnd) {
      return const BorderRadius.all(radius);
    }
    if (isStart) {
      return const BorderRadius.only(topLeft: radius, bottomLeft: radius);
    }
    if (isEnd) {
      return const BorderRadius.only(topRight: radius, bottomRight: radius);
    }
    return BorderRadius.zero;
  }
}

List<DateTime> _monthGridDates(DateTime month) {
  final firstOfMonth = DateTime(month.year, month.month);
  final leadingDays = firstOfMonth.weekday % 7;
  final firstVisible = firstOfMonth.subtract(Duration(days: leadingDays));
  return List<DateTime>.generate(
    42,
    (index) => firstVisible.add(Duration(days: index)),
  );
}

bool _sameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _priceTextFor(DateTime date, Map<String, Object?> priceCalendarByDate) {
  final value = priceCalendarByDate[_wireDate(date)];
  return _priceDisplayText(value);
}

String _priceDisplayText(Object? value) {
  if (value is num) {
    final text = value % 1 == 0 ? value.toInt().toString() : value.toString();
    return '¥$text';
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    final numeric = num.tryParse(trimmed.replaceAll(',', ''));
    if (numeric == null) {
      return trimmed;
    }
    final text = numeric % 1 == 0
        ? numeric.toInt().toString()
        : numeric.toString();
    return '¥$text';
  }
  if (value is Map) {
    for (final key in <String>[
      'price',
      'amount',
      'minPrice',
      'lowestPrice',
      'roomPrice',
      'salePrice',
    ]) {
      final text = _priceDisplayText(value[key]);
      if (text.isNotEmpty) {
        return text;
      }
    }
  }
  return '';
}

String _wireDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}
