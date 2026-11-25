import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

/// Shared vertical rhythm of the three guest account screens.
class GuestAccountLayout extends StatelessWidget {
  const GuestAccountLayout({
    super.key,
    required this.title,
    this.leading,
    required this.children,
  });
  final String title;
  final Widget? leading;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.surface,
      appBar: AppNavigationBar(
        title: title,
        leading: leading,
        backgroundColor: context.appColors.surface,
        foregroundColor: context.appColors.textPrimary,
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuestAccountLink extends StatelessWidget {
  const GuestAccountLink(
    this.label, {
    super.key,
    required this.onTap,
    this.icon,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: TextButton(
      style: TextButton.styleFrom(
        alignment: AlignmentDirectional.centerStart,
        minimumSize: const Size(0, 36),
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: context.appColors.primary,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 9)],
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

class GuestAccountButton extends StatelessWidget {
  const GuestAccountButton(
    this.label, {
    super.key,
    required this.onTap,
    this.alignDisabled = false,
  });
  final String label;
  final VoidCallback? onTap;
  final bool alignDisabled;
  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      shape: const StadiumBorder(),
      minimumSize: const Size.fromHeight(50),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: alignDisabled && onTap == null
          ? AlignmentDirectional.centerStart
          : Alignment.center,
      textStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      disabledForegroundColor: context.appColors.textSecondary,
      disabledBackgroundColor: context.appColors.textSecondary.withValues(
        alpha: .14,
      ),
    ),
    onPressed: onTap,
    child: Text(label),
  );
}

class GuestAccountPanel extends StatelessWidget {
  const GuestAccountPanel({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Color.alphaBlend(
        context.appColors.surfaceAlt.withValues(alpha: .65),
        context.appColors.surface,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
}
