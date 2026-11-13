import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../member_profile/presentation/providers/mypage_membership_providers.dart';
import '../controllers/secondary_contract_provider.dart';
import '../widgets/secondary_contract_signature_pad.dart';

class SecondarySignaturePage extends ConsumerStatefulWidget {
  const SecondarySignaturePage({
    super.key,
    required this.id,
    required this.identity,
  });
  final String id;
  final Object identity;

  @override
  ConsumerState<SecondarySignaturePage> createState() => _SignatureState();
}

class _SignatureState extends ConsumerState<SecondarySignaturePage> {
  bool submitting = false, failed = false;

  Future<void> submit(Uint8List png) async {
    if (submitting ||
        ref.read(myPageMembershipIdentityProvider) != widget.identity) {
      return;
    }
    setState(() => submitting = true);
    try {
      await ref.read(secondaryContractClientProvider).sign(widget.id, png);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) setState(() => failed = true);
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final active =
        ref.watch(myPageMembershipIdentityProvider) == widget.identity;
    return PopScope(
      canPop: !submitting,
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => RotatedBox(
              quarterTurns: constraints.maxHeight > constraints.maxWidth
                  ? 1
                  : 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: l.commonClose,
                          onPressed: submitting
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                        Expanded(
                          child: Text(
                            l.secondaryMarketSign,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    if (submitting) const LinearProgressIndicator(),
                    Expanded(
                      child: !active || failed
                          ? Center(
                              child: Text(l.secondaryMarketSignatureFailed),
                            )
                          : SecondaryContractSignaturePad(onConfirm: submit),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
