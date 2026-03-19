import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../support/notification_item_view_data.dart';

class NotificationsListItem extends StatelessWidget {
  const NotificationsListItem({
    super.key,
    required this.item,
    required this.onTap,
    this.isUpdating = false,
    this.showDivider = true,
  });

  final NotificationItemViewData item;
  final VoidCallback onTap;
  final bool isUpdating;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final isDark = theme.brightness == Brightness.dark;
    final isUnread = !item.isRead;
    final title = item.title.trim();
    final unreadBackgroundColor = Color.alphaBlend(
      (isDark ? colors.primary : colors.info).withValues(
        alpha: isDark ? 0.16 : 0.07,
      ),
      colors.surface,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isUnread ? unreadBackgroundColor : colors.surface,
        border: showDivider
            ? Border(bottom: BorderSide(color: colors.border))
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (item.dateLabel.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            item.dateLabel,
                            style: appText.micro.copyWith(
                              color: colors.textTertiary,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: appText.bodyStrong.copyWith(
                          color: colors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isUpdating)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: colors.textTertiary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
