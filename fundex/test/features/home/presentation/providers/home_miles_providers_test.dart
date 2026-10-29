import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/auth/domain/entities/auth_user.dart';
import 'package:fundex/features/auth/presentation/providers/auth_providers.dart';
import 'package:fundex/features/home/presentation/controllers/home_resource_controller.dart';
import 'package:fundex/features/home/presentation/providers/home_miles_providers.dart';
import 'package:fundex/features/home/presentation/support/home_miles_display.dart';
import 'package:fundex/features/host_miles/domain/entities/host_miles_models.dart';
import 'package:fundex/features/host_miles/domain/repositories/host_miles_repository.dart';
import 'package:fundex/features/host_miles/presentation/providers/host_miles_providers.dart';

class FakeRepository implements HostMilesRepository {
  int accountCalls = 0;
  int ruleCalls = 0;
  Future<HostMilesAccount> Function() account = () async =>
      const HostMilesAccount(availablePoints: 1234, totalEarnedPoints: 999999);
  @override
  Future<HostMilesAccount> fetchAccount() {
    accountCalls++;
    return account();
  }

  @override
  Future<List<HostMilesTierRule>> fetchTierRules() async {
    ruleCalls++;
    return [const HostMilesTierRule(tierCode: 'MASTER', minAum: 10000000)];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final session = StateProvider<bool>((ref) => false);
final identity = StateProvider<String>((ref) => 'A');
Future<void> flush() => Future<void>.delayed(Duration.zero);
void main() {
  test(
    'guest fetches public rules only; login and logout isolate account',
    () async {
      final repo = FakeRepository();
      final container = ProviderContainer(
        overrides: [
          hostMilesRepositoryProvider.overrideWithValue(repo),
          isAuthenticatedProvider.overrideWith(
            (ref) => AsyncData(ref.watch(session)),
          ),
          currentAuthUserProvider.overrideWith(
            (ref) async => AuthUser(username: ref.watch(identity)),
          ),
        ],
      );
      addTearDown(container.dispose);
      container.listen(homeMilesAccountProvider, (_, __) {});
      container.listen(homeMilesRulesProvider, (_, __) {});
      await flush();
      await flush();
      expect(repo.accountCalls, 0);
      expect(repo.ruleCalls, 1);
      container.read(session.notifier).state = true;
      await flush();
      await flush();
      expect(repo.accountCalls, 1);
      expect(
        container.read(homeMilesAccountProvider).data?.availablePoints,
        1234,
      );
      container.read(session.notifier).state = false;
      await flush();
      expect(container.read(homeMilesAccountProvider).data, isNull);
    },
  );
  test('account switch cannot expose old or late results', () async {
    final repo = FakeRepository();
    final old = Completer<HostMilesAccount>();
    repo.account = () => old.future;
    final container = ProviderContainer(
      overrides: [
        hostMilesRepositoryProvider.overrideWithValue(repo),
        isAuthenticatedProvider.overrideWithValue(const AsyncData(true)),
        currentAuthUserProvider.overrideWith(
          (ref) async => AuthUser(username: ref.watch(identity)),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(homeMilesAccountProvider, (_, __) {});
    await flush();
    await flush();
    repo.account = () async => const HostMilesAccount(availablePoints: 22);
    container.read(identity.notifier).state = 'B';
    await flush();
    await flush();
    old.complete(const HostMilesAccount(availablePoints: 111));
    await flush();
    expect(container.read(homeMilesAccountProvider).data?.availablePoints, 22);
  });
  test(
    'refresh failure retains balance and allows retry; requests coalesce',
    () async {
      var calls = 0;
      var fail = false;
      Completer<HostMilesAccount>? pending;
      final controller = HomeResourceController<HostMilesAccount>(() {
        calls++;
        if (fail) throw StateError('offline');
        return pending?.future ??
            Future.value(const HostMilesAccount(availablePoints: 0));
      });
      addTearDown(controller.dispose);
      await controller.refresh();
      fail = true;
      await controller.refresh();
      expect(controller.state.hasError, true);
      expect(controller.state.data?.availablePoints, 0);
      fail = false;
      pending = Completer();
      final a = controller.refresh();
      final b = controller.refresh();
      expect(identical(a, b), true);
      expect(controller.state.data?.availablePoints, 0);
      expect(controller.state.isLoading, true);
      pending.complete(const HostMilesAccount(availablePoints: 23));
      await a;
      expect(calls, 3);
      expect(controller.state.hasError, false);
      expect(controller.state.data?.availablePoints, 23);
    },
  );
  test('unknown is not zero; catalog follows server thresholds', () {
    expect(homeMilesBalance(null, 'ja'), '—');
    expect(homeMilesBalance(0, 'ja'), '0');
    expect(homeMilesBalance(123456, 'ja'), '123,456');
    expect(
      homeRankNames([
        const HostMilesTierRule(tierCode: 'NEW', minAum: 100),
        const HostMilesTierRule(tierCode: 'START', minAum: 0),
      ]),
      ['START', 'NEW'],
    );
  });
}
