import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class HostFundContent<T> extends StatelessWidget {
  const HostFundContent({
    super.key,
    required this.state,
    required this.retry,
    required this.builder,
  });
  final AsyncValue<T> state;
  final VoidCallback retry;
  final Widget Function(T) builder;
  @override
  Widget build(BuildContext context) => state.when(
    skipLoadingOnReload: false,
    data: builder,
    loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    error: (_, __) => AppCard(
      child: Column(
        children: [
          Text(context.l10n.myPageChartLoadFailed),
          TextButton(onPressed: retry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    ),
  );
}

class HostFundEmpty extends StatelessWidget {
  const HostFundEmpty(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      children: [
        Text(message),
        TextButton(
          onPressed: () => context.go('/funds'),
          child: Text(context.l10n.hostManageGoFundList),
        ),
      ],
    ),
  );
}
