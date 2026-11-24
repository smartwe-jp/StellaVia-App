import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/mypage_models.dart';
import 'mypage_section_support.dart';

class MyPageHiwariCardDisplayData {
  const MyPageHiwariCardDisplayData({
    this.explanation,
    this.blocks = const <MyPageHiwariCardBlockData>[],
  });

  final String? explanation;
  final List<MyPageHiwariCardBlockData> blocks;

  bool get isEmpty => blocks.isEmpty;
  bool get isNotEmpty => blocks.isNotEmpty;
}

class MyPageHiwariCardBlockData {
  const MyPageHiwariCardBlockData({this.badgeLabel, required this.rows});

  final String? badgeLabel;
  final List<MyPageHiwariCardRowData> rows;
}

class MyPageHiwariCardRowData {
  const MyPageHiwariCardRowData({required this.label, required this.value});

  final String label;
  final String value;
}

MyPageHiwariCardDisplayData buildMyPageHiwariCardDisplayData(
  AppLocalizations l10n,
  List<MyPageHiwariJob> jobs, {
  required String? operationStart,
}) {
  if (jobs.isEmpty) return const MyPageHiwariCardDisplayData();
  final operationDay = formatDateOrNull(operationStart);
  String period(String? start, String? end) {
    final first = formatDateOrNull(start);
    final last = formatDateOrNull(end);
    final missing = l10n.myPageHiwariMissingValue;
    if (first == null && last == null) return missing;
    return l10n.myPageHiwariPeriodRange(first ?? missing, last ?? missing);
  }

  return MyPageHiwariCardDisplayData(
    explanation: l10n.myPageHiwariPaymentExplanation,
    blocks: jobs
        .map((job) {
          final start = formatDateOrNull(job.startDate);
          final isTransfer = job.processId != job.fromProcessId;
          String? badge;
          var dateLabel = l10n.myPageHiwariRevenueBaseDate;
          if (isTransfer) {
            badge = l10n.myPageHiwariTransfer;
          } else if (operationDay != null && start != null) {
            if (start.compareTo(operationDay) < 0) {
              badge = l10n.myPageHiwariDeposit;
            } else {
              badge = l10n.myPageHiwariContract;
              dateLabel = l10n.myPageHiwariContractDate;
            }
          }
          return MyPageHiwariCardBlockData(
            badgeLabel: badge,
            rows: [
              MyPageHiwariCardRowData(
                label: l10n.myPageHiwariCalculationPeriod,
                value: period(job.startDate, job.endDate),
              ),
              MyPageHiwariCardRowData(
                label: l10n.myPageHiwariDistributionPeriod,
                value: period(job.headStartDate, job.headEndDate),
              ),
              MyPageHiwariCardRowData(
                label: l10n.myPageHiwariEffectiveDays,
                value: job.num?.toString() ?? l10n.myPageHiwariMissingValue,
              ),
              MyPageHiwariCardRowData(
                label: dateLabel,
                value: start ?? l10n.myPageHiwariMissingValue,
              ),
            ],
          );
        })
        .toList(growable: false),
  );
}
