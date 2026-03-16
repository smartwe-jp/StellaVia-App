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

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        final body = detail.body.trim().isEmpty
            ? l10n.notificationsDetailNoContent
            : detail.body;
        final maxHeight = MediaQuery.sizeOf(bottomSheetContext).height * 0.82;
        return SizedBox(
          height: maxHeight,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (detail.dateLabel.isNotEmpty)
                        Text(
                          detail.dateLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColorTokens.fundexTextTertiary,
                          ),
                        ),
                      if (detail.dateLabel.isNotEmpty)
                        const SizedBox(height: 8),
                      Text(
                        detail.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColorTokens.fundexText,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColorTokens.fundexTextSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(bottomSheetContext).pop(),
                    child: Text(l10n.notificationsDetailClose),
                  ),
                ),
              ),
            ],
          ),
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
    final isAuthenticated =
        ref.watch(isAuthenticatedProvider).asData?.value ?? false;
    final items = state.items;

    return Scaffold(
      backgroundColor: Colors.white,
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
                color: AppColorTokens.fundexDanger,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Row(
        children: <Widget>[
          SizedBox.square(
            dimension: 32,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onBack,
                child: const Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: AppColorTokens.fundexText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColorTokens.fundexText,
              ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColorTokens.fundexBackground,
        border: Border.all(color: AppColorTokens.fundexBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.notifications_none_rounded,
              color: AppColorTokens.fundexTextTertiary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColorTokens.fundexTextSecondary,
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
