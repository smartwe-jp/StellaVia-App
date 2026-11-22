import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/discussion_board/domain/entities/discussion_board_draft.dart';
import 'package:fundex/features/discussion_board/presentation/widgets/kizunark_comment_composer_widgets.dart';
import 'package:fundex/l10n/app_localizations.dart';

Widget _buildComposer({
  required bool xSyncEnabled,
  Future<bool> Function()? onConnect,
}) {
  return MaterialApp(
    locale: const Locale('ja'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppThemeFactory.light(locale: const Locale('ja')),
    home: KizunarkComposeSheet(
      key: ValueKey(xSyncEnabled),
      title: '投稿',
      closeLabel: '閉じる',
      submitLabel: '投稿する',
      placeholder: '内容',
      currentUser: null,
      avatarSeed: null,
      authorLabel: '利用者',
      addImageLabel: '画像',
      linkedFundLabel: 'ファンド',
      imageCounterBuilder: (count) => '$count/4',
      xSyncConnectedLabel: 'Xにも同期',
      xSyncDisconnectedLabel: 'Xに接続',
      xSyncConnectedDescription: '説明',
      xSyncDisconnectedDescription: '接続して同期',
      xSyncInitiallyEnabled: xSyncEnabled,
      onConnectXAccount: onConnect ?? () async => false,
      controller: TextEditingController(),
      selectedFund: null,
      onPickImages: (_) async => const <String>[],
      onPickFund: () async => null,
      onOpenDrafts: () async => null,
      onOpenReplyDraft: (DiscussionBoardDraft _) async {},
      onSelectedFundChanged: (_) {},
      onTextChanged: (_) {},
      onSaveDraft: (_) async {},
      onSubmit: (_, _) async => true,
      fullPage: true,
    ),
  );
}

void main() {
  testWidgets('X sync switch is selectable only for a connected account', (
    tester,
  ) async {
    await tester.pumpWidget(_buildComposer(xSyncEnabled: true));
    await tester.pumpAndSettle();

    final switchFinder = find.byKey(const Key('kizunark_sync_to_x_switch'));
    expect(tester.widget<Switch>(switchFinder).value, isFalse);

    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.pumpWidget(_buildComposer(xSyncEnabled: false));
    await tester.pumpAndSettle();
    expect(switchFinder, findsNothing);
    expect(find.text('Xに接続'), findsOneWidget);
  });

  testWidgets('connecting enables an initially unchecked sync switch', (
    tester,
  ) async {
    var connections = 0;
    await tester.pumpWidget(
      _buildComposer(
        xSyncEnabled: false,
        onConnect: () async {
          connections++;
          return true;
        },
      ),
    );
    await tester.tap(find.text('Xに接続'));
    await tester.pumpAndSettle();
    expect(connections, 1);
    final switchFinder = find.byKey(const Key('kizunark_sync_to_x_switch'));
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);
  });
}
