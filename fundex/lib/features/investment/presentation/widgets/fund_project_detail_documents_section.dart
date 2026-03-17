import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/fund_project_detail_view_data.dart';

class FundProjectDetailDocumentsSection extends StatelessWidget {
  const FundProjectDetailDocumentsSection({super.key, required this.groups});

  final List<FundProjectDetailDocumentGroupData> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (
          var groupIndex = 0;
          groupIndex < groups.length;
          groupIndex++
        ) ...<Widget>[
          _FundProjectDetailDocumentGroupCard(group: groups[groupIndex]),
          if (groupIndex < groups.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FundProjectDetailDocumentGroupCard extends StatelessWidget {
  const _FundProjectDetailDocumentGroupCard({required this.group});

  final FundProjectDetailDocumentGroupData group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          group.title,
          style: (Theme.of(context).textTheme.titleSmall ?? const TextStyle())
              .copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        if (group.items.isEmpty)
          FundDetailContentCard(
            child: Text(
              context.l10n.fundDetailDocumentUnavailable,
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(color: AppColorTokens.fundexTextSecondary),
            ),
          )
        else
          FundDetailDocumentList(items: group.items),
      ],
    );
  }
}
