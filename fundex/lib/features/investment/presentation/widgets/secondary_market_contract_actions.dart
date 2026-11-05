import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';

/// Contract and payment states are independent. Mutation endpoints remain
/// deliberately deferred by the product scope of this change.
class SecondaryMarketContractActions extends StatelessWidget {
  const SecondaryMarketContractActions({
    super.key,
    required this.record,
    required this.seller,
  });
  final MyPageApplyRecord record;
  final bool seller;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (record.contractId != null)
            Text('${l.secondaryMarketContractId}: ${record.contractId}'),
          if (record.ecUserTodo == true) ...[
            Text(l.secondaryMarketSignPending),
          ],
          if (!seller && record.status == 2)
            Text(l.secondaryMarketPaymentPending),
        ],
      ),
    );
  }
}
