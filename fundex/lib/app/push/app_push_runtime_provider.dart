import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_push_runtime.dart';

final appPushRuntimeProvider = Provider<AppPushRuntime>((ref) {
  return const NoopPushRuntime();
});
