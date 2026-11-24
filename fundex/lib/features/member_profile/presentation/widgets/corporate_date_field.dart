import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CorporateDateField extends StatefulWidget {
  const CorporateDateField({
    super.key,
    required this.label,
    required this.requiredLabel,
    required this.initialValue,
    this.lastDate,
    required this.validator,
    required this.onChanged,
  });

  final DateTime? lastDate;
  final String label, initialValue;
  final String? requiredLabel;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChanged;

  @override
  State<CorporateDateField> createState() => _CorporateDateFieldState();
}

class _CorporateDateFieldState extends State<CorporateDateField> {
  late final controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final latest = widget.lastDate ?? DateUtils.dateOnly(DateTime.now());
    final current = DateTime.tryParse(controller.text);
    final first = DateTime(1);
    final picked = await showDatePicker(
      context: context,
      initialDate:
          current != null && !current.isBefore(first) && !current.isAfter(latest)
          ? current
          : latest,
      firstDate: first,
      lastDate: latest,
    );
    if (picked == null || !mounted) return;
    final value = picked.toIso8601String().split('T').first;
    controller.text = value;
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppFieldLabel(label: widget.label, requiredLabel: widget.requiredLabel),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        readOnly: true,
        onTap: pickDate,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          hintText: 'YYYY-MM-DD',
          suffixIcon: Icon(CupertinoIcons.calendar),
        ),
      ),
    ],
  );
}
