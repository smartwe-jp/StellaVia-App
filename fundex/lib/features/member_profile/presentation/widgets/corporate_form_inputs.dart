import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/corporate_form_draft.dart';
import '../support/corporate_form_fields.dart';

class CorporateFormInput extends StatefulWidget {
  const CorporateFormInput({
    super.key,
    required this.draft,
    required this.section,
    required this.field,
    required this.onStructureChanged,
  });
  final CorporateFormDraft draft;
  final CorporateSection section;
  final CorporateField field;
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
            validator: (v) => corporateFieldError(l, s, f, v ?? ''),
            onChanged: (v) {
              if (v == null) return;
              widget.draft.set(s, f, v);
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
    final date = f == CorporateField.birth || f == CorporateField.founded;
    return AppTextField(
      inputKey: ValueKey(f),
      controller: controller,
      label: label,
      requiredLabel: required,
      hintText: date ? 'YYYY-MM-DD' : null,
      keyboardType: switch (f) {
        CorporateField.branchCode ||
        CorporateField.accountNumber ||
        CorporateField.number ||
        CorporateField.postal => TextInputType.number,
        CorporateField.phone => TextInputType.phone,
        CorporateField.email => TextInputType.emailAddress,
        CorporateField.birth ||
        CorporateField.founded => TextInputType.datetime,
        _ => TextInputType.text,
      },
      validator: (v) => corporateFieldError(l, s, f, v ?? ''),
      onChanged: (v) => widget.draft.set(s, f, v),
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
