import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Theme.of(context).appColors.brandPrimary,
      ),
    );
  }
}
