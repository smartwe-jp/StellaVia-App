import 'package:flutter/material.dart';
import '../../../host_miles/presentation/support/host_miles_rank_theme.dart';
import '../support/home_text_styles.dart';

class HomeRankProgression extends StatelessWidget {
  const HomeRankProgression({super.key, required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) => Semantics(
    label: names.join(', '),
    child: LayoutBuilder(
      builder: (context, constraints) {
        if (names.isEmpty) return const SizedBox.shrink();
        final visibleWidth = constraints.maxWidth / names.length;
        return SizedBox(
          height: 99,
          width: double.infinity,
          child: Stack(
            children: [
              for (var i = 0; i < names.length; i++)
                Positioned(
                  left: i * visibleWidth,
                  top: 0,
                  bottom: 0,
                  width: visibleWidth + 16,
                  child: _RankPreview(
                    name: names[i],
                    visibleWidth: visibleWidth,
                  ),
                ),
            ],
          ),
        );
      },
    ),
  );
}

String _rankLabel(String name) {
  final number = HostMilesRankTheme.of(name).number;
  return number == null ? 'RANK' : 'RANK $number';
}

class _RankPreview extends StatelessWidget {
  const _RankPreview({required this.name, required this.visibleWidth});
  final double visibleWidth;
  final String name;
  @override
  Widget build(BuildContext context) {
    final palette = HostMilesRankTheme.of(name);
    return ExcludeSemantics(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(11.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 56),
              alignment: Alignment.centerLeft,
              decoration: palette.headerDecoration,
              child: SizedBox(
                width: visibleWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _rankLabel(name),
                          style: HomeTextStyles.rankPreviewEyebrow(context)
                              .copyWith(
                                color: palette.headerInk.withValues(alpha: .75),
                              ),
                        ),
                        Text(
                          name,
                          style: HomeTextStyles.rankPreviewName(
                            context,
                          ).copyWith(color: palette.headerInk),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
