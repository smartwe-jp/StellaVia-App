import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

enum HomeAttractionDetailKind { area, stay, shield }

class HomeAttractionDetailSheet extends StatelessWidget {
  const HomeAttractionDetailSheet({super.key, required this.kind});

  final HomeAttractionDetailKind kind;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(bottom: BorderSide(color: colors.borderSoft)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    l10n.homeAttractionSectionTitle,
                    style: appText.heroSubtitle.copyWith(
                      color: colors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.commonClose,
                      style: appText.button.copyWith(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(4, 18, 4, 0),
              child: switch (kind) {
                HomeAttractionDetailKind.area => _AreaDetailContent(),
                HomeAttractionDetailKind.stay => _StayDetailContent(),
                HomeAttractionDetailKind.shield => _ShieldDetailContent(),
              },
            ),
          ),
          const SizedBox(height: 44),
        ],
      ),
    );
  }
}

class _AreaDetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _AttractionDetailBody(
      icon: Icons.home_outlined,
      title: l10n.homeAttractionAreaTitle,
      titleAccent: false,
      accentText: l10n.homeAttractionAreaBody,
      description: l10n.homeAttractionAreaDetailBody,
    );
  }
}

class _StayDetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _AttractionDetailBody(
      icon: Icons.hotel_outlined,
      title: l10n.homeAttractionStructureTitle,
      titleAccent: false,
      accentText: l10n.homeAttractionStructureBody,
      description: l10n.homeAttractionStructureDetailBody,
    );
  }
}

class _ShieldDetailContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _AttractionDetailBody(
          icon: Icons.shield_outlined,
          title: l10n.homeAttractionFundsTitle,
          titleAccent: true,
          accentText: l10n.homeAttractionFundsBody,
          description: l10n.homeAttractionShieldDetailBody,
          bottomSpacing: UiTokens.spacing20,
        ),
        _ShieldLayerCard(
          label: l10n.homeAttractionShieldFirstLabel,
          body: l10n.homeAttractionShieldFirstBody,
        ),
        const SizedBox(height: UiTokens.spacing12),
        _ShieldLayerCard(
          label: l10n.homeAttractionShieldSecondLabel,
          body: l10n.homeAttractionShieldSecondBody,
        ),
        const SizedBox(height: UiTokens.spacing16),
        Text(
          l10n.homeAttractionShieldFootnote,
          style: appText.caption.copyWith(
            color: colors.textTertiary,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _AttractionDetailBody extends StatelessWidget {
  const _AttractionDetailBody({
    required this.icon,
    required this.title,
    required this.titleAccent,
    required this.accentText,
    required this.description,
    this.bottomSpacing = 0,
  });

  final IconData icon;
  final String title;
  final bool titleAccent;
  final String accentText;
  final String description;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final titleStyle = appText.pageTitle.copyWith(
      color: colors.brandPrimaryDark,
      fontSize: 16,
      height: 1.55,
      fontWeight: FontWeight.w800,
    );
    final accentStyle = titleStyle.copyWith(color: colors.highlightGold);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: title,
                  style: titleAccent ? accentStyle : titleStyle,
                ),
                TextSpan(
                  text: accentText,
                  style: titleAccent ? titleStyle : accentStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: UiTokens.spacing12),
          Text(
            description,
            style: appText.bodyStrong.copyWith(
              color: colors.textSecondary,
              fontSize: 14,
              height: 1.85,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShieldLayerCard extends StatelessWidget {
  const _ShieldLayerCard({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: UiTokens.spacing16,
        vertical: UiTokens.spacing16,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(UiTokens.radius12),
        border: Border.all(color: colors.highlightGold),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.security, size: 24, color: colors.highlightGold),
          const SizedBox(width: UiTokens.spacing12),
          Text(
              label,
              style: appText.pageTitle.copyWith(
                color: colors.highlightGold,
                fontSize: 16,
                height: 1.35,
              ),
            ),
          
          Container(
            width: 1,
            height: 54,
            margin: const EdgeInsets.symmetric(horizontal: UiTokens.spacing12),
            decoration: BoxDecoration(
              color: colors.highlightGold,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Expanded(
            child: Text(
              body,
              style: appText.bodyStrong.copyWith(
                color: colors.textPrimary,
                fontSize: 14,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
