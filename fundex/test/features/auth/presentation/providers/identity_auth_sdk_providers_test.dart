import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/presentation/providers/identity_auth_sdk_providers.dart';

void main() {
  test('identity auth is enabled by default', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(identityAuthFeatureEnabledProvider), isTrue);
  });
}
