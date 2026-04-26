import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppNetworkAvailability { online, offline }

enum AppNetworkAccessState { normal, denied }

bool isAppNetworkOffline(WidgetRef ref) {
  return ref.read(appNetworkAvailabilityProvider).asData?.value ==
      AppNetworkAvailability.offline;
}

bool shouldSkipAppNetworkRefresh(WidgetRef ref) {
  return isAppNetworkOffline(ref);
}

class AppNetworkAccessStateController
    extends StateNotifier<AppNetworkAccessState> {
  AppNetworkAccessStateController() : super(AppNetworkAccessState.normal);

  void markDenied() {
    state = AppNetworkAccessState.denied;
  }

  void clear() {
    state = AppNetworkAccessState.normal;
  }
}

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final appNetworkAccessStateProvider =
    StateNotifierProvider<
      AppNetworkAccessStateController,
      AppNetworkAccessState
    >((ref) {
      return AppNetworkAccessStateController();
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
