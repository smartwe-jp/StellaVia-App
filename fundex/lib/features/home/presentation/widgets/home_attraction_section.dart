import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeAttractionSection extends StatelessWidget {
  const HomeAttractionSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<HomeAttractionItemData> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: Theme.of(context).appTextTheme.heroMetricSecondary),
        const SizedBox(height: UiTokens.spacing12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (var index = 0; index < items.length; index++) ...<Widget>[
              Expanded(child: _HomeAttractionCard(data: items[index])),
              if (index < items.length - 1)
                const SizedBox(width: UiTokens.spacing12),
            ],
          ],
        ),
      ],
    );
  }
}

class HomeAttractionItemData {
  const HomeAttractionItemData({
    required this.icon,
    required this.title,
    required this.body,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;
}

class _HomeAttractionCard extends StatelessWidget {
  const _HomeAttractionCard({required this.data});

  final HomeAttractionItemData data;

  String get _headlineText {
    final title = data.title.trim();
    final body = data.body.trim();
    if (body.isEmpty) {
      return title;
    }
    return '$title$body';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final radius = BorderRadius.circular(UiTokens.radius12);

    return Container(
      height: 142,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: radius,
        border: Border.all(color: colors.primarySubtle),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: data.onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(data.icon, size: 32, color: colors.highlightGold),
                ),
                const SizedBox(height: 2),
                Text(
                  _headlineText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: appText.bodyStrong.copyWith(
                    color: colors.textPrimary,
                    height: 1.45,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: colors.brandPrimaryDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
