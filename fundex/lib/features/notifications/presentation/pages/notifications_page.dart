import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/notifications_providers.dart';
import '../state/notifications_state.dart';
import '../support/notification_item_view_data.dart';
import '../widgets/notification_detail_sheet.dart';
import '../widgets/notifications_list_item.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  String _resolveCurrentUserId(AuthUser? user) {
    final candidates = <String>[
      user?.memberId?.toString() ?? '',
      user?.userId?.toString() ?? '',
      user?.id ?? '',
      user?.username ?? '',
    ];
    for (final candidate in candidates) {
      final normalized = candidate.trim();
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }
    return '';
  }

  Future<void> _openNoticeDetail(NotificationItemViewData item) async {
    final l10n = context.l10n;
    final opened = await ref
        .read(notificationsControllerProvider.notifier)
        .openNotice(item);
    if (!mounted) {
      return;
    }
    final detail = opened ?? item;

    await AppBottomSheet.showAdaptive<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bottomSheetContext) {
        final body = detail.body.trim().isEmpty
            ? l10n.notificationsDetailNoContent
            : detail.body;
        return NotificationDetailSheet(
          detail: detail,
          body: body,
          closeLabel: l10n.notificationsDetailClose,
          linkOpenFailedMessage: l10n.uiErrorRequestFailed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      final previousValue = previous?.asData?.value;
      final nextValue = next.asData?.value ?? false;
      if (previousValue == nextValue) {
        return;
      }

      final controller = ref.read(notificationsControllerProvider.notifier);
      if (!nextValue) {
        unawaited(controller.clearForGuestMode());
        return;
      }
      unawaited(controller.loadNotices(refresh: true));
    });

    ref.listen<AsyncValue<AuthUser?>>(currentAuthUserProvider, (
      previous,
      next,
    ) {
      final previousId = _resolveCurrentUserId(previous?.asData?.value);
      final nextId = _resolveCurrentUserId(next.asData?.value);
      if (previousId == nextId) {
        return;
      }

      final isAuthenticated =
          ref.read(isAuthenticatedProvider).asData?.value ?? false;
      if (!isAuthenticated) {
        return;
      }
      unawaited(
        ref
            .read(notificationsControllerProvider.notifier)
            .loadNotices(refresh: true),
      );
    });

    ref.listen<String?>(
      notificationsControllerProvider.select(
        (NotificationsState state) => state.errorMessage,
      ),
      (previous, next) {
        if (next == null || previous == next || !mounted) {
          return;
        }
        final isAuthenticated =
            ref.read(isAuthenticatedProvider).asData?.value ?? false;
        if (!isAuthenticated && next == 'notifications_load_failed') {
          ref.read(notificationsControllerProvider.notifier).clearError();
          return;
        }
        AppNotice.show(context, message: context.l10n.uiErrorRequestFailed);
        ref.read(notificationsControllerProvider.notifier).clearError();
      },
    );

    final l10n = context.l10n;
    final state = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final items = state.items;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            _NotificationsHeader(
              title: l10n.notificationsTitle,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: RefreshIndicator(
                color: colors.danger,
                onRefresh: () async {
                  if (!isAuthenticated) {
                    return;
                  }
                  await controller.refreshNotices();
                },
                child: ListView(
                  key: const Key('notifications_page_content'),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    if (state.isLoading && !state.hasData)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 56),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                        child: _NotificationsEmptyState(
                          message: !isAuthenticated
                              ? l10n.notificationsEmptyGuest
                              : l10n.notificationsEmptyGeneral,
                        ),
                      )
                    else
                      for (var index = 0; index < items.length; index += 1)
                        NotificationsListItem(
                          item: items[index],
                          isUpdating: state.updatingNoticeKeys.contains(
                            items[index].key,
                          ),
                          showDivider: index != items.length - 1,
                          onTap: () => _openNoticeDetail(items[index]),
                        ),
                    const SizedBox(height: 20),
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

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        children: <Widget>[
          SizedBox.square(
            dimension: 32,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onBack,
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: appText.pageTitle.copyWith(color: colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsEmptyState extends StatelessWidget {
  const _NotificationsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
        child: Row(
          children: <Widget>[
            Icon(Icons.notifications_none_rounded, color: colors.textTertiary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: appText.caption.copyWith(
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
