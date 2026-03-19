import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../support/fund_project_detail_structured_data.dart';

class FundProjectDetailTabsSection extends StatelessWidget {
  const FundProjectDetailTabsSection({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.structuredData,
    this.emptyPlaceholder,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final FundProjectDetailStructuredData structuredData;
  final Widget? emptyPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              _DetailTabItem(
                label: context.l10n.fundDetailTabPropertyOverview,
                selected: selectedIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _DetailTabItem(
                label: context.l10n.fundDetailTabIncomeScheme,
                selected: selectedIndex == 1,
                onTap: () => onTabChanged(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (selectedIndex == 0)
          _FundPropertyOverviewTab(
            structuredData: structuredData,
            emptyPlaceholder: emptyPlaceholder,
          )
        else
          _FundIncomeSchemeTab(structuredData: structuredData),
      ],
    );
  }
}

class _DetailTabItem extends StatelessWidget {
  const _DetailTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: appText.bodyStrong.copyWith(
                  color: selected ? colors.primary : colors.textTertiary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: selected ? colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FundPropertyOverviewTab extends StatelessWidget {
  const _FundPropertyOverviewTab({
    required this.structuredData,
    required this.emptyPlaceholder,
  });

  final FundProjectDetailStructuredData structuredData;
  final Widget? emptyPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    if (structuredData.houseList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child:
            emptyPlaceholder ??
            FundDetailContentCard(
              child: Text(
                context.l10n.fundDetailUnknownValue,
                style: appText.body.copyWith(color: colors.textSecondary),
              ),
            ),
      );
    }

    final houseCount = structuredData.resolvedHouseCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.fundDetailPropertyCountHint(houseCount),
            style: appText.micro.copyWith(
              color: colors.textTertiary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < structuredData.houseList.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == structuredData.houseList.length - 1 ? 0 : 8,
              ),
              child: _FundPropertyHouseCard(
                houseData: structuredData.houseList[index],
                index: index,
              ),
            ),
        ],
      ),
    );
  }
}

class _FundPropertyHouseCard extends StatefulWidget {
  const _FundPropertyHouseCard({required this.houseData, required this.index});

  final FundProjectHouseStructuredData houseData;
  final int index;

  @override
  State<_FundPropertyHouseCard> createState() => _FundPropertyHouseCardState();
}

class _FundPropertyHouseCardState extends State<_FundPropertyHouseCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.index == 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final headerTitle = widget.houseData.propertyName.isNotEmpty
        ? widget.houseData.propertyName
        : context.l10n.fundDetailUnknownValue;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: colors.surface,
        child: Theme(
          data: theme.copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: _expanded,
            backgroundColor: colors.surface,
            collapsedBackgroundColor: colors.surface,
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            childrenPadding: EdgeInsets.zero,
            onExpansionChanged: (bool expanded) {
              setState(() {
                _expanded = expanded;
              });
            },
            title: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[colors.primary, colors.primaryAlt],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${context.l10n.fundDetailPropertyItemPrefix(widget.index + 1)} $headerTitle',
                style: appText.bodyStrong.copyWith(color: colors.onDark),
              ),
            ),
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: colors.textSecondary,
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  children: <Widget>[
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailPropertyNameLabel,
                      value: widget.houseData.propertyName,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailLocationLabel,
                      value: widget.houseData.location,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailTransportationLabel,
                      value: widget.houseData.transportation,
                    ),
                    _FundPropertySectionLabel(
                      title: context.l10n.fundDetailLandSectionTitle,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailLandCategoryLabel,
                      value: widget.houseData.landCategory,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailAreaLabel,
                      value: widget.houseData.area,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailRightsLabel,
                      value: widget.houseData.rights,
                    ),
                    _FundPropertySectionLabel(
                      title: context.l10n.fundDetailBuildingSectionTitle,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailStructureLabel,
                      value: widget.houseData.structure,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailFloorAreaLabel,
                      value: widget.houseData.floorArea,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailBuiltYearMonthLabel,
                      value: widget.houseData.builtYearAndMonth,
                    ),
                    _FundPropertySectionLabel(
                      title: context.l10n.fundDetailRegulationSectionTitle,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailLandUseZoneLabel,
                      value: widget.houseData.landUseZone,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailBuildingCoverageRatioLabel,
                      value: widget.houseData.buildingCoverageRatio,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailFloorAreaRatioLabel,
                      value: widget.houseData.floorAreaRatio,
                    ),
                    _FundPropertySectionLabel(
                      title:
                          context.l10n.fundDetailOperationContractSectionTitle,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailOperationTypeLabel,
                      value: _resolveOperationTypeLabel(
                        context,
                        widget.houseData.operationType,
                      ),
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailLandlordLabel,
                      value: widget.houseData.landlord,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailTenantLabel,
                      value: widget.houseData.tenant,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailContractTypeLabel,
                      value: widget.houseData.contractType,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailContractPeriodLabel,
                      value: widget.houseData.contractPeriod,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailMonthlyRentLabel,
                      value: widget.houseData.monthlyRent,
                      alternateBackground: true,
                    ),
                    _FundPropertyInfoRow(
                      label:
                          context.l10n.fundDetailContractAmendmentMethodLabel,
                      value: widget.houseData.methodOfContractAmendment,
                    ),
                    _FundPropertyInfoRow(
                      label: context.l10n.fundDetailOtherImportantMattersLabel,
                      value: widget.houseData.otherImportantMatters,
                      hasDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolveOperationTypeLabel(BuildContext context, int? operationType) {
    switch (operationType) {
      case 1:
        return context.l10n.fundDetailOperationTypeLeaseValue;
      case 2:
        return context.l10n.fundDetailOperationTypeHotelValue;
      default:
        return context.l10n.fundDetailUnknownValue;
    }
  }
}

