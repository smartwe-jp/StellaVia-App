import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../controllers/secondary_contract_provider.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../support/secondary_market_status.dart';

class SecondaryMarketContractActions extends StatelessWidget {
  const SecondaryMarketContractActions({
    super.key,
    required this.record,
    required this.seller,
    required this.onOpen,
    this.showPayment = true,
  });
  final MyPageApplyRecord record;
  final bool seller;
  final bool showPayment;
  final ValueChanged<bool> onOpen;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final sign = canSignSecondaryContract(record);
    final status = secondaryContractStatusLabel(l, record.ecStatus);
    final download =
        record.ecUserTodo == true &&
        (record.ecStatus == 2 || record.ecStatus == 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasSecondaryContract(record)) ...[
          const Divider(height: 24),
          if (status != null)
            Text(
              '${l.secondaryMarketContract} · $status',
              style: context.appTextTheme.link,
            ),
          if (download) _DownloadContract(id: record.contractId!.trim()),
          if (!sign && !download)
            InkWell(
              onTap: () => onOpen(false),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      color: context.appColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.secondaryMarketViewContract,
                            style: context.appTextTheme.link,
                          ),
                          Text(
                            '${l.secondaryMarketContractId}  ${record.contractId}',
                            style: context.appTextTheme.meta,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.appColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          if (sign) ...[
            const SizedBox(height: 12),
            AppButton(
              onPressed: () => onOpen(true),
              label: l.secondaryMarketSign,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ],
        if (showPayment && !seller && record.status == 2)
          Text(l.secondaryMarketPaymentPending),
      ],
    );
  }
}

class _DownloadContract extends ConsumerStatefulWidget {
  const _DownloadContract({required this.id});
  final String id;
  @override
  ConsumerState<_DownloadContract> createState() => _DownloadContractState();
}

class _DownloadContractState extends ConsumerState<_DownloadContract> {
  bool busy = false;

  Future<void> download() async {
    if (busy) return;
    final user = ref.read(currentAuthUserProvider).valueOrNull;
    final email = [user?.email, user?.username]
        .whereType<String>()
        .map((v) => v.trim())
        .where((v) => v.contains('@'))
        .firstOrNull;
    final l = context.l10n;
    if (email == null) {
      AppNotice.show(context, message: l.secondaryContractEmailMissing);
      return;
    }
    setState(() => busy = true);
    try {
      final id = widget.id;
      final bytes = await ref
          .read(secondaryContractClientProvider)
          .download(id, email);
      if (!mounted ||
          widget.id != id ||
          ref.read(currentAuthUserProvider).valueOrNull?.userId != user?.userId)
        return;
      if (bytes == null) {
        AppNotice.show(context, message: l.secondaryContractEmailSent);
      } else {
        await AppShare.shareFileBytes(
          context,
          bytes: bytes,
          fileName: 'contract-$id.pdf',
          mimeType: 'application/pdf',
          unavailableNotice: l.pdfViewerShareFailedNotice,
        );
      }
    } catch (_) {
      if (mounted) AppNotice.show(context, message: l.pdfViewerLoadFailedLabel);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: busy ? null : download,
    icon: const Icon(Icons.download_outlined),
    label: Text(context.l10n.hotelOrderInvoiceDownloadAction),
  );
}
