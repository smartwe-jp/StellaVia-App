import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../../../../app/localization/app_localizations_ext.dart";
import "../../domain/entities/beneficial_owner.dart";
import "../../domain/entities/corporate_form_draft.dart";
import "../support/beneficial_owner_labels.dart";
import "../support/corporate_form_fields.dart";
import "../widgets/corporate_form_header.dart";
import "../widgets/verification_entry_scaffold.dart";

class BeneficialOwnerEditor extends StatefulWidget {
  const BeneficialOwnerEditor({super.key, this.person});
  final BeneficialOwner? person;
  @override
  State<BeneficialOwnerEditor> createState() => _BeneficialOwnerEditorState();
}

class _BeneficialOwnerEditorState extends State<BeneficialOwnerEditor> {
  final form = GlobalKey<FormState>();
  late String name, birthdate, country, address, percentage;
  OwnerControl? control;
  @override
  void initState() {
    super.initState();
    final p = widget.person;
    name = p?.name ?? "";
    birthdate = p?.birthdate ?? "";
    country = p?.country ?? "";
    address = p?.address ?? "";
    percentage = p?.percentage ?? "";
    control = p?.control;
  }

  void save() {
    final invalid = form.currentState!.validateGranularly();
    if (invalid.isNotEmpty) {
      Scrollable.ensureVisible(invalid.first.context, alignment: 0.15);
      return;
    }
    form.currentState!.save();
    Navigator.of(context).pop(
      BeneficialOwner(
        name: name,
        birthdate: birthdate,
        country: country,
        address: address,
        control: control!,
        percentage: percentage,
      ),
    );
  }

  Widget input(
    String label,
    String initial,
    ValueChanged<String> onSave, {
    bool optional = false,
    bool date = false,
  }) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel(
            label: label,
            requiredLabel: optional ? null : l.corpFormRequired,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initial,
            keyboardType: date ? TextInputType.datetime : TextInputType.text,
            decoration: InputDecoration(hintText: date ? "YYYY-MM-DD" : null),
            validator: (value) {
              final text = value?.trim() ?? "";
              if (optional) return null;
              if (date) {
                return corporateFieldError(
                  l,
                  CorporateSection.owners,
                  CorporateField.birth,
                  text,
                );
              }
              return text.isEmpty ? l.corpFormMissing : null;
            },
            onSaved: (value) => onSave(value!.trim()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return VerificationEntryScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CorporateFormHeader(
                section: CorporateSection.owners,
                heading: widget.person == null
                    ? l.corpOwnerAdd
                    : l.corpOwnerEdit,
              ),
              const SizedBox(height: 20),
              input(l.corpFormName, name, (v) => name = v),
              input(
                l.corpFormBirth,
                birthdate,
                (v) => birthdate = v,
                date: true,
              ),
              input(l.corpOwnerCountry, country, (v) => country = v),
              input(l.corpFormAddress, address, (v) => address = v),
              AppFieldLabel(
                label: l.corpOwnerControl,
                requiredLabel: l.corpFormRequired,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<OwnerControl>(
                initialValue: control,
                isExpanded: true,
                icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                items: [
                  for (final type in OwnerControl.values)
                    DropdownMenuItem(
                      value: type,
                      child: Text(ownerControlLabel(l, type)),
                    ),
                ],
                onChanged: (v) => control = v,
                validator: (v) => v == null ? l.corpFormMissing : null,
              ),
              const SizedBox(height: 16),
              input(
                "${l.corpOwnerPercentage} (${l.registerOptionalBadge})",
                percentage,
                (v) => percentage = v,
                optional: true,
              ),
              AppButton(
                label: widget.person == null
                    ? l.corpOwnerConfirmAdd
                    : l.corpOwnerSave,
                onPressed: save,
              ),
              const SizedBox(height: 12),
              AppButton(
                label: l.commonCancel,
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
