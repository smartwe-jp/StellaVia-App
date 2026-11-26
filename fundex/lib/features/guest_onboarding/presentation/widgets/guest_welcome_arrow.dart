import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import '../../../../app/localization/app_localizations_ext.dart';

class GuestWelcomeArrow extends StatefulWidget {
  const GuestWelcomeArrow({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<GuestWelcomeArrow> createState() => _GuestWelcomeArrowState();
}

class _GuestWelcomeArrowState extends State<GuestWelcomeArrow>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );
  late final _offset = Tween<Offset>(
    begin: const Offset(0, -0.125),
    end: const Offset(0, 0.125),
  ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context) ||
        !TickerMode.valuesOf(context).enabled ||
        ModalRoute.isCurrentOf(context) == false) {
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: context.l10n.guestGuideLearn,
    onPressed: widget.onPressed,
    icon: SlideTransition(
      position: _offset,
      child: Icon(
        Icons.arrow_downward_rounded,
        size: 22,
        color: context.appColors.onDark,
      ),
    ),
  );
}
