import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mypage_chart.dart';

class MyPageChartState {
  const MyPageChartState({this.years = 5, this.data = const AsyncLoading()});
  final int years;
  final AsyncValue<MyPageChartData> data;
}

class MyPageChartController extends StateNotifier<MyPageChartState> {
  MyPageChartController(this.load) : super(const MyPageChartState());
  final Future<MyPageChartData> Function(int years) load;
  int _generation = 0;
  Future<void> selectYears(int years) async {
    if (![1, 3, 5].contains(years) || state.years == years) return;
    state = MyPageChartState(years: years);
    await refresh();
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
        state = MyPageChartState(years: years, data: AsyncData(result));
      }
    } catch (e, st) {
      if (mounted && generation == _generation) {
        state = MyPageChartState(
          years: years,
          data: AsyncError<MyPageChartData>(e, st).copyWithPrevious(state.data),
        );
      }
    }
  }
}
