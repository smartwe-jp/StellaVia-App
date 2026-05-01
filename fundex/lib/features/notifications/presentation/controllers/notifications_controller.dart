import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/support/app_request_error_message_resolver.dart';
import '../../data/datasources/notifications_local_data_source.dart';
import '../../data/datasources/notifications_remote_data_source.dart';
import '../state/notifications_state.dart';
import '../support/notification_item_view_data.dart';

class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this._remoteDataSource, this._localDataSource)
    : super(const NotificationsState.initial()) {
    unawaited(loadNotices());
  }

  static const int _defaultLimit = 100;

  final NotificationsRemoteDataSource _remoteDataSource;
  final NotificationsLocalDataSource _localDataSource;

  Future<void> clearForGuestMode() async {
    if (!mounted) {
      return;
    }
    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      items: const <NotificationItemViewData>[],
      unreadCount: 0,
      updatingNoticeKeys: const <String>{},
      clearError: true,
    );
  }

  Future<void> loadNotices({bool refresh = false}) async {
    if (!mounted) {
      return;
    }
    if (!refresh && state.isLoading && state.hasData) {
      return;
    }
    if (state.isRefreshing && refresh) {
      return;
    }

    state = state.copyWith(
      isLoading: !refresh,
      isRefreshing: refresh,
      clearError: true,
    );

    try {
      final notices = await _remoteDataSource.fetchNotices(
        startPage: 1,
        limit: _defaultLimit,
      );
      final localReadIds = await _localDataSource.readReadNoticeIds();
      if (!mounted) {
        return;
      }

      final mapped = notices
          .map((notice) {
            final item = NotificationItemViewData.fromNoticeDto(notice);
            final id = item.id;
            if (id != null && localReadIds.contains(id)) {
              return item.copyWith(isRead: true);
            }
            return item;
          })
          .toList(growable: false);
      final sorted = _sortByCreatedAtDesc(mapped);
      final fallbackUnread = sorted
          .where((NotificationItemViewData item) => !item.isRead)
          .length;

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        items: sorted,
        unreadCount: fallbackUnread,
        clearError: true,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
    }
  }

  Future<void> refreshNotices() {
    return loadNotices(refresh: true);
  }

  Future<NotificationItemViewData?> openNotice(
    NotificationItemViewData item,
  ) async {
    if (!mounted) {
      return item;
    }
    final itemId = item.id;
    if (itemId == null || item.isRead) {
      return item;
    }

    if (state.updatingNoticeKeys.contains(item.key)) {
      return item;
    }

    final nextUpdating = Set<String>.from(state.updatingNoticeKeys)
      ..add(item.key);
    state = state.copyWith(updatingNoticeKeys: nextUpdating, clearError: true);

    try {
      final checked = await _remoteDataSource.checkNotice(id: itemId);
      await _localDataSource.markNoticeRead(itemId);
      if (!mounted) {
        return item;
      }
      final checkedItem = NotificationItemViewData.fromNoticeDto(checked);
      final updated = checkedItem.copyWith(
        isRead: true,
        title: checkedItem.title.isNotEmpty ? checkedItem.title : item.title,
        body: checkedItem.body.isNotEmpty ? checkedItem.body : item.body,
        dateLabel: checkedItem.dateLabel.isNotEmpty
            ? checkedItem.dateLabel
            : item.dateLabel,
        createdAt: checkedItem.createdAt ?? item.createdAt,
      );

      final merged = _replaceItem(updated);
      state = state.copyWith(
        updatingNoticeKeys: Set<String>.from(state.updatingNoticeKeys)
          ..remove(item.key),
        unreadCount: _calculateUnreadCount(merged),
        clearError: true,
      );
      return merged.firstWhere(
        (NotificationItemViewData current) =>
            (updated.id != null && current.id == updated.id) ||
            current.key == updated.key,
        orElse: () => updated,
      );
    } catch (error) {
      if (!mounted) {
        return item;
      }
      final nextKeys = Set<String>.from(state.updatingNoticeKeys)
        ..remove(item.key);
      state = state.copyWith(
        updatingNoticeKeys: nextKeys,
        errorMessage: resolveAppRequestErrorMessage(error, ''),
      );
      return item;
    }
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }
    state = state.copyWith(clearError: true);
  }

  List<NotificationItemViewData> _replaceItem(NotificationItemViewData next) {
    final updated = state.items
        .map((NotificationItemViewData current) {
          if (next.id != null && current.id == next.id) {
            return next;
          }
          if (current.key == next.key) {
            return next;
          }
          return current;
        })
        .toList(growable: false);
    final sorted = _sortByCreatedAtDesc(updated);
    state = state.copyWith(items: sorted);
    return sorted;
  }

  int _calculateUnreadCount(List<NotificationItemViewData> items) {
    return items.where((NotificationItemViewData item) => !item.isRead).length;
  }

  List<NotificationItemViewData> _sortByCreatedAtDesc(
    List<NotificationItemViewData> source,
  ) {
    final sorted = List<NotificationItemViewData>.from(source);
    sorted.sort((a, b) {
      final left = a.createdAt;
      final right = b.createdAt;
      if (left != null && right != null) {
        return right.compareTo(left);
      }
      if (right != null) {
        return 1;
      }
      if (left != null) {
        return -1;
      }
      return b.dateLabel.compareTo(a.dateLabel);
    });
    return sorted;
  }
}
