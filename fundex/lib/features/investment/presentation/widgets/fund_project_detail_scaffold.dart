import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailScaffold extends StatelessWidget {
  const FundProjectDetailScaffold({
    super.key,
    required this.body,
    this.actionBar,
  });

  final Widget body;
  final Widget? actionBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: body,
      bottomNavigationBar: actionBar,
    );
  }
}
