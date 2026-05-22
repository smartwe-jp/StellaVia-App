import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/discussion_board/presentation/state/discussion_send_queue_state.dart';

void main() {
  group('DiscussionSendQueueController', () {
    test('tracks queued send count and current progress', () {
      final controller = DiscussionSendQueueController();

      controller.enqueue();
      controller.enqueue();
      controller.updateProgress(0.6);

      expect(controller.state.pendingCount, 2);
      expect(controller.state.progress, 0.6);

      controller.completeOne();

      expect(controller.state.pendingCount, 1);
      expect(controller.state.progress, 0.04);

      controller.completeOne();

      expect(controller.state.pendingCount, 0);
      expect(controller.state.progress, 0);
    });

    test('cancelAll clears all jobs and invalidates active callbacks', () {
      final controller = DiscussionSendQueueController();

      controller.enqueue();
      final previousGeneration = controller.state.cancelGeneration;

      controller.cancelAll();

      expect(controller.state.pendingCount, 0);
      expect(controller.state.progress, 0);
      expect(controller.state.cancelGeneration, previousGeneration + 1);
    });
  });
}
