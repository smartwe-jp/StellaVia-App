import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../investment/domain/entities/fund_project.dart';
import '../../../investment/presentation/providers/fund_project_providers.dart';
import '../../../member_profile/domain/entities/mypage_models.dart';
import '../../../member_profile/presentation/providers/mypage_providers.dart';
import '../../../member_profile/presentation/support/mypage_section_support.dart';
import '../../../member_profile/presentation/widgets/my_page_active_fund_summary_card.dart';
import 'kizunark_comment_composer_widgets.dart';

class KizunarkComposerFundPickerSheet extends ConsumerStatefulWidget {
  const KizunarkComposerFundPickerSheet({
    required this.currentSelection,
    super.key,
  });

  final SelectedComposerFund? currentSelection;

  @override
  ConsumerState<KizunarkComposerFundPickerSheet> createState() =>
      _KizunarkComposerFundPickerSheetState();
}

class _KizunarkComposerFundPickerSheetState
    extends ConsumerState<KizunarkComposerFundPickerSheet> {
  static const int _pageSize = 20;
  static const double _cardScrollExtent = 166;
  static const List<MyPageActiveFundFilter> _filters = <MyPageActiveFundFilter>[
    MyPageActiveFundFilter.all,
    MyPageActiveFundFilter.open,
    MyPageActiveFundFilter.operating,
    MyPageActiveFundFilter.ended,
  ];

  final ScrollController _scrollController = ScrollController();
  final List<MyPageInvestmentRecord> _records = <MyPageInvestmentRecord>[];
  MyPageActiveFundFilter _selectedFilter = MyPageActiveFundFilter.all;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _error;
  int _nextPage = 1;
  int _loadGeneration = 0;
  String? _lastAutoScrolledProjectId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients ||
        _isInitialLoading ||
        _isLoadingMore ||
        !_hasMore) {
      return;
    }

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _loadNextPage();
    }
  }

  void _scheduleScrollToSelected(
    List<MyPageInvestmentRecord> records,
    SelectedComposerFund? selection,
  ) {
    final projectId = selection?.projectId;
    if (projectId == null || projectId.isEmpty) {
      return;
    }
    final selectionKey = selection?.selectionKey ?? '';
    final scrollKey = selectionKey.isNotEmpty ? selectionKey : projectId;
    if (_lastAutoScrolledProjectId == scrollKey) {
      return;
    }
    final selectedIndex = records.indexWhere((record) {
      if (selectionKey.isEmpty) {
        return record.projectId == projectId;
      }
      return _selectionKeyForRecord(record) == selectionKey;
    });
    if (selectedIndex < 0) {
      return;
    }
    _lastAutoScrolledProjectId = scrollKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }
      final position = _scrollController.position;
      final targetOffset = (selectedIndex * _cardScrollExtent).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  List<MyPageInvestmentRecord> get _filteredRecords {
    return filterInvestmentRecordsByActiveFundFilter(_records, _selectedFilter);
  }

  String _selectionKeyForRecord(MyPageInvestmentRecord record) {
    final recordIndex = _records.indexOf(record);
    final safeIndex = recordIndex < 0 ? 0 : recordIndex;
    final parts = <String>[
      record.projectId,
      record.processId ?? '',
      record.investorCode ?? '',
      record.createTime ?? '',
      record.status?.toString() ?? '',
      record.projectStatus?.toString() ?? '',
      record.investNum?.toString() ?? '',
      record.investMoney?.toString() ?? '',
      safeIndex.toString(),
    ];
    return parts.join('::');
  }

  bool _isRecordSelected(
    List<MyPageInvestmentRecord> records,
    MyPageInvestmentRecord record,
    int visibleIndex,
  ) {
    final selection = widget.currentSelection;
    if (selection == null || selection.isClearSelection) {
      return false;
    }
    if (selection.selectionKey.isNotEmpty) {
      return _selectionKeyForRecord(record) == selection.selectionKey;
    }
    return record.projectId == selection.projectId &&
        records.indexWhere((item) => item.projectId == selection.projectId) ==
            visibleIndex;
  }

  Future<void> _loadInitial({bool preserveContent = false}) async {
    final requestGeneration = ++_loadGeneration;
    final shouldPreserveContent = preserveContent && _records.isNotEmpty;
    setState(() {
      _isInitialLoading = !shouldPreserveContent;
      _isLoadingMore = shouldPreserveContent;
      _hasMore = true;
      _error = null;
      _nextPage = 1;
      if (!shouldPreserveContent) {
        _records.clear();
        _lastAutoScrolledProjectId = null;
      }
    });

    try {
      final records = await ref
          .read(fetchMyPageInvestmentListUseCaseProvider)
          .call(startPage: 1, limit: _pageSize);
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _records
          ..clear()
          ..addAll(records);
        _nextPage = 2;
        _hasMore = records.length >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
        _lastAutoScrolledProjectId = null;
      });
      await _loadNextPageIfFilterHasNoVisibleRecords();
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }
    final requestGeneration = _loadGeneration;
    setState(() {
      _isLoadingMore = true;
      _error = null;
    });

    try {
      final records = await ref
          .read(fetchMyPageInvestmentListUseCaseProvider)
          .call(startPage: _nextPage, limit: _pageSize);
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _records.addAll(records);
        _nextPage += 1;
        _hasMore = records.length >= _pageSize;
        _error = null;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
      await _loadNextPageIfFilterHasNoVisibleRecords();
    } catch (error) {
      if (!mounted || requestGeneration != _loadGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _loadNextPageIfFilterHasNoVisibleRecords() async {
    if (!mounted ||
        _filteredRecords.isNotEmpty ||
        !_hasMore ||
        _isLoadingMore) {
      return;
    }
    await _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);
    final sheetHeight = mediaQuery.size.height * 0.8;
    final fundProjects =
        ref.watch(fundProjectListProvider).valueOrNull ?? const <FundProject>[];
    final fundProjectsById = <String, FundProject>{
      for (final project in fundProjects) project.id: project,
    };

    return SizedBox(
      height: sheetHeight,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.kizunarkAssociateFundSheetTitle,
            style: appText.sectionTitle.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          AppFilterBar<MyPageActiveFundFilter>(
            value: _selectedFilter,
            onChanged: (MyPageActiveFundFilter value) {
              if (_selectedFilter == value) {
                return;
              }
              setState(() {
                _selectedFilter = value;
                _lastAutoScrolledProjectId = null;
              });
              _loadNextPageIfFilterHasNoVisibleRecords();
            },
            backgroundColor: colors.surface,
            borderRadius: BorderRadius.circular(999),
            padding: EdgeInsets.zero,
            selectedBackgroundColor: colors.primary,
            selectedForegroundColor: colors.onDark,
            unselectedBackgroundColor: colors.surfaceAlt,
            unselectedForegroundColor: colors.textSecondary,
            borderColor: colors.border,
            items: _filters
                .map(
                  (filter) => AppFilterBarItem<MyPageActiveFundFilter>(
                    value: filter,
                    label: resolveMyPageActiveFundFilterLabel(l10n, filter),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: _buildFundListContent(
              context,
              sheetHeight: sheetHeight,
              fundProjectsById: fundProjectsById,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundListContent(
    BuildContext context, {
    required double sheetHeight,
    required Map<String, FundProject> fundProjectsById,
  }) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final l10n = context.l10n;
    final currencyFormatter = NumberFormat.currency(
      locale: Localizations.localeOf(context).toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final displayRecords = _filteredRecords;
    _scheduleScrollToSelected(displayRecords, widget.currentSelection);

    if (_isInitialLoading && displayRecords.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (_error != null && displayRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                l10n.myPageSectionLoadError,
                textAlign: TextAlign.center,
                style: appText.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => _loadInitial(preserveContent: true),
                child: Text(l10n.fundListRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (displayRecords.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadInitial(preserveContent: true),
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: sheetHeight * 0.48,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 24,
                  ),
                  child: Text(
                    resolveMyPageActiveFundEmptyState(l10n, _selectedFilter),
                    textAlign: TextAlign.center,
                    style: appText.body.copyWith(color: colors.textSecondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadInitial(preserveContent: true),
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            displayRecords.length +
            ((_isLoadingMore || (_error != null && _records.isNotEmpty))
                ? 1
                : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (BuildContext context, int index) {
          if (index >= displayRecords.length) {
            if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Center(
                child: OutlinedButton(
                  onPressed: _loadNextPage,
                  child: Text(l10n.fundListRetry),
                ),
              ),
            );
          }

          final record = displayRecords[index];
          final selectionKey = _selectionKeyForRecord(record);
          final group = investmentRecordToGroup(record);
          final project = fundProjectsById[record.projectId];
          final status = project?.projectStatus ?? record.projectStatus;
          final periodText = formatMyPageActiveFundPeriod(context, project);
          final investorTypeDisplay = resolveInvestorTypeDisplayText(
            l10n,
            record.investorType,
            fallbackInvestorCode: record.investorCode,
            fallbackEarningType: group.earningType,
            fallbackEarningRatio: group.earningRatio,
          );
          final isSelected = _isRecordSelected(displayRecords, record, index);
          return _ComposerFundPickerCard(
            data: MyPageActiveFundSummaryCardData(
              title: group.projectName,
              periodText: periodText != null
                  ? '${l10n.fundListPeriodLabel}：$periodText'
                  : l10n.myPageResultAnnouncementTbd,
              investorCode: investorTypeDisplay.investorCode,
              investorType: investorTypeDisplay.investorType,
              returnText: investorTypeDisplay.returnText,
              investmentAmountLabel: l10n.myPageInvestmentAmountLabel,
              investmentAmountValue: formatCurrency(
                group.investMoney,
                currencyFormatter,
              ),
              accumulatedEarningsLabel: l10n.myPageAccumulatedDistributionLabel,
              accumulatedEarningsValue: formatCurrency(
                group.earnings,
                currencyFormatter,
              ),
              statusLabel: resolveMyPageActiveFundStatusLabel(l10n, status),
              statusBackgroundColor:
                  resolveMyPageActiveFundStatusBackgroundColor(context, status),
              statusForegroundColor:
                  resolveMyPageActiveFundStatusForegroundColor(context, status),
              progress: resolveMyPageActiveFundProgress(project),
              imageUrls: project?.photos ?? const <String>[],
              onTap: () {
                Navigator.of(context).pop(
                  isSelected
                      ? const SelectedComposerFund.clear()
                      : SelectedComposerFund(
                          projectId: record.projectId,
                          projectName: record.projectName,
                          selectionKey: selectionKey,
                        ),
                );
              },
            ),
            isSelected: isSelected,
          );
        },
      ),
    );
  }
}

class _ComposerFundPickerCard extends StatelessWidget {
  const _ComposerFundPickerCard({required this.data, required this.isSelected});

  final MyPageActiveFundSummaryCardData data;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Stack(
      children: <Widget>[
        MyPageActiveFundSummaryCard(data: data, shadowPadding: EdgeInsets.zero),
        if (isSelected)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(UiTokens.radius12),
                  border: Border.all(color: colors.primary, width: 2),
                ),
              ),
            ),
          ),
        if (isSelected)
          Positioned(
            top: 10,
            right: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: colors.onDark,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
