import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/settings_operating_company_content.dart';

class SettingsOperatingCompanyPage extends StatefulWidget {
  const SettingsOperatingCompanyPage({super.key});

  @override
  State<SettingsOperatingCompanyPage> createState() =>
      _SettingsOperatingCompanyPageState();
}

class _SettingsOperatingCompanyPageState
    extends State<SettingsOperatingCompanyPage> {
  Future<SettingsOperatingCompanyContent>? _contentFuture;
  String? _loadedLocaleTag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    if (_loadedLocaleTag == localeTag && _contentFuture != null) {
      return;
    }
    _loadedLocaleTag = localeTag;
    _contentFuture = SettingsOperatingCompanyContent.load(localeTag);
  }

  Future<void> _callPhone(BuildContext context, String phoneNumber) async {
    final launched = await launchUrl(
      Uri(scheme: 'tel', path: phoneNumber),
      mode: LaunchMode.externalApplication,
    );
    if (!context.mounted || launched) {
      return;
    }
    AppNotice.show(context, message: context.l10n.settingsContactCallFailed);
  }

  Future<void> _openLink(
    BuildContext context,
    SettingsOperatingCompanyLink link,
  ) async {
    final l10n = context.l10n;
    final trimmed = link.url.trim();
    if (trimmed.isEmpty) {
      AppNotice.show(
        context,
        message: l10n.menuFeatureComingSoon(link.title),
      );
      return;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null) {
      AppNotice.show(
        context,
        message: l10n.webViewerInvalidUrlNotice,
      );
      return;
    }

    if (trimmed.toLowerCase().endsWith('.pdf')) {
      await openAppPdfViewer(
        context,
        url: trimmed,
        title: link.title,
        texts: AppPdfViewerTexts(
          pageTitle: link.title,
          openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
          openExternalLabel: l10n.pdfViewerOpenExternalLabel,
          loadingLabel: l10n.pdfViewerLoadingLabel,
          loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
          retryLabel: l10n.imageViewerRetryLabel,
          invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
          openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
        ),
      );
      return;
    }

    await openAppWebViewer(
      context,
      url: trimmed,
      title: link.title,
      texts: AppWebViewerTexts(
        pageTitle: link.title,
        loadingLabel: l10n.webViewerLoadingLabel,
        loadFailedLabel: l10n.webViewerLoadFailedLabel,
        retryLabel: l10n.imageViewerRetryLabel,
        invalidUrlNotice: l10n.webViewerInvalidUrlNotice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final contentFuture = _contentFuture;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.settingsOperatingCompanyTitle,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: FutureBuilder<SettingsOperatingCompanyContent>(
        future: contentFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<SettingsOperatingCompanyContent> snapshot,
            ) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
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

              final content = snapshot.data!;
              final cardRadius = BorderRadius.circular(UiTokens.radius16);
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: cardRadius,
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: cardRadius,
                      border: Border.all(color: colors.border),
                    ),
                    child: ClipRRect(
                      borderRadius: cardRadius,
                      child: Column(
                        children: <Widget>[
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyTradeNameLabel,
                            value: content.tradeName,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyLicenseNumberLabel,
                            value: content.licenseNumber,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyLicenseTypeLabel,
                            value: content.licenseType,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyRepresentativeLabel,
                            value: content.representative,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyHeadOfficeLabel,
                            value: content.headOffice,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyTelLabel,
                            value: content.tel,
                            valueColor: colors.primary,
                            onTap: () => _callPhone(context, content.tel),
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyEstablishedLabel,
                            value: content.established,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyBusinessLabel,
                            value: content.business,
                          ),
                          _CompanyInfoRow(
                            label: l10n.settingsCompanyManagerLabel,
                            value: content.manager,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.settingsCompanyRelatedLinksTitle,
                    style: appText.sectionTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (
                    int index = 0;
                    index < content.links.length;
                    index += 1
                  ) ...<Widget>[
                    if (index > 0) const SizedBox(height: 8),
                    _CompanyLinkTile(
                      label: content.links[index].title,
                      icon: content.links[index].icon,
                      onTap: () => _openLink(context, content.links[index]),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    content.copyright,
                    textAlign: TextAlign.center,
                    style: appText.meta,
                  ),
                ],
              );
            },
      ),
    );
  }
}

class _CompanyInfoRow extends StatelessWidget {
  const _CompanyInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.onTap,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final VoidCallback? onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final valueWidget = Text(
      value,
      style: appText.bodySemi.copyWith(
        color: valueColor ?? colors.textSecondary,
        height: 1.6,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 104,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                border: Border(right: BorderSide(color: colors.borderSoft)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: appText.bodyStrong.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: onTap == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: valueWidget,
                    )
                  : InkWell(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: valueWidget,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompanyLinkTile extends StatelessWidget {
  const _CompanyLinkTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: InkWell(
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              if (icon.trim().isNotEmpty) ...<Widget>[
                Text(icon),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  label,
                  style: appText.bodySemi.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
