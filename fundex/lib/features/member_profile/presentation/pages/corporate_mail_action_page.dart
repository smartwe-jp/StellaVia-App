import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/repositories/verification_entry_repository.dart';
import '../providers/verification_entry_provider.dart';
import '../widgets/corporate_mail_fields.dart';
import '../widgets/verification_entry_scaffold.dart';

class CorporateMailActionPage extends ConsumerStatefulWidget {
  const CorporateMailActionPage({
    super.key,
    required this.action,
    required this.id,
  });
  final CorporateMailAction action;
  final int id;
  @override
  ConsumerState<CorporateMailActionPage> createState() =>
      _CorporateMailActionPageState();
}

class _CorporateMailActionPageState
    extends ConsumerState<CorporateMailActionPage> {
  final message = TextEditingController();
  bool busy = false;
  String? error;
  bool get sendingOriginals => widget.action == CorporateMailAction.sent;
  bool allowed(AsyncValue<VerificationEntry> detail) {
    final entry = detail.asData?.value;
    return !detail.isLoading &&
        entry != null &&
        entry.kind == VerificationEntryKind.corporate &&
        entry.applicationId == widget.id &&
        entry.userOps.contains(widget.action.code);
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  Future<void> confirm() async {
    final text = message.text.trim();
    if (busy ||
        !allowed(ref.read(verificationEntryProvider)) ||
        (sendingOriginals && text.isEmpty)) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await ref
          .read(verificationEntryRepositoryProvider)
          .review(id: widget.id, action: widget.action, message: text);
    } on StateError {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = context.l10n.uiErrorRequestFailed;
      });
      ref.invalidate(verificationEntryProvider);
      return;
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.corpMailUnknown)));
    }
    if (!mounted) return;
    ref.invalidate(verificationEntryProvider);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n, detail = ref.watch(verificationEntryProvider);
    final permitted = allowed(detail);
    const style = ButtonStyle(shape: WidgetStatePropertyAll(StadiumBorder()));
    return PopScope(
      canPop: !busy,
      child: VerificationEntryScaffold(
        resultPage: true,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: CorporateMailFields(
                  sendingOriginals: sendingOriginals,
                  controller: message,
                  enabled: !busy && permitted,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!permitted && !detail.isLoading)
                      Text(l.corpMailUnavailable),
                    if (error != null)
                      Text(
                        error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    if (busy) const LinearProgressIndicator(),
                    AppButton(
                      style: style,
                      label: sendingOriginals
                          ? l.corpMailSubmit
                          : l.corpMailConfirm,
                      onPressed:
                          !busy &&
                              permitted &&
                              (!sendingOriginals ||
                                  message.text.trim().isNotEmpty)
                          ? confirm
                          : null,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      style: style,
                      label: sendingOriginals
                          ? l.commonCancel
                          : l.corpMailNotYet,
                      variant: AppButtonVariant.secondary,
                      onPressed: busy
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
