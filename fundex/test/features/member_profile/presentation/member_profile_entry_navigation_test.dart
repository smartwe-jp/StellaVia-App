import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:fundex/features/member_profile/domain/repositories/verification_entry_repository.dart';
import 'package:fundex/features/member_profile/presentation/providers/verification_entry_provider.dart';
import 'package:fundex/features/member_profile/presentation/support/member_profile_entry_navigation.dart';

void main() {
  for (final entry in [
    const VerificationEntry(VerificationEntryKind.personal),
    const VerificationEntry(VerificationEntryKind.choice),
    const VerificationEntry(
      VerificationEntryKind.corporate,
      status: 'CONFIRMED',
    ),
    const VerificationEntry(
      VerificationEntryKind.corporate,
      status: 'SUBMITTED',
    ),
    const VerificationEntry(VerificationEntryKind.corporate, status: 'DRAFT'),
  ]) {
    testWidgets('member profile entry ${entry.kind} ${entry.status}', (tester) async {
      var loads = 0;
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Consumer(
              builder: (context, ref, _) => Scaffold(
                body: TextButton(
                  onPressed: () => openMemberProfileEntry(context, ref),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/member-profile/edit',
            pageBuilder: (_, state) => MaterialPage<void>(
              fullscreenDialog: state.extra as bool,
              child: Consumer(
                builder: (context, ref, _) {
                  ref.watch(verificationEntryProvider);
                  return const Scaffold(body: Text('Profile'));
                },
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationEntryProvider.overrideWith((ref) async {
              loads++;
              return entry;
            }),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final route = ModalRoute.of(tester.element(find.text('Profile')))!;
      expect(
        route.fullscreenDialog,
        entry.kind == VerificationEntryKind.choice ||
            entry.kind == VerificationEntryKind.corporate &&
                entry.status != 'CONFIRMED',
      );
      expect(loads, 1);
      router.pop();
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
    });
  }
}
