import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/member_profile_providers.dart';
import '../providers/host_fund_management_providers.dart';
import 'host_fund_content.dart';

class HostFundBankSheet extends ConsumerWidget {
  const HostFundBankSheet({super.key, required this.projectId});
  final String? projectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final provider = hostFundBankProvider(projectId);
    final user = ref.watch(currentAuthUserProvider).asData?.value;
    final profile = ref.watch(memberBasicProfileProvider);
    final memberId =
        user?.userId?.toString() ?? user?.memberId?.toString() ?? user?.id;
    final kana =
        '${profile?.familyNameKana ?? ''}${profile?.givenNameKana ?? ''}'
            .trim();
    final name = memberId == null || memberId.isEmpty
        ? ''
        : '$memberId${kana.isEmpty ? user?.katakana?.trim() ?? '' : kana}';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.hostManageFundBankAccount,
                  style: context.appTextTheme.sectionTitle,
                ),
              ),
              const CloseButton(),
            ],
          ),
          HostFundContent(
            state: ref.watch(provider),
            retry: () => ref.invalidate(provider),
            builder: (result) {
              final bank = result.bank;
              String clean(String? text) =>
                  text == null || text.trim() == '--' ? '' : text.trim();
              final branch = [
                clean(bank?.branchName),
                clean(bank?.branchNumber),
              ].where((s) => s.isNotEmpty).join(' ');
              final number = [
                clean(bank?.accountType),
                clean(bank?.accountNumber),
              ].where((s) => s.isNotEmpty).join(' ');
              final fields = [
                (
                  l.walletBankNameLabel,
                  clean(bank?.bankName),
                  clean(bank?.bankName).replaceFirst(RegExp('銀行\$'), ''),
                ),
                (
                  l.walletBranchNameLabel,
                  branch,
                  clean(bank?.branchNumber).isNotEmpty
                      ? clean(bank?.branchNumber)
                      : clean(
                          bank?.branchName,
                        ).replaceFirst(RegExp('(支店|出張所)\$'), ''),
                ),
                (
                  l.walletAccountNumberLabel,
                  number,
                  clean(bank?.accountNumber),
                ),
                (
                  l.walletAccountHolderLabel,
                  clean(bank?.accountHolder),
                  clean(bank?.accountHolder),
                ),
              ].where((row) => row.$2.isNotEmpty).toList();
              if (fields.isEmpty) return Text(l.hostManageFundBankEmpty);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final field in fields)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(field.$1),
                      subtitle: SelectableText(field.$2),
                      trailing: field.$3.isEmpty
                          ? null
                          : AppCopyButton(
                              label: l.lotteryApplyCopyAction,
                              onPressed: () => _copy(context, field.$3),
                            ),
                    ),
                  if (result.projectAccount && name.isNotEmpty) ...[
                    Text(l.walletDepositTransferNotice(name)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppCopyButton(
                        label: l.walletDepositTransferNameCopyAction,
                        onPressed: () => _copy(context, name),
                      ),
                    ),
                  ],
                  Text(
                    l.hostManageBankFee,
                    style: context.appTextTheme.caption,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      AppNotice.show(context, message: context.l10n.lotteryApplyCopyDoneToast);
    }
  }
}
