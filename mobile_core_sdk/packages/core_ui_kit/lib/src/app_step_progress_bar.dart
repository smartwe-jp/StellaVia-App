import 'package:flutter/material.dart';

import 'app_theme_extensions.dart';

class AppStepProgressBar extends StatefulWidget {
  const AppStepProgressBar({
    super.key,
    required this.stepCount,
    required this.currentStep,
    this.padding = const EdgeInsets.fromLTRB(20, 14, 20, 14),
    this.spacing = 4,
    this.height = 4,
    this.completedColor,
    this.currentColor,
    this.pendingColor,
    this.enablePulse = true,
  }) : assert(stepCount > 0),
       assert(currentStep >= 0),
       assert(currentStep < stepCount);

  final int stepCount;
  final int currentStep;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double height;
  final Color? completedColor;
  final Color? currentColor;
  final Color? pendingColor;
  final bool enablePulse;

  @override
  State<AppStepProgressBar> createState() => _AppStepProgressBarState();
}

class _AppStepProgressBarState extends State<AppStepProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.enablePulse) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AppStepProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enablePulse == oldWidget.enablePulse) {
      return;
    }
    if (widget.enablePulse) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final completedColor = widget.completedColor ?? colors.primary;
    final currentColor = widget.currentColor ?? colors.primary;
    final pendingColor = widget.pendingColor ?? colors.borderSoft;
    return Padding(
      padding: widget.padding,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (BuildContext context, Widget? child) {
          return Row(
            children: List<Widget>.generate(widget.stepCount, (int index) {
              final bool isDone = index < widget.currentStep;
              final bool isCurrent = index == widget.currentStep;
              final Color color = isDone
                  ? completedColor
                  : isCurrent
                  ? Color.lerp(
                      currentColor.withValues(alpha: 0.52),
                      currentColor,
                      widget.enablePulse ? _pulse.value : 1,
                    )!
                  : pendingColor;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == widget.stepCount - 1 ? 0 : widget.spacing,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                    ),
                    child: SizedBox(height: widget.height),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
