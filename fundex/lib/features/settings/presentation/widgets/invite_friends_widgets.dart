import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class InviteFriendsContent extends StatelessWidget {
  const InviteFriendsContent({
    super.key,
    required this.inviteCode,
    required this.inviteLink,
    required this.invitedCount,
    required this.heroTitle,
    required this.heroDescription,
    required this.countLabel,
    required this.codeLabel,
    required this.codeDescription,
    required this.linkLabel,
    required this.linkDescription,
    required this.copyLabel,
    required this.shareLabel,
    required this.shareHint,
    required this.onCopyCode,
    required this.onCopyLink,
    required this.onShare,
  });

  final String inviteCode;
  final String inviteLink;
  final int invitedCount;
  final String heroTitle;
  final String heroDescription;
  final String countLabel;
  final String codeLabel;
  final String codeDescription;
  final String linkLabel;
  final String linkDescription;
  final String copyLabel;
  final String shareLabel;
  final String shareHint;
  final VoidCallback onCopyCode;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        _InviteHeroCard(
          title: heroTitle,
          description: heroDescription,
          invitedCount: invitedCount,
          countLabel: countLabel,
        ),
        const SizedBox(height: 20),
        InviteValueCard(
          icon: Icons.confirmation_number_outlined,
          label: codeLabel,
          description: codeDescription,
          value: inviteCode,
          copyLabel: copyLabel,
          onCopy: onCopyCode,
          emphasizeValue: true,
        ),
        const SizedBox(height: 12),
        InviteValueCard(
          icon: Icons.link_rounded,
          label: linkLabel,
          description: linkDescription,
          value: inviteLink,
          copyLabel: copyLabel,
          onCopy: onCopyLink,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_rounded),
            label: Text(shareLabel),
          ),
        ),
        // const SizedBox(height: 10),
        // Text(
        //   shareHint,
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //     color: Theme.of(context).appColors.textSecondary,
        //   ),
        // ),
      ],
    );
  }
}

class InviteFriendsErrorView extends StatelessWidget {
  const InviteFriendsErrorView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.actionIcon,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final IconData actionIcon;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        const SizedBox(height: 72),
        Icon(icon, size: 48, color: colors.textTertiary),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 24),
        Center(
          child: OutlinedButton.icon(
            onPressed: onAction,
            icon: Icon(actionIcon),
            label: Text(actionLabel),
          ),
        ),
      ],
    );
  }
}

class _InviteHeroCard extends StatelessWidget {
  const _InviteHeroCard({
    required this.title,
    required this.description,
    required this.invitedCount,
    required this.countLabel,
  });

  final String title;
  final String description;
  final int invitedCount;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primarySubtle,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.group_add_rounded, color: colors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(UiTokens.radius12),
                border: Border.all(color: colors.surface),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      invitedCount.toString(),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: colors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        countLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InviteValueCard extends StatelessWidget {
  const InviteValueCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.copyLabel,
    required this.onCopy,
    this.emphasizeValue = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final String value;
  final String copyLabel;
  final VoidCallback onCopy;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        //borderRadius: BorderRadius.circular(UiTokens.radius16),
        //border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: 14),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(UiTokens.radius12),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SelectableText(
                        value,
                        style:
                            (emphasizeValue
                                    ? Theme.of(context).textTheme.titleLarge
                                    : Theme.of(context).textTheme.bodyMedium)
                                ?.copyWith(color: colors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onCopy,
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: Text(copyLabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
