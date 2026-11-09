import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';

enum MilesHistoryKind {
  earned,
  used,
  expired,
  expiring,
  other;

  static final _expiring = RegExp(r'expire.?soon|失効予定|即将失效|即將失效');
  static final _expired = RegExp(r'expire|失効|失效');
  static final _earned = RegExp(r'earn|獲得|获得|grant|add|plus|\+');
  static final _used = RegExp(r'use|消費|消费|redeem|spend|deduct|-');

  static MilesHistoryKind of(HostMilesTransaction row) {
    final type = '${row.typeDescription} ${row.bizType ?? ''}'.toLowerCase();
    if (_expiring.hasMatch(type)) return expiring;
    if (_expired.hasMatch(type)) return expired;
    if (_earned.hasMatch(type)) return earned;
    if (_used.hasMatch(type)) return used;
    final value = row.amount ?? 0;
    return value > 0
        ? earned
        : value < 0
        ? expired
        : other;
  }

  String label(AppLocalizations l) => switch (this) {
    earned => l.myPageMilesHistoryEarn,
    used => l.myPageMilesHistoryUse,
    expired => l.myPageMilesHistoryExpired,
    expiring => l.myPageMilesHistoryExpiring,
    other => l.myPageMilesHistoryOther,
  };

  String amount(num? value, String locale, String unit) {
    final prefix = switch (this) {
      earned => '+',
      used || expired => '-',
      _ => '',
    };
    return '$prefix${NumberFormat.decimalPattern(locale).format((value ?? 0).abs())}$unit';
  }
}

class MyPageMilesHistory {
  MyPageMilesHistory(HostMilesTransactionPage response, int page, int limit) {
    final rows =
        response.rows
            .where((row) => (row.createTime?.millisecondsSinceEpoch ?? 0) > 0)
            .toList()
          ..sort((a, b) => b.createTime!.compareTo(a.createTime!));
    for (final row in rows) {
      final month = DateFormat('yyyy.MM').format(row.createTime!.toLocal());
      groups.putIfAbsent(month, () => []).add(row);
    }
    final count = response.total;
    pages = count != null && count > 0
        ? (count / limit).ceil()
        : page + (response.rows.length >= limit ? 1 : 0);
  }
  final groups = <String, List<HostMilesTransaction>>{};
  late final int pages;
}
