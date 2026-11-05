import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../support/secondary_market_status.dart';

class SecondaryMarketApplicationCard extends StatelessWidget {
  const SecondaryMarketApplicationCard({
    super.key,
    required this.record,
    this.onTap,
    this.onCancel,
  });
  final MyPageApplyRecord record;
  final VoidCallback? onTap, onCancel;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final money = NumberFormat.currency(symbol: '¥', decimalDigits: 0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: onTap,
              title: Text(record.projectName, style: context.appTextTheme.body),
              subtitle: Text(record.processId ?? '--'),
              trailing: onTap == null ? null : const Icon(Icons.chevron_right),
            ),
            Text(
              secondaryApplicationStatus(l, record.status),
              style: context.appTextTheme.sectionTitle,
            ),
            const SizedBox(height: 8),
            Text('${l.secondaryMarketBuyUnitsLabel}: ${record.applyNum ?? 0}'),
            Text(
              '${l.secondaryMarketBuyTotalAmountLabel}: ${record.applyMoney == null ? '--' : money.format(record.applyMoney)}',
            ),
            Text(
              '${l.secondaryMarketContract}: ${secondaryContractStatus(l, record.ecStatus)}',
            ),
            if (record.ecUserTodo == true)
              Text(
                l.secondaryMarketContractTodo,
                style: context.appTextTheme.body.copyWith(
                  color: context.appColors.primary,
                ),
              ),
            if (onCancel != null)
              TextButton(
                onPressed: onCancel,
                child: Text(l.secondaryMarketCancelApplication),
              ),
          ],
        ),
      ),
    );
  }
}

class SecondaryMarketListingCard extends StatelessWidget {
  const SecondaryMarketListingCard({
    super.key,
    required this.record,
    required this.onTap,
    this.onCancel,
  });
  final MyPageOrderInquiryRecord record;
  final VoidCallback? onTap, onCancel;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: onTap,
              title: Text(record.projectName),
              subtitle: Text(record.id ?? '--'),
              trailing: const Icon(Icons.chevron_right),
            ),
            Text(
              record.status?.toUpperCase() == 'VALID'
                  ? l.secondaryMarketListingValid
                  : l.secondaryMarketListingInvalid,
            ),
            Text(
              '${l.secondaryMarketSoldUnitsLabel}: ${record.soldNum ?? 0} / ${record.sellNum ?? 0}',
            ),
            Text(
              '${l.myPageResaleUnitPriceLabel}: ${record.price == null ? '--' : NumberFormat.currency(symbol: '¥', decimalDigits: 0).format(record.price)}',
            ),
            if (onCancel != null)
              TextButton(
                onPressed: onCancel,
                child: Text(l.secondaryMarketCancelListing),
              ),
          ],
        ),
      ),
    );
  }
}
