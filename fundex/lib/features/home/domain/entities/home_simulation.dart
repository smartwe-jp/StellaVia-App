import '../../../host_miles/domain/entities/host_miles_models.dart';

enum SimulationDividendType { income, capital }

class HomeSimulationInput {
  const HomeSimulationInput({
    this.units = 100,
    this.annualRateTenths = 60,
    this.months = 12,
    this.type = SimulationDividendType.income,
  });
  final int units, annualRateTenths, months;
  final SimulationDividendType type;
  int get principal => units * 10000;
  HomeSimulationInput copyWith({
    int? units,
    int? annualRateTenths,
    int? months,
    SimulationDividendType? type,
  }) => HomeSimulationInput(
    units: units ?? this.units,
    annualRateTenths: annualRateTenths ?? this.annualRateTenths,
    months: months ?? this.months,
    type: type ?? this.type,
  );
}

class HomeSimulationResult {
  const HomeSimulationResult({
    required this.monthlyDividend,
    required this.termDividend,
    required this.totalReceived,
    required this.miles,
    required this.tierCode,
    required this.monthlyMiles,
    required this.monthlyPointRate,
  });
  final int monthlyDividend, termDividend, totalReceived;
  final int? miles, monthlyMiles;
  final num? monthlyPointRate;
  final String? tierCode;
}

/// Local, pretax simple-interest estimate, never a purchase or payout quote.
class CalculateHomeSimulation {
  const CalculateHomeSimulation();
  HomeSimulationResult call(
    HomeSimulationInput input,
    List<HostMilesTierRule> rules,
  ) {
    if (input.units < 1 ||
        input.units > 5000 ||
        input.annualRateTenths < 30 ||
        input.annualRateTenths > 100 ||
        input.months < 1 ||
        input.months > 36) {
      throw ArgumentError('Simulation inputs are outside supported ranges.');
    }
    final candidates =
        rules
            .where((r) => r.minAum != null && r.minAum! <= input.principal)
            .toList()
          ..sort((a, b) => b.minAum!.compareTo(a.minAum!));
    final tier = candidates.isEmpty ? null : candidates.first;
    // Web reference: choose the highest reached minAum; rates use the API
    // decimal monthly contract. Missing API data must not create sample rewards.
    final rawRate = tier?.pointRate;
    final rate = rawRate != null && rawRate.isFinite && rawRate >= 0
        ? rawRate
        : null;
    final miles = rate == null
        ? null
        : (input.principal * rate * input.months + 1e-8).floor();
    final term =
        input.principal * input.annualRateTenths * input.months ~/ 12000;
    return HomeSimulationResult(
      monthlyDividend: input.principal * input.annualRateTenths ~/ 12000,
      termDividend: term,
      totalReceived: input.principal + term,
      miles: miles,
      tierCode: tier?.tierCode,
      monthlyMiles: rate == null
          ? null
          : (input.principal * rate + 1e-8).floor(),
      monthlyPointRate: rate,
    );
  }
}
