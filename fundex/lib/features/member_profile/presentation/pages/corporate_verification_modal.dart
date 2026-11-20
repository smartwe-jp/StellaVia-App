import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../support/corporate_flow_navigation.dart';
import '../widgets/corporate_flow_scaffold.dart';
import '../widgets/verification_entry_content.dart';

Future<void> openCorporateVerification(
  BuildContext context,
  VerificationEntry seed,
) => Navigator.of(context, rootNavigator: true).push<void>(
  corporateVerificationModalRoute(
    (context) => CorporateFlowScaffold(
      title: context.l10n.corporateVerificationTitle,
      child: CorporateEntryContent(seed: seed),
    ),
  ),
);
