import 'dart:math' as math;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
    required this.cards,
    this.status,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;
  final List<Widget> cards;
  final Widget? status;

  @override
  Widget build(BuildContext context) {
    const inset = EdgeInsets.symmetric(horizontal: UiTokens.spacing16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: inset,
          child: AppSectionHeader(
            title: title,
            actionLabel: actionLabel,
            onActionTap: onActionTap,
          ),
        ),
        const SizedBox(height: 8),
        if (status != null) Padding(padding: inset, child: status!),
        if (cards.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final width = math.min(
                320.0,
                math.max(0.0, constraints.maxWidth - inset.horizontal),
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: inset,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      for (final card in cards)
                        SizedBox(width: width, child: card),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
