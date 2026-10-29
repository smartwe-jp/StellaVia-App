import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../support/home_text_styles.dart';

class HomeRedesignHeader extends StatelessWidget {
  const HomeRedesignHeader({
    super.key,
    required this.isAuthenticated,
    required this.unreadCount,
    required this.onLogin,
    required this.onNotifications,
  });
  final bool isAuthenticated;
  final int unreadCount;
  final VoidCallback onLogin;
  final VoidCallback onNotifications;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ColoredBox(
      color: isAuthenticated
          ? colors.surface
          : colors.background.withValues(alpha: 0),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'STELLAVIA',
                  style: HomeTextStyles.brandWordmark(
                    context,
                    isAuthenticated: isAuthenticated,
                  ),
                ),
                const Spacer(),
                if (isAuthenticated)
                  Badge(
                    isLabelVisible: unreadCount > 0,
                    label: Text(unreadCount > 99 ? '99+' : '$unreadCount'),
                    child: IconButton(
                      tooltip: context.l10n.notificationsTitle,
                      onPressed: onNotifications,
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: colors.primary,
                      ),
                    ),
                  )
                else
                  AppButton(
                    label: context.l10n.loginSubmit,
                    onPressed: onLogin,
                    variant: AppButtonVariant.secondary,
                    fullWidth: false,
                    minHeight: 36,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
