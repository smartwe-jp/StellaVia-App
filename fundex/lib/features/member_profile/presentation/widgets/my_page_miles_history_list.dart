import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../support/mypage_miles_history.dart';

class MyPageMilesHistoryList extends StatelessWidget {
  const MyPageMilesHistoryList({super.key, required this.history});
  final MyPageMilesHistory history;
  @override
  Widget build(BuildContext context) {
    if (history.groups.isEmpty) {
      return Center(child: Text(context.l10n.myPageMilesHistoryEmpty));
    }
    return ListView(
      children: [
        for (final group in history.groups.entries) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(group.key, style: context.appTextTheme.bodyStrong),
          ),
          for (final row in group.value) _HistoryRow(row: row),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.row});
  final HostMilesTransaction row;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.appTextTheme;
    final kind = MilesHistoryKind.of(row);
    final date = DateFormat('yyyy.MM.dd');
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      date.format(row.createTime!.toLocal()),
                      style: text.body,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kind == MilesHistoryKind.earned
                            ? colors.brandPrimary
                            : colors.textSecondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        kind.label(context.l10n),
                        style: text.caption.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.dark &&
                                  kind != MilesHistoryKind.earned
                              ? colors.heroStart
                              : colors.onDark,
                        ),
                      ),
                    ),
                  ],
                ),
                if (row.expireTime != null)
                  Text(
                    context.l10n.myPageMilesHistoryExpiryDate(
                      date.format(row.expireTime!.toLocal()),
                    ),
                    style: text.caption.copyWith(color: colors.textSecondary),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                kind.amount(
                  row.amount,
                  locale,
                  context.l10n.myPageMilesHistoryUnit,
                ),
                textAlign: TextAlign.end,
                style: text.numericBody.copyWith(
                  color:
                      kind == MilesHistoryKind.earned ||
                          kind == MilesHistoryKind.expiring
                      ? colors.infoForeground
                      : colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
