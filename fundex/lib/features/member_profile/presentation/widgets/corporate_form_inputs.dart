import '../support/corporate_draft_autosave.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/presentation/providers/settings_two_factor_providers.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_form_fields.dart';
import 'corporate_date_field.dart';

class CorporateLoginEmail extends ConsumerWidget {
  const CorporateLoginEmail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final email = ref.watch(settingsVerifiedEmailProvider).asData?.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(label: l.corpLoginEmail),
        const SizedBox(height: 8),
        Text(email ?? '—', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class CorporateFormInput extends StatefulWidget {
  const CorporateFormInput({
    super.key,
    required this.draft,
    required this.section,
    required this.field,
    this.extraValidation,
    this.onTextChanged,
    this.focusNode,
    this.trailingAction,
    required this.onStructureChanged,
  });
  final CorporateFormDraft draft;
  final CorporateSection section;
  final CorporateField field;
  final String? Function()? extraValidation;
  final ValueChanged<String>? onTextChanged;
  final FocusNode? focusNode;
  final Widget? trailingAction;
  final VoidCallback onStructureChanged;
  @override
  State<CorporateFormInput> createState() => _CorporateFormInputState();
}

class _CorporateFormInputState extends State<CorporateFormInput> {
  late final controller = TextEditingController(
    text: widget.draft.value(widget.section, widget.field),
  );
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.field, s = widget.section, l = context.l10n;
    final label = requiredField(s, f)
            ? corporateFieldLabel(l, f)
            : "${corporateFieldLabel(l, f)} (${l.registerOptionalBadge})",
        required = requiredField(s, f) ? l.corpFormRequired : null;
    final options = pickerOptions(l, f);
    if (options.isNotEmpty) {
      final value = widget.draft.value(s, f);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel(label: label, requiredLabel: required),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: options.containsKey(value) ? value : null,
            isExpanded: true,
            icon: const Icon(CupertinoIcons.chevron_down, size: 16),
            decoration: const InputDecoration(
              constraints: BoxConstraints(minHeight: 52),
            ),
            items: [
              for (final e in options.entries)
                DropdownMenuItem(value: e.key, child: Text(e.value)),
            ],
            validator: (v) =>
                corporateFieldError(l, s, f, v ?? '') ??
                widget.extraValidation?.call(),
            onChanged: (v) {
              if (v == null) return;
              widget.draft.set(s, f, v);
              autosaveCorporateDraft(context, widget.draft);
              widget.onStructureChanged();
            },
          ),
          if (f == CorporateField.bankName)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l.corpBankOtherHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      );
    }
    if (f == CorporateField.birth || f == CorporateField.founded) {
      return CorporateDateField(
        lastDate: f == CorporateField.birth ? latestAdultBirthDate() : null,
        key: ValueKey(f),
        label: label,
        requiredLabel: required,
        initialValue: widget.draft.value(s, f),
        validator: (v) =>
            corporateFieldError(l, s, f, v ?? '') ??
            widget.extraValidation?.call(),
        onChanged: (v) {
          widget.draft.set(s, f, v);
          autosaveCorporateDraft(context, widget.draft);
          widget.onTextChanged?.call(v);
        },
      );
    }
    final action = widget.trailingAction;
    final input = AppTextField(
      inputKey: ValueKey(f),
      controller: controller,
      focusNode: widget.focusNode,
      label: action == null ? label : null,
      requiredLabel: required,
      maxLines: f == CorporateField.business ? 4 : 1,
      keyboardType: switch (f) {
        CorporateField.business => TextInputType.multiline,
        CorporateField.branchCode ||
        CorporateField.accountNumber ||
        CorporateField.number ||
        CorporateField.postal => TextInputType.number,
        CorporateField.phone => TextInputType.phone,
        CorporateField.email => TextInputType.emailAddress,
        _ => TextInputType.text,
      },
      validator: (v) =>
          corporateFieldError(l, s, f, v ?? '') ??
          widget.extraValidation?.call(),
      onChanged: (v) {
        widget.draft.set(s, f, v);
        autosaveCorporateDraft(context, widget.draft);
        widget.onTextChanged?.call(v);
      },
    );
    if (action == null) return input;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppFieldLabel(label: label, requiredLabel: required),
        const SizedBox(height: UiTokens.spacing8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Semantics(label: label, child: input),
            ),
            const SizedBox(width: UiTokens.spacing8),
            Expanded(flex: 2, child: action),
          ],
        ),
      ],
    );
  }
}

class CorporateHandlerChoice extends StatelessWidget {
  const CorporateHandlerChoice({
    super.key,
    required this.draft,
    required this.onChanged,
  });
  final CorporateFormDraft draft;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) {
    final l = context.l10n, theme = Theme.of(context);
    return FormField<CorporateHandler>(
      initialValue: draft.handler,
      validator: (v) => v == null ? l.corpFormMissing : null,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final type in CorporateHandler.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: field.value == type
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                child: ListTile(
                  selected: field.value == type,
                  leading: Icon(
                    field.value == type
                        ? CupertinoIcons.largecircle_fill_circle
                        : CupertinoIcons.circle,
                  ),
                  title: Text(
                    type == CorporateHandler.delegate
                        ? l.corpFormDelegate
                        : l.corpFormSelf,
                  ),
                  subtitle: Text(
                    type == CorporateHandler.delegate
                        ? l.corpFormDelegateHint
                        : l.corpFormSelfHint,
                  ),
                  onTap: () {
                    draft.handler = type;
                    autosaveCorporateDraft(context, draft);
                    field.didChange(type);
                    onChanged();
                  },
                ),
              ),
            ),
          if (field.hasError)
            Text(
              field.errorText!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
        ],
      ),
    );
  }
}
