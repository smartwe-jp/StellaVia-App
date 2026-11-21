import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeActionIcon extends StatelessWidget {
  const HomeActionIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: context.appColors.primarySubtle,
      borderRadius: BorderRadius.circular(UiTokens.radius8),
    ),
    child: Icon(icon, size: 22, color: context.appColors.primary),
  );
}
