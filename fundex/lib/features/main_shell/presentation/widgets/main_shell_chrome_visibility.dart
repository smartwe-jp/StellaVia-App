import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/main_shell_providers.dart';

class MainShellChromeVisibility extends ConsumerWidget {
  const MainShellChromeVisibility({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reveal = ref
        .watch(mainShellChromeRevealProvider)
        .clamp(0, 1)
        .toDouble();
    return ClipRect(
      child: Opacity(
        opacity: reveal,
        child: Align(
          heightFactor: reveal,
          alignment: Alignment.topCenter,
          child: FractionalTranslation(
            translation: Offset(0, reveal - 1),
            child: IgnorePointer(ignoring: reveal <= 0.01, child: child),
          ),
        ),
      ),
    );
  }
}
