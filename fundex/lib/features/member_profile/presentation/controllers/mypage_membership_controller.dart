import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Separate resources let a tier request succeed even when the balance fails.
class MyPageMembershipController<T> extends StateNotifier<AsyncValue<T>> {
  MyPageMembershipController(this.load) : super(const AsyncLoading());
  final Future<T> Function() load;
  Future<void>? _pending;
  Future<void> refresh() =>
      _pending ??= _refresh().whenComplete(() => _pending = null);
  Future<void> _refresh() async {
    if (!mounted) return;
    state = AsyncLoading<T>().copyWithPrevious(state);
    try {
      final result = await load();
      if (mounted) state = AsyncData(result);
    } catch (e, st) {
      if (mounted) state = AsyncError<T>(e, st).copyWithPrevious(state);
    }
  }
}
