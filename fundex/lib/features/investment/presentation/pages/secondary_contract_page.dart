import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui_kit/core_ui_kit.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../controllers/secondary_contract_provider.dart';
import '../widgets/secondary_contract_progress.dart';
import 'secondary_signature_page.dart';

class SecondaryContractPage extends ConsumerStatefulWidget {
  const SecondaryContractPage({
    super.key,
    required this.id,
    required this.sign,
  });
  final String id;
  final bool sign;
  @override
  ConsumerState<SecondaryContractPage> createState() => _ContractState();
}

class _ContractState extends ConsumerState<SecondaryContractPage> {
  late final Object? identity;
  @override
  void initState() {
    super.initState();
    identity = ref.read(myPageMembershipIdentityProvider);
  }

  bool loaded = false;

  Future<void> openSignature() async {
    final owner = identity;
    if (owner == null || ref.read(myPageMembershipIdentityProvider) != owner) {
      return;
    }
    final signed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SecondarySignaturePage(id: widget.id, identity: owner),
      ),
    );
    if (!mounted) return;
    if (signed == true) {
      Navigator.of(context).pop(true);
    } else {
      ref.invalidate(secondaryContractDetailProvider(widget.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final active = ref.watch(myPageMembershipIdentityProvider);
    final detail = ref.watch(secondaryContractDetailProvider(widget.id));
    final info = detail.asData?.value;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          info != null && info.title.isNotEmpty
              ? info.title
              : l.secondaryMarketContract,
        ),
      ),
      body: active == null || active != identity
          ? Center(child: Text(l.secondaryMarketDetailUnavailable))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: AppMemoryPdfView(
                      load: () => ref
                          .read(secondaryContractClientProvider)
                          .pdf(widget.id),
                      errorLabel: l.pdfViewerLoadFailedLabel,
                      retryLabel: l.commonRetry,
                      onLoaded: () => setState(() => loaded = true),
                    ),
                  ),
                  if (detail.isLoading) const LinearProgressIndicator(),
                  if (detail.hasError)
                    TextButton.icon(
                      onPressed: () => ref.invalidate(
                        secondaryContractDetailProvider(widget.id),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(l.commonRetry),
                    ),
                  if (info != null && info.progress.isNotEmpty)
                    SecondaryContractProgress(entries: info.progress),
                  if (widget.sign && info?.canSign == true)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: AppButton(
                        label: l.secondaryMarketSign,
                        onPressed: loaded ? openSignature : null,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
