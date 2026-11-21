import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../support/home_simulation_theme.dart';

class SimulationAmountField extends StatefulWidget {
  const SimulationAmountField({
    super.key,
    required this.value,
    required this.display,
    required this.label,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final int value, min, max;
  final String display, label;
  final ValueChanged<double> onChanged;

  @override
  State<SimulationAmountField> createState() => _SimulationAmountFieldState();
}

class _SimulationAmountFieldState extends State<SimulationAmountField> {
  late final _controller = TextEditingController(text: widget.display);
  late final _focus = FocusNode()..addListener(_focusChanged);

  void _focusChanged() {
    if (_focus.hasFocus) {
      final digits = widget.value.toString();
      _controller.value = TextEditingValue(
        text: digits,
        selection: TextSelection(baseOffset: 0, extentOffset: digits.length),
      );
    } else {
      final entered = int.tryParse(_controller.text);
      final units = entered?.clamp(widget.min, widget.max) ?? widget.value;
      if (units != widget.value) widget.onChanged(units.toDouble());
      _controller.text = units == widget.value
          ? widget.display
          : units.toString();
    }
  }

  @override
  void didUpdateWidget(SimulationAmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus) {
      if (_controller.text != widget.display) _controller.text = widget.display;
    } else if (oldWidget.value != widget.value &&
        int.tryParse(_controller.text) != widget.value) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_focusChanged);
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 92,
    child: TextField(
      controller: _controller,
      focusNode: _focus,
      textAlign: TextAlign.end,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      style: HomeSimulationTheme.inputNumber(context),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.label,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      onTapOutside: (_) => _focus.unfocus(),
      onChanged: (text) {
        final units = int.tryParse(text);
        if (units != null && units >= widget.min && units <= widget.max) {
          widget.onChanged(units.toDouble());
        }
      },
    ),
  );
}
