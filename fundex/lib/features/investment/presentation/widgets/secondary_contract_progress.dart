import 'package:company_api_runtime/company_api_runtime.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class SecondaryContractProgress extends StatelessWidget {
  const SecondaryContractProgress({super.key, required this.entries});
  final List<ContractProgressEntry> entries;

  @override
  Widget build(BuildContext context) => Material(
    color: context.appColors.surface,
    child: ExpansionTile(
      initiallyExpanded: true,
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        context.l10n.secondaryContractProgress,
        style: context.appTextTheme.sectionTitle,
      ),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .32,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 0, 16, 8),
            itemCount: entries.length,
            itemBuilder: (context, index) => _ProgressRow(
              entry: entries[index],
              first: index == 0,
              last: index == entries.length - 1,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.entry,
    required this.first,
    required this.last,
  });
  final ContractProgressEntry entry;
  final bool first, last;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = context.appTextTheme;
    final showMessage = entry.actor.isNotEmpty || entry.content.isNotEmpty;
    return Stack(
      children: [
        if (!(first && last))
          Positioned(
            left: 11.5,
            width: 1,
            top: first ? 12 : 0,
            bottom: last ? null : 0,
            height: last ? 12 : null,
            child: ColoredBox(color: c.primaryAlt.withValues(alpha: .28)),
          ),
        Container(
          width: 24,
          height: 24,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c.surfaceAlt,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: first
                  ? c.primary
                  : Color.alphaBlend(
                      c.primaryAlt.withValues(alpha: .5),
                      c.surface,
                    ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(34, 1, 0, last ? 4 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showMessage)
                Text.rich(
                  TextSpan(
                    children: [
                      if (entry.actor.isNotEmpty)
                        TextSpan(text: entry.actor, style: t.bodyStrong),
                      if (entry.actor.isNotEmpty && entry.content.isNotEmpty)
                        const TextSpan(text: '：'),
                      TextSpan(text: entry.content),
                    ],
                  ),
                  style: t.body,
                ),
              if (entry.time.isNotEmpty) ...[
                if (showMessage) const SizedBox(height: 4),
                Text(entry.time, style: t.bodyMuted),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
