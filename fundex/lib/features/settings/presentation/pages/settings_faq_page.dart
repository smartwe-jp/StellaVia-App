import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/settings_faq_content.dart';

class SettingsFaqPage extends StatefulWidget {
  const SettingsFaqPage({super.key});

  @override
  State<SettingsFaqPage> createState() => _SettingsFaqPageState();
}

class _SettingsFaqPageState extends State<SettingsFaqPage> {
  static const String _desktopHeroImageUrl =
      'https://testoa.gutingjun.com/img/faqbannew.62b44bc3.jpg';
  static const String _mobileHeroImageUrl =
      'https://testoa.gutingjun.com/img/faq05.6d27b3af.jpg';

  Future<SettingsFaqContent>? _contentFuture;
  String? _loadedLocaleTag;
  final Set<String> _expandedItemIds = <String>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    if (_loadedLocaleTag == localeTag && _contentFuture != null) {
      return;
    }
    _loadedLocaleTag = localeTag;
    _contentFuture = SettingsFaqContent.load(localeTag);
  }

  void _toggleItem(String itemId) {
    setState(() {
      if (_expandedItemIds.contains(itemId)) {
        _expandedItemIds.remove(itemId);
      } else {
        _expandedItemIds.add(itemId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppNavigationBar(
        title: l10n.menuItemFaqHelp,
        leading: AppNavigationIconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => context.pop(),
        ),
      ),
      body: FutureBuilder<SettingsFaqContent>(
        future: _contentFuture,
        builder:
            (BuildContext context, AsyncSnapshot<SettingsFaqContent> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      l10n.uiErrorRequestFailed,
                      textAlign: TextAlign.center,
                      style: appText.body.copyWith(color: colors.textSecondary),
                    ),
                  ),
                );
              }

              final content = snapshot.data!;
              return ListView(
                padding: const EdgeInsets.only(bottom: 28),
                children: <Widget>[
                  _FaqHeroBanner(title: content.heroTitle),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        for (
                          int sectionIndex = 0;
                          sectionIndex < content.sections.length;
                          sectionIndex += 1
                        ) ...<Widget>[
                          if (sectionIndex > 0) const SizedBox(height: 24),
                          _FaqSectionHeader(
                            title: content.sections[sectionIndex].title,
                          ),
                          const SizedBox(height: 10),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(
                                UiTokens.radius16,
                              ),
                              border: Border.all(color: colors.border),
                            ),
                            child: Column(
                              children: <Widget>[
                                for (
                                  int itemIndex = 0;
                                  itemIndex <
                                      content
                                          .sections[sectionIndex]
                                          .items
                                          .length;
                                  itemIndex += 1
                                )
                                  _FaqAccordionItem(
                                    index: itemIndex + 1,
                                    item: content
                                        .sections[sectionIndex]
                                        .items[itemIndex],
                                    expanded: _expandedItemIds.contains(
                                      '$sectionIndex-$itemIndex',
                                    ),
                                    isLast:
                                        itemIndex ==
                                        content
                                                .sections[sectionIndex]
                                                .items
                                                .length -
                                            1,
                                    onTap: () =>
                                        _toggleItem('$sectionIndex-$itemIndex'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}

class _FaqHeroBanner extends StatelessWidget {
  const _FaqHeroBanner({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final width = MediaQuery.sizeOf(context).width;
    final imageUrl = width < 640
        ? _SettingsFaqPageState._mobileHeroImageUrl
        : _SettingsFaqPageState._desktopHeroImageUrl;

    return SizedBox(
      width: double.infinity,
      height: 188,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[colors.heroStart, colors.heroMiddle],
                  ),
                ),
              );
            },
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.38),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Text(
              title,
              style: appText.pageTitle.copyWith(color: colors.onDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqSectionHeader extends StatelessWidget {
  const _FaqSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        border: Border(left: BorderSide(color: colors.primary, width: 8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Text(
          title,
          style: appText.sectionTitle.copyWith(color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _FaqAccordionItem extends StatelessWidget {
  const _FaqAccordionItem({
    required this.index,
    required this.item,
    required this.expanded,
    required this.onTap,
    required this.isLast,
  });

  final int index;
  final SettingsFaqItem item;
  final bool expanded;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: expanded
            ? colors.primarySubtle.withValues(alpha: 0.32)
            : colors.surface,
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.borderSoft)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Q$index.',
                      style: appText.bodyStrong.copyWith(color: colors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.question,
                        style: appText.bodyStrong.copyWith(
                          color: colors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: colors.primary,
                      size: 22,
                    ),
                  ],
                ),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 14,
                      left: 34,
                      right: 4,
                      bottom: 4,
                    ),
                    child: Text(
                      item.answer,
                      style: appText.body.copyWith(
                        color: colors.textSecondary,
                        height: 1.8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
