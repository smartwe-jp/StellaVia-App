import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../support/settings_contract_text_styles.dart';

class SettingsContractFileTile extends StatelessWidget {
  const SettingsContractFileTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    return AppCard(
      borderColor: colors.borderSoft,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.description_outlined,
              color: colors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: UiTokens.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SettingsContractTextStyles.fileTitle(context),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.appTextTheme.helper.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: UiTokens.spacing8),
          Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
        ],
      ),
    );
  }
}
