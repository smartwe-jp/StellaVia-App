import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../support/secondary_market_trade_support.dart';

class SecondaryMarketMarketplaceDetailPage extends ConsumerWidget {
  const SecondaryMarketMarketplaceDetailPage({
    super.key,
    required this.orderId,
    this.initialRecord,
  });

  final String orderId;
  final MyPageOrderInquiryRecord? initialRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final formatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final asyncMarketplace = ref.watch(secondaryMarketMarketplaceListProvider);
    final record = initialRecord ?? _findRecord(asyncMarketplace.asData?.value);

    return Scaffold(
      appBar: AppNavigationBar(
        title: l10n.homeFreeMarketTitle,
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
          backgroundColor: colors.surface.withValues(alpha: 0),
          foregroundColor: colors.textPrimary,
        ),
      ),
      bottomNavigationBar: record == null
          ? null
          : SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.border)),
                ),
                child: PrimaryCtaButton(
                  label: l10n.secondaryMarketBuyAction,
                  onPressed: canBuySecondaryMarketRecord(record)
                      ? () => context.push(
                          '/free-market/${record.id}/buy',
                          extra: buildSecondaryMarketBuySeed(record),
                        )
                      : null,
                  backgroundColor: colors.primary,
                  shadowColor: colors.primary.withValues(alpha: 0.45),
                  horizontalPadding: 0,
                  threeSideShadow: true,
                ),
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(secondaryMarketMarketplaceListProvider);
          await ref
              .refresh(secondaryMarketMarketplaceListProvider.future)
              .then((_) {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: <Widget>[
            if (asyncMarketplace.isLoading && record == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (record == null)
              _StateCard(
                message: asyncMarketplace.hasError
                    ? l10n.secondaryMarketDetailLoadError
                    : l10n.secondaryMarketDetailUnavailable,
                actionLabel: l10n.fundListRetry,
                onActionTap: () {
                  ref.invalidate(secondaryMarketMarketplaceListProvider);
                },
              )
            else ...<Widget>[
              FundMyPageProjectCard(
                title: record.projectName,
                trailing: _StatusBadge(
                  label: l10n.homeFreeMarketStatusListed,
                  backgroundColor: colors.warningSubtle,
                  foregroundColor: colors.warningAction,
                ),
                rows: <FundLabeledValue>[
                  FundLabeledValue(
                    label: l10n.secondaryMarketOrderTimeLabel,
                    value:
                        _formatDateTime(record.createTime) ??
                        l10n.myPageResultAnnouncementTbd,
                  ),
                  FundLabeledValue(
                    label: l10n.secondaryMarketInvestorTypeLabel,
                    value: _buildInvestorTypeLabel(record),
                  ),
                  FundLabeledValue(
                    label: l10n.secondaryMarketSellUnitsLabel,
                    value:
                        '${record.sellNum ?? 0}${l10n.myPageResaleUnitsSuffix}',
                  ),
                  FundLabeledValue(
                    label: l10n.secondaryMarketSoldUnitsLabel,
                    value:
                        '${record.soldNum ?? 0}${l10n.myPageResaleUnitsSuffix}',
                  ),
                  FundLabeledValue(
                    label: l10n.secondaryMarketRemainingUnitsLabel,
                    value:
                        '${remainingUnitsForSecondaryMarketRecord(record)}${l10n.myPageResaleUnitsSuffix}',
                    valueColor: colors.primary,
                  ),
                  FundLabeledValue(
                    label: l10n.secondaryMarketBuyUnitPriceLabel,
                    value:
                        '${formatter.format(record.price ?? 0)} ${l10n.myPageResaleYenSuffix}',
                  ),
                ],
              ),
              if (record.pdfDocuments.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                FundMyPageProjectCard(
                  title: l10n.secondaryMarketDocumentsTitle,
                  rows: record.pdfDocuments
                      .map(
                        (item) => FundLabeledValue(
                          label: item.description ?? '--',
                          value: item.urls.isEmpty
                              ? l10n.secondaryMarketDocumentPending
                              : item.urls.first.url ??
                                    l10n.secondaryMarketDocumentPending,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
              if (remainingUnitsForSecondaryMarketRecord(record) <=
                  0) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  l10n.secondaryMarketDetailSoldOutMessage,
                  style: appText.bodyMuted.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  MyPageOrderInquiryRecord? _findRecord(
    List<MyPageOrderInquiryRecord>? records,
  ) {
    if (records == null) {
      return null;
    }
    for (final record in records) {
      if (record.id == orderId) {
        return record;
      }
    }
    return null;
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.message, this.actionLabel, this.onActionTap});

  final String message;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final appText = Theme.of(context).appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: appText.bodyMuted.copyWith(color: colors.textSecondary),
            ),
            if (actionLabel != null && onActionTap != null) ...<Widget>[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onActionTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final appText = Theme.of(context).appTextTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: appText.chip.copyWith(color: foregroundColor)),
    );
  }
}

String _buildInvestorTypeLabel(MyPageOrderInquiryRecord record) {
  final code = record.investorType?.investorCode?.trim();
  final ratio = record.investorType?.earningsRadio;
  final ratioText = ratio == null
      ? '--'
      : '${(ratio * 100).toStringAsFixed(ratio * 100 % 1 == 0 ? 0 : 1)}%';
  if (code == null || code.isEmpty) {
    return ratioText;
  }
  return '$code  $ratioText';
}

String? _formatDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  final date = DateTime.tryParse(normalized);
  if (date == null) {
    return null;
  }
  return DateFormat('yyyy/MM/dd HH:mm').format(date);
}
