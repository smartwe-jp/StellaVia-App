import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HomeDataStatus extends StatelessWidget {
  const HomeDataStatus({
    super.key,
    required this.isLoading,
    required this.hasError,
    this.onRetry,
  });
  final bool isLoading;
  final bool hasError;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    if (isLoading) return const LinearProgressIndicator();
    if (!hasError) return const SizedBox.shrink();
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.homeDataLoadError,
            style: context.appTextTheme.caption,
          ),
        ),
        AppButton(
          label: context.l10n.commonRetry,
          variant: AppButtonVariant.text,
          fullWidth: false,
          onPressed: onRetry,
        ),
      ],
    );
  }
}
