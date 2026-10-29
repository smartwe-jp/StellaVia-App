import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeResourceState<T> {
  const HomeResourceState({
    this.data,
    this.isLoading = false,
    this.hasError = false,
  });
  final T? data;
  final bool isLoading;
  final bool hasError;
}

/// Root-tab cache: refresh keeps useful data; disposal/account changes discard it.
class HomeResourceController<T> extends StateNotifier<HomeResourceState<T>> {
  HomeResourceController(this._load) : super(HomeResourceState<T>());
  final Future<T> Function() _load;
  Future<void>? _pending;

  Future<void> refresh() =>
      _pending ??= _refresh().whenComplete(() => _pending = null);

  Future<void> _refresh() async {
    state = HomeResourceState(data: state.data, isLoading: true);
    try {
      final data = await _load();
      if (mounted) state = HomeResourceState(data: data);
    } catch (_) {
      if (mounted) state = HomeResourceState(data: state.data, hasError: true);
    }
  }
}
