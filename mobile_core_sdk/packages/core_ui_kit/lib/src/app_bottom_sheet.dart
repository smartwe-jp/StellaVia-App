import 'package:flutter/material.dart';

import 'ui_tokens.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> showAdaptive<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
      showDragHandle: false,
      backgroundColor: Theme.of(context).bottomSheetTheme.backgroundColor,
      shape: Theme.of(context).bottomSheetTheme.shape,
      builder: (BuildContext bottomSheetContext) {
        return _BottomSheetFrame(child: builder(bottomSheetContext));
      },
    );
  }
}

class _BottomSheetFrame extends StatelessWidget {
  const _BottomSheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: UiTokens.spacing16,
        right: UiTokens.spacing16,
        top: UiTokens.spacing12,
        bottom: UiTokens.spacing16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: UiTokens.spacing16),
              Flexible(fit: FlexFit.loose, child: child),
            ],
          );
        },
      ),
    );
  }
}
