import "package:core_ui_kit/core_ui_kit.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "../../../../app/localization/app_localizations_ext.dart";
import "../../domain/entities/beneficial_owner.dart";
import "../../domain/entities/corporate_form_draft.dart";
import "../pages/beneficial_owner_editor.dart";
import "../support/beneficial_owner_labels.dart";

class BeneficialOwnerList extends StatefulWidget {
  const BeneficialOwnerList({super.key, required this.draft});
  final CorporateFormDraft draft;
  @override
  State<BeneficialOwnerList> createState() => _BeneficialOwnerListState();
}

class _BeneficialOwnerListState extends State<BeneficialOwnerList> {
  Future<void> edit([BeneficialOwner? previous]) async {
    final person = await Navigator.of(context).push<BeneficialOwner>(
      MaterialPageRoute(
        builder: (_) =>
            BeneficialOwnerEditor(person: previous, draft: widget.draft),
      ),
    );
    if (!mounted || person == null) return;
    final owners = widget.draft.owners;
    setState(() {
      if (previous == null) {
        owners.add(person);
      } else {
        owners[owners.indexOf(previous)] = person;
      }
    });
  }

  Future<void> remove(BeneficialOwner person) async {
    final l = context.l10n;
    final confirmed = await AppDialogs.showAdaptiveAlert<bool>(
      context: context,
      title: l.corpOwnerDeletePrompt,
      message: person.name,
      actions: [
        AppDialogAction(label: l.commonCancel, value: false),
        AppDialogAction(
          label: l.corpOwnerDelete,
          value: true,
          isDestructive: true,
        ),
      ],
    );
    if (mounted && confirmed == true) {
      setState(() => widget.draft.owners.remove(person));
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft, l = context.l10n, theme = Theme.of(context);
    return FormField<OwnerPresence>(
      initialValue: draft.ownerPresence,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value == null
          ? l.corpFormMissing
          : draft.ownersComplete
          ? null
          : draft.owners.isEmpty
          ? l.corpOwnerMinimum
          : l.corpFormMissing,
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l.corpOwnerDefinition),
            ),
          ),
          for (final status in OwnerPresence.values)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: field.value == status
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
              child: ListTile(
                selected: field.value == status,
                leading: Icon(
                  field.value == status
                      ? CupertinoIcons.largecircle_fill_circle
                      : CupertinoIcons.circle,
                ),
                title: Text(ownerPresenceLabel(l, status)),
                onTap: () {
                  draft.ownerPresence = status;
                  field.didChange(status);
                },
              ),
            ),
          if (field.hasError)
            Text(
              field.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          if (field.value == OwnerPresence.yes) ...[
            const SizedBox(height: 16),
            Text(l.corpOwnerList, style: theme.textTheme.titleMedium),
            for (final person in draft.owners)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(person.name, style: theme.textTheme.titleMedium),
                      Text(
                        [
                          ownerControlLabel(l, person.control),
                          if (person.percentage.isNotEmpty) person.percentage,
                        ].join(" ／ "),
                      ),
                      Wrap(
                        children: [
                          TextButton(
                            onPressed: () => edit(person),
                            child: Text(l.commonEditText),
                          ),
                          TextButton(
                            onPressed: () => remove(person),
                            child: Text(l.corpOwnerDelete),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            AppButton(
              label: l.corpOwnerAdd,
              variant: AppButtonVariant.secondary,
              onPressed: () => edit(),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
