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
    final isUnread = !item.isRead;
    final title = item.title.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xFFF0F9FF) : Colors.white,
        border: showDivider
            ? const Border(
                bottom: BorderSide(color: AppColorTokens.fundexBorder),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
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
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColorTokens.fundexTextTertiary,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColorTokens.fundexText,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isUpdating)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColorTokens.fundexTextTertiary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
