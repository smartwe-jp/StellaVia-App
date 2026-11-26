import 'package:flutter/material.dart';

class StellaviaWordmark extends StatelessWidget {
  const StellaviaWordmark({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    'STELLAVIA',
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
      fontFamily: 'Jost',
      color: color,
      fontSize: 21,
      fontWeight: FontWeight.w500,
      letterSpacing: 2.8,
    ),
  );
}
