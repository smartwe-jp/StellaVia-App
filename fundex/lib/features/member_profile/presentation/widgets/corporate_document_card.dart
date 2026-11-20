import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_documents.dart';
import '../support/corporate_document_labels.dart';

class CorporateDocumentCard extends StatelessWidget {
  const CorporateDocumentCard({
    super.key,
    required this.slot,
    required this.documents,
    required this.busy,
    required this.onPick,
    required this.onRetry,
    required this.onDiscard,
    this.error,
  });
  final CorporateDocument slot;
  final CorporateDocuments documents;
  final bool busy;
  final String? error;
  final VoidCallback? onPick, onRetry, onDiscard;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n,
        theme = Theme.of(context),
        colors = theme.colorScheme;
    final file = documents.uploaded[slot], failed = documents.pending[slot];
    final title = documentLabel(l, slot);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colors.primaryContainer.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          foregroundPainter: AppDashedBorderPainter(
            color: colors.primary.withValues(alpha: 0.48),
            radius: 12,
            strokeWidth: 1.5,
            dash: 5,
            gap: 4,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPick,
            child: Container(
              constraints: const BoxConstraints(minHeight: 118),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$title （${slot.optional ? l.registerOptionalBadge : l.corpFormRequired}）',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${slot.extensions.where((ext) => ext != "jpeg").join(" / ").toUpperCase()} · 10 MB',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  if (busy)
                    Text(l.corpDocsUploading)
                  else if (failed != null) ...[
                    Text(failed.filename),
                    Text(
                      l.corpDocsFailed,
                      style: TextStyle(color: colors.error),
                    ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        TextButton(
                          onPressed: onRetry,
                          child: Text(l.commonRetry),
                        ),
                        TextButton(
                          onPressed: onPick,
                          child: Text(l.corpDocsReplace),
                        ),
                        TextButton(
                          onPressed: onDiscard,
                          child: Text(l.corpDocsDiscard),
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      file == null
                          ? l.corpDocsSelect
                          : '${l.profileDocumentAttachedBadge} · ${file.filename}   ${l.corpDocsReplace}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  if (error != null)
                    Text(error!, style: TextStyle(color: colors.error)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