class _FundPropertySectionLabel extends StatelessWidget {
  const _FundPropertySectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 7, bottom: 3),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '■ $title',
          style: appText.chip.copyWith(color: colors.primary),
        ),
      ),
    );
  }
}

class _FundPropertyInfoRow extends StatelessWidget {
  const _FundPropertyInfoRow({
    required this.label,
    required this.value,
    this.alternateBackground = false,
    this.hasDivider = true,
  });

  final String label;
  final String value;
  final bool alternateBackground;
  final bool hasDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final row = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: appText.caption.copyWith(
                color: colors.textSecondary,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _valueOrDash(value, context),
              textAlign: TextAlign.right,
              style: appText.bodyStrong.copyWith(
                color: colors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: alternateBackground ? colors.surfaceAlt : null,
        border: hasDivider
            ? Border(bottom: BorderSide(color: colors.borderSoft, width: 1))
            : null,
      ),
      child: row,
    );
  }
}

class _FundIncomeSchemeTab extends StatelessWidget {
  const _FundIncomeSchemeTab({required this.structuredData});

  final FundProjectDetailStructuredData structuredData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.l10n.fundDetailSchemeMarketEstimateNote,
            style: appText.micro.copyWith(
              color: colors.textTertiary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          _FundSchemeCard(
            title: context.l10n.fundDetailSchemeBreakdownTitle,
            headerBackgroundColor: colors.primary,
            rows: <_FundSchemeRowData>[
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemePropertyPriceLabel,
                value: structuredData.propertyPrice,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeTotalInvestmentLabel,
                value: structuredData.totalInvestment,
                divider: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _FundSchemeCard(
            title: context.l10n.fundDetailSchemeIncomeTitle,
            headerGradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[colors.primaryAlt, colors.communityPrimary],
            ),
            rows: <_FundSchemeRowData>[
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeEstimatedAmountLabel,
                value: structuredData.estimatedAmount,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeRentalIncomeLabel,
                value: structuredData.rentalIncome,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeIncomeTotalLabel,
                value: structuredData.totalIncome,
                tone: _FundSchemeTone.info,
                divider: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _FundSchemeCard(
            title: context.l10n.fundDetailSchemeExpenseTitle,
            headerGradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[colors.danger, colors.warning],
            ),
            rows: <_FundSchemeRowData>[
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeLandMiscLabel,
                value: structuredData.landMiscellaneousCost,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeDesignCostLabel,
                value: structuredData.designCost,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeBuildingCostLabel,
                value: structuredData.buildingCost,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeMaintenanceFeeLabel,
                value: structuredData.maintenanceManagementFee,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemePublicUtilitiesTaxesLabel,
                value: structuredData.publicUtilitiesTaxes,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeFireInsurancePremiumLabel,
                value: structuredData.fireInsurancePremium,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeBrokerageFeeLabel,
                value: structuredData.brokerageFee,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeAmFeeLabel,
                value: structuredData.amFee,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeAmFeeYear1Label,
                value: structuredData.amFeeYear1,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeAmFeeYear2Label,
                value: structuredData.amFeeYear2,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeAmCommissionLabel,
                value: structuredData.amCommissionFee,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemePublicOfferingFeeLabel,
                value: structuredData.publicOfferingFee,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeMarketingCostsLabel,
                value: structuredData.marketingCosts,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeAccountantFeeLabel,
                value: structuredData.accountantFee,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeConsignmentFeeLabel,
                value: structuredData.consignmentFee,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeNormalConsignmentFeeLabel,
                value: structuredData.normalConsignmentFee,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeFundAdministratorFeeLabel,
                value: structuredData.fundAdministratorFee,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeMiscExpensesLabel,
                value: structuredData.miscellaneousExpenses,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeSellExpensesLabel,
                value: structuredData.sellExpenses,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeOtherLabel,
                value: structuredData.otherExpenses,
                alternateBackground: true,
              ),
              _FundSchemeRowData(
                label: context.l10n.fundDetailSchemeExpenseTotalLabel,
                value: structuredData.totalExpense,
                tone: _FundSchemeTone.danger,
                divider: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[colors.heroStart, colors.heroEnd],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        context.l10n.fundDetailSchemeDistributedCapitalFormula,
                        style: appText.micro.copyWith(
                          color: colors.onDark.withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.fundDetailSchemeDistributedCapitalTitle,
                        style: appText.cardTitle.copyWith(color: colors.onDark),
                      ),
                    ],
                  ),
                ),
                Text(
                  _valueOrDash(structuredData.distributedCapital, context),
                  style: appText.numericHeadline.copyWith(
                    color: colors.highlightGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundSchemeCard extends StatelessWidget {
  const _FundSchemeCard({
    required this.title,
    required this.rows,
    this.headerGradient,
    this.headerBackgroundColor,
  });

  final String title;
  final List<_FundSchemeRowData> rows;
  final LinearGradient? headerGradient;
  final Color? headerBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors.border, width: 1.5),
          borderRadius: BorderRadius.circular(16),
          color: colors.surface,
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: headerGradient == null
                    ? (headerBackgroundColor ?? colors.primary)
                    : null,
                gradient: headerGradient,
              ),
              child: Text(
                title,
                style: appText.chip.copyWith(color: colors.onDark),
              ),
            ),
            for (final row in rows) _FundSchemeRow(item: row),
          ],
        ),
      ),
    );
  }
}

