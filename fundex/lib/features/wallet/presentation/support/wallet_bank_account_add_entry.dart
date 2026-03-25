import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

enum WalletBankAccountAddEntry { domestic, overseas }

Future<WalletBankAccountAddEntry?> showWalletBankAccountAddEntrySheet(
  BuildContext context,
) {
  final theme = Theme.of(context);
  final colors = theme.appColors;
  final appText = theme.appTextTheme;
  final l10n = context.l10n;

  return AppBottomSheet.showAdaptive<WalletBankAccountAddEntry>(
    context: context,
    builder: (BuildContext bottomSheetContext) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.walletBankSettingsAddEntrySheetTitle,
            style: appText.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 14),
          _WalletBankAccountEntryButton(
            label: l10n.walletBankSettingsAddDomesticOption,
            onTap: () => Navigator.of(
              bottomSheetContext,
            ).pop(WalletBankAccountAddEntry.domestic),
          ),
          const SizedBox(height: 10),
          _WalletBankAccountEntryButton(
            label: l10n.walletBankSettingsAddOverseasOption,
            onTap: () => Navigator.of(
              bottomSheetContext,
            ).pop(WalletBankAccountAddEntry.overseas),
          ),
        ],
      );
    },
  );
}

String walletBankAccountAddRouteForEntry(WalletBankAccountAddEntry entry) {
  switch (entry) {
    case WalletBankAccountAddEntry.domestic:
      return '/wallet/bank-settings/add';
    case WalletBankAccountAddEntry.overseas:
      return '/wallet/bank-settings/add/overseas';
  }
}

class _WalletBankAccountEntryButton extends StatelessWidget {
  const _WalletBankAccountEntryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  label,
                  style: appText.bodySemi.copyWith(color: colors.textPrimary),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
