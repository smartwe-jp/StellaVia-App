import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mypage_chart.dart';

class MyPageChartState {
  const MyPageChartState({this.years = 1, this.data = const AsyncLoading()});
  final int years;
  final AsyncValue<MyPageChartData> data;
}

class MyPageChartController extends StateNotifier<MyPageChartState> {
  MyPageChartController(this.load, {this.localHistory = false})
    : super(const MyPageChartState());
  final Future<MyPageChartData> Function(int years) load;
  final bool localHistory;
  MyPageChartData? _history;
  int _generation = 0;
  Future<void> selectYears(int years) async {
    if (![1, 3, 5].contains(years) || state.years == years) return;
    if (localHistory && _history != null) {
      state = MyPageChartState(
        years: years,
        data: AsyncData(_history!.historyWindow(years, DateTime.now())),
      );
      return;
    }
    final loadingHistory =
        localHistory && _generation > 0 && state.data.isLoading;
    state = MyPageChartState(years: years);
    if (!loadingHistory) await refresh();
  }

  Future<void> refresh() async {
    if (!mounted) return;
    final generation = ++_generation;
    final years = state.years;
    state = MyPageChartState(
      years: years,
      data: const AsyncLoading<MyPageChartData>().copyWithPrevious(state.data),
    );
    try {
      final result = await load(years);
      if (mounted && generation == _generation) {
        if (localHistory) _history = result;
        final selected = state.years;
        state = MyPageChartState(
          years: selected,
          data: AsyncData(
            localHistory
                ? result.historyWindow(selected, DateTime.now())
                : result,
          ),
        );
      }
    } catch (e, st) {
      if (mounted && generation == _generation) {
        state = MyPageChartState(
          years: state.years,
          data: AsyncError<MyPageChartData>(e, st).copyWithPrevious(state.data),
        );
      }
    }
  }
}
