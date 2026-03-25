import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class KizunarkGradientHeader extends StatelessWidget {
  const KizunarkGradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleLightAssetPath,
    this.titleDarkAssetPath,
  });

  final String title;
  final String subtitle;
  final String? titleLightAssetPath;
  final String? titleDarkAssetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final titleAssetPath = isDark ? titleDarkAssetPath : titleLightAssetPath;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSoft)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (titleAssetPath?.trim().isNotEmpty ?? false)
            Semantics(
              label: title,
              child: ExcludeSemantics(
                child: Image.asset(
                  titleAssetPath!,
                  height: 44,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                ),
              ),
            )
          else
            Text(
              title,
              style: appText.pageTitle.copyWith(
                color: colors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          const SizedBox(height: 2),
          if (!(titleAssetPath?.trim().isNotEmpty ?? false))
          Text(
            subtitle,
            style: appText.meta.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class KizunarkNoticeBanner extends StatelessWidget {
  const KizunarkNoticeBanner({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.communityPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: <Widget>[
            if (icon?.trim().isNotEmpty ?? false) ...<Widget>[
              Text(icon!, style: appText.caption),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                label,
                style: appText.chip.copyWith(color: colors.communityPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KizunarkAvatarBadge extends StatelessWidget {
  const KizunarkAvatarBadge({
    super.key,
    required this.text,
    required this.gradientColors,
    this.size = 32,
    this.fontSize = 13,
  });

  final String text;
  final List<Color> gradientColors;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appText = theme.appTextTheme;
    final appColors = theme.appColors;
    final colors = gradientColors.isEmpty
        ? <Color>[appColors.communityPrimary, appColors.communitySecondary]
        : gradientColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: appText.chip.copyWith(
          color: appColors.onDark,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

class KizunarkComposerCard extends StatefulWidget {
  const KizunarkComposerCard({
    super.key,
    this.leading,
    this.footerLeading,
    required this.controller,
    required this.placeholder,
    required this.postLabel,
    required this.onPostTap,
    this.enabled = true,
    this.onChanged,
  });

  final Widget? leading;
  final Widget? footerLeading;
  final TextEditingController controller;
  final String placeholder;
  final String postLabel;
  final VoidCallback onPostTap;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  State<KizunarkComposerCard> createState() => _KizunarkComposerCardState();
}

class _KizunarkComposerCardState extends State<KizunarkComposerCard> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isFocused = _focusNode.hasFocus;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.leading != null) ...<Widget>[
          widget.leading!,
          const SizedBox(width: 10),
        ],
        Expanded(
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.72,
            child: Container(
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isFocused ? colors.communityPrimary : colors.border,
                  width: isFocused ? 1.8 : 1.5,
                ),
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: widget.controller,
                    enabled: widget.enabled,
                    focusNode: _focusNode,
                    minLines: 2,
                    maxLines: 4,
                    onChanged: widget.onChanged,
                    style: appText.inputText.copyWith(
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: appText.inputText.copyWith(
                        color: colors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: colors.border)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (widget.footerLeading != null)
                          Flexible(child: widget.footerLeading!)
                        else
                          const SizedBox.shrink(),
                        if (widget.footerLeading != null)
                          const SizedBox(width: 12),
                        _KizunarkGradientButton(
                          label: widget.postLabel,
                          onTap: widget.enabled ? widget.onPostTap : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class KizunarkFundReferenceChip extends StatelessWidget {
  const KizunarkFundReferenceChip({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.infoSubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: appText.bodyStrong.copyWith(color: colors.primary),
          ),
        ),
      ),
    );
  }
}

class KizunarkPostCard extends StatelessWidget {
  const KizunarkPostCard({
    super.key,
    required this.avatar,
    required this.displayName,
    required this.accountText,
    this.badgeLabel,
    this.badgeBackgroundColor,
    this.badgeForegroundColor,
    required this.timeLabel,
    required this.body,
    this.fundReferenceChip,
    required this.commentCount,
    required this.onToggleRepliesTap,
    required this.showReplies,
    this.replySection,
    this.trailingAction,
    this.onLongPress,
  });

  final Widget avatar;
  final String displayName;
  final String accountText;
  final String? badgeLabel;
  final Color? badgeBackgroundColor;
  final Color? badgeForegroundColor;
  final String timeLabel;
  final String body;
  final Widget? fundReferenceChip;
  final int commentCount;
  final VoidCallback onToggleRepliesTap;
  final bool showReplies;
  final Widget? replySection;
  final Widget? trailingAction;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  avatar,
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              displayName,
                              style: appText.bodyStrong.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            if ((badgeLabel?.isNotEmpty ?? false))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      badgeBackgroundColor ??
                                      colors.communityPrimary.withValues(
                                        alpha: 0.12,
                                      ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  badgeLabel!,
                                  style: appText.micro.copyWith(
                                    color:
                                        badgeForegroundColor ??
                                        colors.communityPrimary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          accountText,
                          style: appText.meta.copyWith(
                            color: colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        timeLabel,
                        style: appText.meta.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                      if (trailingAction != null) ...<Widget>[
                        const SizedBox(width: 2),
                        trailingAction!,
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: appText.inputText.copyWith(
                  color: colors.textPrimary,
                  height: 1.62,
                ),
              ),
              if (fundReferenceChip != null) ...<Widget>[
                const SizedBox(height: 10),
                fundReferenceChip!,
              ],
              const SizedBox(height: 10),
              Divider(height: 1, color: colors.border),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: onToggleRepliesTap,
                style: TextButton.styleFrom(
                  foregroundColor: colors.textTertiary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                label: Text(
                  '$commentCount',
                  style: appText.caption.copyWith(color: colors.textTertiary),
                ),
              ),
              if (showReplies && replySection != null) ...<Widget>[
                const SizedBox(height: 8),
                Divider(height: 1, color: colors.border),
                const SizedBox(height: 10),
                replySection!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KizunarkReplyTile extends StatelessWidget {
  const KizunarkReplyTile({
    super.key,
    required this.avatar,
    required this.displayName,
    required this.timeLabel,
    required this.body,
    this.quoteTitle,
    this.quoteBody,
    this.trailingAction,
    this.onLongPress,
  });

  final Widget avatar;
  final String displayName;
  final String timeLabel;
  final String body;
  final String? quoteTitle;
  final String? quoteBody;
  final Widget? trailingAction;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onLongPress,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              avatar,
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: appText.bodyStrong.copyWith(
                                color: colors.textPrimary,
                              ),
                              children: <InlineSpan>[
                                TextSpan(text: displayName),
                                TextSpan(
                                  text: '   $timeLabel',
                                  style: appText.meta.copyWith(
                                    color: colors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (trailingAction != null) ...<Widget>[
                          const SizedBox(width: 4),
                          trailingAction!,
                        ],
                      ],
                    ),
                    if ((quoteBody?.isNotEmpty ?? false)) ...<Widget>[
                      const SizedBox(height: 6),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.background,
                          border: Border(
                            left: BorderSide(
                              color: colors.communityPrimary,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                quoteTitle ?? '',
                                style: appText.bodyStrong.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                quoteBody!,
                                style: appText.bodyMuted.copyWith(
                                  color: colors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: appText.body.copyWith(
                        color: colors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KizunarkReplyComposer extends StatelessWidget {
  const KizunarkReplyComposer({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.sendLabel,
    required this.onSendTap,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final String placeholder;
  final String sendLabel;
  final VoidCallback onSendTap;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 2,
                onChanged: onChanged,
                style: appText.inputText.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: appText.inputText.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colors.communityPrimary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _KizunarkGradientButton(
              label: sendLabel,
              onTap: enabled ? onSendTap : null,
              horizontalPadding: 12,
              verticalPadding: 8,
              fontSize: 11,
            ),
          ],
        ),
      ),
    );
  }
}

class _KizunarkGradientButton extends StatelessWidget {
  const _KizunarkGradientButton({
    required this.label,
    required this.onTap,
    this.horizontalPadding = 16,
    this.verticalPadding = 6,
    this.fontSize = 12,
  });

  final String label;
  final VoidCallback? onTap;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Opacity(
      opacity: onTap == null ? 0.48 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[colors.communityPrimary, colors.communitySecondary],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Text(
                label,
                style: appText.button.copyWith(
                  color: colors.onDark,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
