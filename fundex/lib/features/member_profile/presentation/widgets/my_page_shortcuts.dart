import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class MyPageShortcuts extends StatelessWidget {
  const MyPageShortcuts({
    super.key,
    required this.onSummary,
    required this.onFunds,
    required this.onTrades,
    required this.onMiles,
    required this.onMember,
    required this.onDocuments,
  });

  final VoidCallback onSummary,
      onFunds,
      onTrades,
      onMiles,
      onMember,
      onDocuments;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          _row([
            _Shortcut('summary', l.myPageShortcutSummary, onSummary),
            _Shortcut('funds', l.myPageShortcutFunds, onFunds),
            _Shortcut('trades', l.secondaryMarketManage, onTrades),
          ]),
          _row([
            _Shortcut('miles', l.myPageShortcutMiles, onMiles),
            _Shortcut('member', l.menuItemEditProfile, onMember),
            _Shortcut('documents', l.myPageShortcutDocuments, onDocuments),
          ]),
        ],
      ),
    );
  }

  Widget _row(List<_Shortcut> items) => IntrinsicHeight(
    child: Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [for (final item in items) Expanded(child: item)],
    ),
  );
}

class _Shortcut extends StatelessWidget {
  const _Shortcut(this.asset, this.label, this.onTap);
  final String asset, label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = onTap == null ? colors.textTertiary : colors.textPrimary;
    final radius = BorderRadius.circular(16);
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: Material(
        color: colors.background,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: colors.borderSoft),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 108),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/mypage-shortcut-$asset.svg',
                    width: 32,
                    height: 32,
                    excludeFromSemantics: true,
                    colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: context.appTextTheme.caption.copyWith(
                      color: foreground,
                      fontSize: 13,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
