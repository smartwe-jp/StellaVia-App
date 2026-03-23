import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/settings_contract_documents_providers.dart';
import '../support/settings_contract_document_models.dart';

class SettingsContractDocumentDetailPage extends ConsumerWidget {
  const SettingsContractDocumentDetailPage({
    super.key,
    required this.projectKey,
    this.initialProject,
  });

  final String projectKey;
  final SettingsContractProject? initialProject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final projectAsync = ref.watch(settingsContractProjectProvider(projectKey));
    final project = projectAsync.asData?.value ?? initialProject;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsContractDetailTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (project == null && projectAsync.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (project == null && projectAsync.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.uiErrorRequestFailed,
                  textAlign: TextAlign.center,
                  style: appText.body.copyWith(color: colors.textSecondary),
                ),
              ),
            );
          }
          if (project == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.settingsContractDetailMissingProject,
                  textAlign: TextAlign.center,
                  style: appText.body.copyWith(color: colors.textSecondary),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: <Widget>[
              _ProjectHeaderCard(project: project),
              const SizedBox(height: 22),
              Text(
                l10n.settingsContractDetailRelatedFilesTitle,
                style: appText.sectionTitle.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: 12),
              if (project.documents.isEmpty)
                FundDetailContentCard(
                  child: Text(
                    l10n.settingsContractDetailNoPdfAvailable,
                    style: appText.bodyMuted.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                for (
                  int index = 0;
                  index < project.documents.length;
                  index += 1
                )
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == project.documents.length - 1 ? 0 : 16,
                    ),
                    child: _DocumentSection(
                      document: project.documents[index],
                      onOpenPdf: (SettingsContractPdfFile file) => _openPdf(
                        context,
                        title: _resolvePdfTitle(project.documents[index], file),
                        url: file.url!,
                      ),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openPdf(
    BuildContext context, {
    required String title,
    required String url,
  }) {
    final l10n = context.l10n;
    return openAppPdfViewer(
      context,
      url: url,
      title: title,
      texts: AppPdfViewerTexts(
        pageTitle: title,
        openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
        openExternalLabel: l10n.pdfViewerOpenExternalLabel,
        loadingLabel: l10n.pdfViewerLoadingLabel,
        loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
        retryLabel: l10n.imageViewerRetryLabel,
        invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
        openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
      ),
    );
  }

  String _resolvePdfTitle(
    SettingsContractDocument document,
    SettingsContractPdfFile file,
  ) {
    final rawName = (file.name ?? '').trim();
    final normalizedName = rawName.replaceAll('?', '').trim();
    if (normalizedName.isNotEmpty) {
      return rawName;
    }
    return document.description;
  }
}

class _ProjectHeaderCard extends StatelessWidget {
  const _ProjectHeaderCard({required this.project});

  final SettingsContractProject project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            colors.heroStart.withValues(alpha: 0.18),
            colors.heroMiddle.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              project.projectName,
              style: appText.pageTitle.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                _HeaderMetric(
                  icon: Icons.picture_as_pdf_outlined,
                  value: project.availablePdfCount.toString(),
                  label: context.l10n.settingsContractListPdfCount(
                    project.availablePdfCount,
                  ),
                ),
                _HeaderMetric(
                  icon: Icons.library_books_outlined,
                  value: project.documents.length.toString(),
                  label: context.l10n.settingsContractListDocumentTypeCount(
                    project.documents.length,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 132),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(UiTokens.radius16),
          border: Border.all(color: colors.borderSoft),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: colors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      value,
                      style: appText.cardTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appText.helper.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  const _DocumentSection({required this.document, required this.onOpenPdf});

  final SettingsContractDocument document;
  final ValueChanged<SettingsContractPdfFile> onOpenPdf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final availableFiles = document.files
        .where((SettingsContractPdfFile file) => file.hasUrl)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          document.description,
          style: appText.cardTitle.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        if (availableFiles.isEmpty)
          FundDetailContentCard(
            child: Text(
              context.l10n.settingsContractDetailNoPdfAvailable,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
          )
        else
          FundDetailDocumentList(
            items: availableFiles
                .asMap()
                .entries
                .map((entry) {
                  final file = entry.value;
                  return FundDetailDocumentItemData(
                    title: _resolveItemTitle(document, file, entry.key),
                    subtitle: _resolveItemSubtitle(context, file),
                    onTap: () => onOpenPdf(file),
                  );
                })
                .toList(growable: false),
          ),
      ],
    );
  }

  String _resolveItemTitle(
    SettingsContractDocument document,
    SettingsContractPdfFile file,
    int index,
  ) {
    final rawName = (file.name ?? '').trim();
    final normalizedName = rawName.replaceAll('?', '').trim();
    if (normalizedName.isNotEmpty) {
      return rawName;
    }
    if (document.files
            .where((SettingsContractPdfFile item) => item.hasUrl)
            .length <=
        1) {
      return document.description;
    }
    return '${document.description} ${index + 1}';
  }

  String _resolveItemSubtitle(
    BuildContext context,
    SettingsContractPdfFile file,
  ) {
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final timestamp = file.createTimeDateTime;
    if (timestamp == null) {
      return context.l10n.pdfViewerPageTitle;
    }
    final formatter = DateFormat('yyyy.MM.dd HH:mm', localeTag);
    return formatter.format(timestamp);
  }
}
