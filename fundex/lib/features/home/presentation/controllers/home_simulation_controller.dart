import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/home_simulation.dart';

class HomeSimulationController extends StateNotifier<HomeSimulationInput> {
  HomeSimulationController() : super(const HomeSimulationInput());
  void setUnits(double value) =>
      state = state.copyWith(units: value.round().clamp(1, 5000));
  void setRate(double value) =>
      state = state.copyWith(annualRateTenths: value.round().clamp(30, 100));
  void setMonths(double value) =>
      state = state.copyWith(months: value.round().clamp(1, 36));
  void setType(SimulationDividendType value) =>
      state = state.copyWith(type: value);
}

final homeSimulationInputProvider =
    StateNotifierProvider.autoDispose<
      HomeSimulationController,
      HomeSimulationInput
    >((ref) => HomeSimulationController());
final homeSimulationCalculatorProvider = Provider<CalculateHomeSimulation>(
  (ref) => const CalculateHomeSimulation(),
);
