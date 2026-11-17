import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class StellaviaWordmark extends StatelessWidget {
  const StellaviaWordmark({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    'STELLAVIA',
    style: context.appTextTheme.numericTitle.copyWith(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
  );
}
