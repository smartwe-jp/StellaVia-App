import '../support/notification_item_view_data.dart';

class NotificationsState {
  const NotificationsState({
    required this.isLoading,
    required this.isRefreshing,
    required this.items,
    required this.unreadCount,
    required this.updatingNoticeKeys,
    this.errorMessage,
  });

  const NotificationsState.initial()
    : isLoading = true,
      isRefreshing = false,
      items = const <NotificationItemViewData>[],
      unreadCount = 0,
      updatingNoticeKeys = const <String>{},
      errorMessage = null;

  final bool isLoading;
  final bool isRefreshing;
  final List<NotificationItemViewData> items;
  final int unreadCount;
  final Set<String> updatingNoticeKeys;
  final String? errorMessage;

  bool get hasData => items.isNotEmpty;

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<NotificationItemViewData>? items,
    int? unreadCount,
    Set<String>? updatingNoticeKeys,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      updatingNoticeKeys: updatingNoticeKeys ?? this.updatingNoticeKeys,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
