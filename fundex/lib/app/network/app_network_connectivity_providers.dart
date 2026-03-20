import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppNetworkAvailability { online, offline }

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final appNetworkAvailabilityProvider = StreamProvider<AppNetworkAvailability>((
  ref,
) async* {
  final connectivity = ref.watch(connectivityProvider);

  AppNetworkAvailability mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn) ||
        results.contains(ConnectivityResult.bluetooth) ||
        results.contains(ConnectivityResult.other)) {
      return AppNetworkAvailability.online;
    }
    return AppNetworkAvailability.offline;
  }

  yield mapResults(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(mapResults).distinct();
});
