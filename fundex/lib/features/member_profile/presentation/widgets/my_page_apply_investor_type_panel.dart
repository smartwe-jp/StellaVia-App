import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class MyPageApplyInvestorTypePanel extends StatelessWidget {
  const MyPageApplyInvestorTypePanel({
    super.key,
    required this.label,
    required this.investorCode,
    required this.returnText,
  });

  final String label;
  final String investorCode;
  final String returnText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: appText.tableLabel.copyWith(color: colors.textSecondary),
              ),
            ),
            const SizedBox(width: UiTokens.spacing8),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    investorCode,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: appText.tableValue.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      returnText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: appText.micro.copyWith(
                        color: colors.highlightGold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}
