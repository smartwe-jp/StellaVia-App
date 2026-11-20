import 'dart:async';

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundex/features/member_profile/domain/entities/corporate_form_draft.dart';
import 'package:fundex/features/member_profile/domain/entities/member_profile_region.dart';
import 'package:fundex/features/member_profile/domain/usecases/fetch_member_profile_regions_by_zip_usecase.dart';
import 'package:fundex/features/member_profile/presentation/pages/corporate_form_page.dart';
import 'package:fundex/features/member_profile/presentation/providers/member_profile_providers.dart';
import 'package:fundex/l10n/app_localizations.dart';

class _Lookup implements FetchMemberProfileRegionsByZipUseCase {
  final requests = <String>[];
  final responses = <Completer<List<MemberProfileRegion>>>[];
  @override
  Future<List<MemberProfileRegion>> call({required String zip}) {
    requests.add(zip);
    final response = Completer<List<MemberProfileRegion>>();
    responses.add(response);
    return response.future;
  }
}

void main() {
  for (final section in [
    CorporateSection.company,
    CorporateSection.representative,
  ]) {
    testWidgets('postal lookup fills the editable address in $section', (
      tester,
    ) async {
      final draft = CorporateFormDraft();
      final lookup = _Lookup();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMemberProfileRegionsByZipUseCaseProvider.overrideWithValue(
              lookup,
            ),
          ],
          child: MaterialApp(
            theme: AppThemeFactory.light(),
            locale: const Locale('ja'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: CorporateFormPage(section: section, draft: draft),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final postal = find.byKey(const ValueKey(CorporateField.postal)).last;
      final field = section == CorporateSection.company
          ? CorporateField.office
          : CorporateField.address;
      final address = find.byKey(ValueKey(field)).last;
      Future<void> input(Finder target, String value) async {
        await tester.ensureVisible(target);
        await tester.enterText(target, value);
        await tester.pump();
      }

      await input(postal, '530');
      expect(lookup.requests, isEmpty);
      await input(postal, '530-0043');
      await input(postal, '1000001');
      const rows = [
        MemberProfileRegion(
          jpName: '東京都',
          parentId: null,
          regionId: null,
          regionType: 0,
          roomName: '',
        ),
        MemberProfileRegion(
          jpName: '千代田区',
          parentId: null,
          regionId: null,
          regionType: 1,
          roomName: '',
        ),
      ];
      lookup.responses[0].complete(rows);
      await tester.pump();
      expect(draft.value(section, field), isEmpty);
      lookup.responses[1].complete(rows);
      await tester.pumpAndSettle();
      expect(find.text('東京都千代田区'), findsOneWidget);
      final search = find.text('住所検索');
      await tester.ensureVisible(search);
      await tester.tap(search);
      await tester.pump();
      await input(address, '東京都千代田区千代田1-1');
      lookup.responses.last.complete(rows);
      await tester.pumpAndSettle();
      expect(draft.value(section, field), '東京都千代田区千代田1-1');
      expect(lookup.requests, ['5300043', '1000001', '1000001']);
    });
  }
}
