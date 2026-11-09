import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/mypage_hiwari_card_display.dart';
import 'mypage_active_fund_detail_sections.dart';

class MyPageHiwariInfoCard extends StatelessWidget {
  const MyPageHiwariInfoCard({super.key, required this.data});

  final MyPageHiwariCardDisplayData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return ActiveFundSectionCard(
      title: context.l10n.myPageHiwariInfoTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (data.explanation != null) ...<Widget>[
            Text(
              data.explanation!,
              style: appText.bodyMuted.copyWith(
                color: colors.textSecondary,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 16),
          ],
          for (var index = 0; index < data.blocks.length; index++) ...<Widget>[
            _HiwariInfoBlock(data: data.blocks[index]),
            if (index != data.blocks.length - 1) ...<Widget>[
              const SizedBox(height: 14),
              Divider(height: 1, color: colors.borderSoft),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }
}

class _HiwariInfoBlock extends StatelessWidget {
  const _HiwariInfoBlock({required this.data});

  final MyPageHiwariCardBlockData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (data.badgeLabel != null) ...<Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              borderRadius: BorderRadius.circular(UiTokens.radius8),
              border: Border.all(color: colors.primary.withValues(alpha: 0.48)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                data.badgeLabel!,
                style: appText.chip.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
        for (var index = 0; index < data.rows.length; index++) ...<Widget>[
          _HiwariInfoRow(data: data.rows[index]),
          if (index != data.rows.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _HiwariInfoRow extends StatelessWidget {
  const _HiwariInfoRow({required this.data});

  final MyPageHiwariCardRowData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            data.label,
            style: appText.bodyMuted.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            data.value,
            textAlign: TextAlign.right,
            style: appText.bodyStrong.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
