import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../providers/settings_contract_documents_providers.dart';
import '../providers/settings_content_providers.dart';
import '../support/settings_contract_default_documents.dart';
import '../support/settings_contract_document_models.dart';
import '../support/settings_operating_company_content.dart';

class SettingsContractDocumentsPage extends ConsumerWidget {
  const SettingsContractDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final projectsAsync = ref.watch(settingsContractProjectsProvider);
    final operatingCompanyAsync = ref.watch(
      settingsOperatingCompanyContentProvider(
        Localizations.localeOf(context).toLanguageTag(),
      ),
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuItemContractList,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: projectsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              l10n.uiErrorRequestFailed,
              textAlign: TextAlign.center,
              style: appText.body.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        data: (List<SettingsContractProject> projects) {
          return operatingCompanyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _ContractProjectList(
              projects: projects,
              emptyMessage: l10n.settingsContractListEmptyState,
            ),
            data: (SettingsOperatingCompanyContent operatingCompanyContent) {
              final displayProjects = <SettingsContractProject>[
                ...projects,
                buildSettingsContractDefaultDocumentsProject(
                  projectName: l10n.settingsOperatingCompanyTitle,
                  operatingCompanyContent: operatingCompanyContent,
                ),
              ];

              return _ContractProjectList(
                projects: displayProjects,
                emptyMessage: l10n.settingsContractListEmptyState,
              );
            },
          );
        },
      ),
    );
  }
}

class _ContractProjectList extends StatelessWidget {
  const _ContractProjectList({
    required this.projects,
    required this.emptyMessage,
  });

  final List<SettingsContractProject> projects;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    if (projects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: appText.body.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      itemCount: projects.length + 1,
      separatorBuilder: (_, int index) {
        if (index == 0) {
          return const SizedBox(height: 18);
        }
        return const SizedBox(height: 12);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Text(
            l10n.settingsContractListDescription,
            style: appText.body.copyWith(color: colors.textSecondary),
          );
        }

        final project = projects[index - 1];
        return _ContractProjectCard(
          project: project,
          onTap: () => context.push(
            '/profile/settings/contracts/${Uri.encodeComponent(project.routeKey)}',
            extra: project,
          ),
        );
      },
    );
  }
}

class _ContractProjectCard extends StatelessWidget {
  const _ContractProjectCard({required this.project, required this.onTap});

  final SettingsContractProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormatter = DateFormat('yyyy.MM.dd', localeTag);
    final latestUpdatedAt = project.latestUpdatedAt;
    final isDefaultProject =
        project.routeKey == settingsContractDefaultProjectId;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(UiTokens.radius20),
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(UiTokens.radius20),
            border: Border.all(color: colors.border),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.06),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primarySubtle,
                    borderRadius: BorderRadius.circular(UiTokens.radius16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.folder_copy_outlined,
                      color: colors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        project.projectName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appText.cardTitle.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Widget>[
                          _ProjectMetaChip(
                            icon: Icons.picture_as_pdf_outlined,
                            label: l10n.settingsContractListPdfCount(
                              project.availablePdfCount,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isDefaultProject
                            ? l10n.settingsContractListDocumentTypeCount(
                                project.availableDocumentCount,
                              )
                            : latestUpdatedAt == null
                            ? l10n.settingsContractListPendingLabel
                            : '${l10n.settingsContractListLatestUpdatedLabel} ${dateFormatter.format(latestUpdatedAt)}',
                        style: appText.bodyMuted.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.textTertiary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectMetaChip extends StatelessWidget {
  const _ProjectMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.borderSoft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 15, color: colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: appText.helper.copyWith(color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
