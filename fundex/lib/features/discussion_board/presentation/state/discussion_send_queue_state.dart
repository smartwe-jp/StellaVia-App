import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscussionSendQueueState {
  const DiscussionSendQueueState({
    required this.pendingCount,
    required this.progress,
    required this.cancelGeneration,
  });

  const DiscussionSendQueueState.initial()
    : pendingCount = 0,
      progress = 0,
      cancelGeneration = 0;

  final int pendingCount;
  final double progress;
  final int cancelGeneration;

  bool get isActive => pendingCount > 0;

  DiscussionSendQueueState copyWith({
    int? pendingCount,
    double? progress,
    int? cancelGeneration,
  }) {
    return DiscussionSendQueueState(
      pendingCount: pendingCount ?? this.pendingCount,
      progress: progress ?? this.progress,
      cancelGeneration: cancelGeneration ?? this.cancelGeneration,
    );
  }
}

class DiscussionSendQueueController
    extends StateNotifier<DiscussionSendQueueState> {
  DiscussionSendQueueController()
    : super(const DiscussionSendQueueState.initial());

  void enqueue() {
    state = state.copyWith(
      pendingCount: state.pendingCount + 1,
      progress: state.pendingCount == 0 ? 0.04 : state.progress,
    );
  }

  void updateProgress(double progress) {
    if (!state.isActive) {
      return;
    }
    state = state.copyWith(progress: progress.clamp(0, 1).toDouble());
  }

  void completeOne() {
    if (state.pendingCount <= 1) {
      state = state.copyWith(pendingCount: 0, progress: 0);
      return;
    }
    state = state.copyWith(
      pendingCount: state.pendingCount - 1,
      progress: 0.04,
    );
  }

  void cancelAll() {
    state = state.copyWith(
      pendingCount: 0,
      progress: 0,
      cancelGeneration: state.cancelGeneration + 1,
    );
  }
}