class _FundSchemeRowData {
  const _FundSchemeRowData({
    required this.label,
    required this.value,
    this.alternateBackground = false,
    this.divider = true,
    this.tone = _FundSchemeTone.normal,
  });

  final String label;
  final String value;
  final bool alternateBackground;
  final bool divider;
  final _FundSchemeTone tone;
}

class _FundSchemeRow extends StatelessWidget {
  const _FundSchemeRow({required this.item});

  final _FundSchemeRowData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    final backgroundColor = switch (item.tone) {
      _FundSchemeTone.info => colors.infoSubtle,
      _FundSchemeTone.danger => colors.dangerSubtle,
      _FundSchemeTone.normal =>
        item.alternateBackground ? colors.surfaceAlt : colors.surface,
    };
    final labelColor = switch (item.tone) {
      _FundSchemeTone.info => colors.primary,
      _FundSchemeTone.danger => colors.danger,
      _FundSchemeTone.normal => colors.textSecondary,
    };
    final valueColor = switch (item.tone) {
      _FundSchemeTone.info => colors.primary,
      _FundSchemeTone.danger => colors.danger,
      _FundSchemeTone.normal => colors.textPrimary,
    };
    final labelWeight = switch (item.tone) {
      _FundSchemeTone.normal => FontWeight.w600,
      _FundSchemeTone.info || _FundSchemeTone.danger => FontWeight.w800,
    };
    final valueWeight = switch (item.tone) {
      _FundSchemeTone.normal => FontWeight.w700,
      _FundSchemeTone.info || _FundSchemeTone.danger => FontWeight.w800,
    };

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: item.divider
            ? Border(bottom: BorderSide(color: colors.borderSoft))
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              item.label,
              style: appText.caption.copyWith(
                color: labelColor,
                fontWeight: labelWeight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _valueOrDash(item.value, context),
            style: appText.numericBody.copyWith(
              color: valueColor,
              fontWeight: valueWeight,
            ),
          ),
        ],
      ),
    );
  }
}

String _valueOrDash(String value, BuildContext context) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return context.l10n.fundDetailUnknownValue;
  }
  return trimmed;
}

enum _FundSchemeTone { normal, info, danger }
