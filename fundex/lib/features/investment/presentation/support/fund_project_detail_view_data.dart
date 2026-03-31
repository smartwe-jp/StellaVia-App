import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../settings/presentation/support/settings_operating_company_content.dart';
import '../../domain/entities/fund_project.dart';
import 'fund_project_gain_type_label.dart';
import 'fund_project_yield_display.dart';
import '../widgets/fund_project_detail_protection_structure_card.dart';

class FundProjectDetailViewData {
  const FundProjectDetailViewData({
    required this.infoItems,
    required this.propertyItems,
    required this.contractOverviewItems,
    required this.contractScheduleItems,
    required this.operatorItems,
    required this.documentGroups,
    required this.heroBadges,
    required this.heroGradientColors,
    required this.propertyLocation,
    required this.propertyCoordinate,
    required this.yieldDisplay,
    required this.actionLabel,
    required this.actionEnabled,
    this.operatorMetaText,
    this.protectionStructure,
  });

  final List<FundDetailInfoItemData> infoItems;
  final List<FundDetailInfoItemData> propertyItems;
  final List<FundDetailInfoItemData> contractOverviewItems;
  final List<FundDetailInfoItemData> contractScheduleItems;
  final List<FundDetailInfoItemData> operatorItems;
  final List<FundProjectDetailDocumentGroupData> documentGroups;
  final List<FundDetailBadgeData> heroBadges;
  final List<Color> heroGradientColors;
  final String propertyLocation;
  final FundPropertyCoordinate propertyCoordinate;
  final String yieldDisplay;
  final String actionLabel;
  final bool actionEnabled;
  final String? operatorMetaText;
  final FundProjectDetailProtectionStructureData? protectionStructure;
}

class FundProjectDetailDocumentGroupData {
  const FundProjectDetailDocumentGroupData({
    required this.title,
    required this.items,
  });

  final String title;
  final List<FundDetailDocumentItemData> items;
}

class FundProjectDetailViewDataBuilder {
  const FundProjectDetailViewDataBuilder._();

  static FundProjectDetailViewData build({
    required BuildContext context,
    required FundProject project,
    SettingsOperatingCompanyContent? operatingCompanyContent,
  }) {
    final locale = Localizations.localeOf(context);
    final currencyFormatter = NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final decimalFormatter = NumberFormat.decimalPattern(
      locale.toLanguageTag(),
    );
    final propertyLocation =
        _resolveLocationText(project) ?? _defaultPropertyLocation(context);
    final propertyCoordinate = _resolvePropertyCoordinate(
      project,
      propertyLocation,
    );
    final contractTables = _buildContractTables(
      context,
      project,
      currencyFormatter,
    );

    return FundProjectDetailViewData(
      infoItems: _buildPrimaryInfoItems(
        context,
        project,
        decimalFormatter,
      ),
      propertyItems: _buildPropertyInfoItems(
        context,
        project,
        propertyLocation,
      ),
      contractOverviewItems: contractTables.overviewItems,
      contractScheduleItems: contractTables.scheduleItems,
      operatorItems: _buildOperatorItems(
        context,
        project,
        operatingCompanyContent: operatingCompanyContent,
      ),
      documentGroups: _buildDocumentGroups(context, project),
      heroBadges: _buildHeroBadges(context, project),
      heroGradientColors: _resolveHeroGradientColors(
        context,
        project.projectStatus,
      ),
      propertyLocation: propertyLocation,
      propertyCoordinate: propertyCoordinate,
      yieldDisplay: resolveFundProjectYieldDisplay(project),
      actionLabel: _resolveActionLabel(context, project),
      actionEnabled: _isActionEnabled(project),
      operatorMetaText: _buildOperatorMetaText(
        context,
        project,
        operatingCompanyContent: operatingCompanyContent,
      ),
      protectionStructure: _buildProtectionStructure(context, project),
    );
  }
}

List<FundDetailInfoItemData> _buildPrimaryInfoItems(
  BuildContext context,
  FundProject project,
  NumberFormat decimalFormatter,
) {
  return <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailTargetAmountLabel,
      value: _resolveTargetAmountText(project, decimalFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailInvestmentUnitLabel,
      value: _resolveInvestmentUnitText(context, project, decimalFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailMaximumInvestmentPerPersonLabel,
      value: _resolveMaximumInvestmentPerPersonText(
        context,
        project,
        decimalFormatter,
      ),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailFundTotalLabel,
      value: _formatYenAmount(project.currentlySubscribed, decimalFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundListPeriodLabel,
      value: _resolvePeriodText(context, project),
    ),
  ];
}

List<FundDetailInfoItemData> _buildPropertyInfoItems(
  BuildContext context,
  FundProject project,
  String fallbackLocation,
) {
  final items = <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailLocationLabel,
      value: _resolveLocationText(project) ?? fallbackLocation,
    ),
  ];

  final propertyType = _detailString(project.detailData, const <String>[
        'propertyType',
        'targetPropertyType',
        'realEstateType',
      ]) ??
      _defaultPropertyType(context);
  items.add(
    FundDetailInfoItemData(
      label: context.l10n.fundDetailPropertyTypeLabel,
      value: propertyType,
    ),
  );

  final structure = _detailString(project.detailData, const <String>[
        'structure',
        'buildingStructure',
      ]) ??
      _defaultPropertyStructure(context);
  items.add(
    FundDetailInfoItemData(
      label: context.l10n.fundDetailStructureLabel,
      value: structure,
    ),
  );

  final builtYear = _detailString(project.detailData, const <String>[
        'builtYear',
        'builtAt',
        'completionYear',
      ]) ??
      _defaultPropertyBuiltYear(context);
  items.add(
    FundDetailInfoItemData(
      label: context.l10n.fundDetailBuiltYearLabel,
      value: builtYear,
    ),
  );

  return items;
}

class _FundContractTables {
  const _FundContractTables({
    required this.overviewItems,
    required this.scheduleItems,
  });

  final List<FundDetailInfoItemData> overviewItems;
  final List<FundDetailInfoItemData> scheduleItems;
}

_FundContractTables _buildContractTables(
  BuildContext context,
  FundProject project,
  NumberFormat currencyFormatter,
) {
  final targetPropertyType = _detailString(project.detailData, const <String>[
    'targetPropertyType',
    'propertyType',
    'realEstateType',
  ]);

  final appraisalValue = _detailInt(project.detailData, const <String>[
    'appraisalValue',
    'propertyAppraisalValue',
  ]);

  final acquisitionPrice = _detailInt(project.detailData, const <String>[
    'acquisitionPrice',
    'plannedAcquisitionPrice',
  ]);
  final overviewItems = <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailContractTypeLabel,
      value: _detailString(project.detailData, const <String>[
            'contractType',
            'schemeType',
          ]) ??
          context.l10n.fundDetailContractTypeValue,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailTargetPropertyTypeLabel,
      value: targetPropertyType ?? context.l10n.fundDetailUnknownValue,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailAppraisalValueLabel,
      value: _formatCurrency(appraisalValue, currencyFormatter),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailAcquisitionPriceLabel,
      value: _formatCurrency(acquisitionPrice, currencyFormatter),
    ),
  ];

  final offerPeriod = _resolveCompactDateRangeText(
    project.offeringStartDatetime,
    project.offeringEndDatetime,
  );
  final operationPeriod = _resolveCompactDateRangeText(
    project.scheduledStartDate,
    project.scheduledEndDate,
  );
  final offeringType = _resolveOfferingTypeText(context, project);
  final distributionDate = _resolveDistributionDateText(context, project);
  final scheduleItems = <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailOfferPeriodLabel,
      value: offerPeriod ?? context.l10n.fundDetailUnknownValue,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundListPeriodLabel,
      value: operationPeriod ?? context.l10n.fundDetailUnknownValue,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundListMethodLabel,
      value: _resolveMethodLabel(context, project.offeringMethod),
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailOfferCategoryLabel,
      value: offeringType,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailRemainingDaysLabel,
      value: project.daysRemaining?.toString() ?? context.l10n.fundDetailUnknownValue,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailDistributionDateLabel,
      value: distributionDate ?? context.l10n.fundDetailUnknownValue,
    ),
  ];

  return _FundContractTables(
    overviewItems: overviewItems,
    scheduleItems: scheduleItems,
  );
}

List<FundDetailInfoItemData> _buildOperatorItems(
  BuildContext context,
  FundProject project, {
  SettingsOperatingCompanyContent? operatingCompanyContent,
}) {
  final companyName = _firstNonBlank(<String?>[
    operatingCompanyContent?.tradeName,
    project.operatingCompany,
  ]);
  final permitNumber = _firstNonBlank(<String?>[
    operatingCompanyContent?.licenseNumber,
    _detailString(project.detailData, const <String>[
      'permitNumber',
      'licenseNumber',
      'registrationNumber',
    ]),
  ]);
  final representative = _firstNonBlank(<String?>[
    operatingCompanyContent?.representative,
    _detailString(project.detailData, const <String>[
      'representative',
      'representativeName',
      'ceoName',
    ]),
  ]);
  final companyAddress = _firstNonBlank(<String?>[
    operatingCompanyContent?.headOffice,
    _detailString(project.detailData, const <String>[
      'companyAddress',
      'operatorAddress',
      'companyLocation',
    ]),
  ]);

  return <FundDetailInfoItemData>[
    FundDetailInfoItemData(
      label: context.l10n.fundDetailOperatorCompanyLabel,
      value: companyName,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailPermitNumberLabel,
      value: permitNumber,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailRepresentativeLabel,
      value: representative,
    ),
    FundDetailInfoItemData(
      label: context.l10n.fundDetailCompanyAddressLabel,
      value: companyAddress,
    ),
  ]
      .where((FundDetailInfoItemData item) => item.value.trim().isNotEmpty)
      .toList(growable: false);
}

String? _buildOperatorMetaText(
  BuildContext context,
  FundProject project, {
  SettingsOperatingCompanyContent? operatingCompanyContent,
}) {
  final capital = _detailString(project.detailData, const <String>[
    'capital',
    'capitalAmount',
  ]);
  final established = _firstNonBlank(<String?>[
    operatingCompanyContent?.established,
    _detailString(project.detailData, const <String>[
      'establishedAt',
      'establishedDate',
    ]),
  ]);
  final businessStart = _detailString(project.detailData, const <String>[
    'businessStartDate',
    'serviceStartDate',
  ]);
  final licenseType = _firstNonBlank(<String?>[
    operatingCompanyContent?.licenseType,
    _detailString(project.detailData, const <String>[
      'licenseType',
      'permitType',
      'registrationType',
    ]),
  ]);
  final business = _firstNonBlank(<String?>[
    operatingCompanyContent?.business,
    _detailString(project.detailData, const <String>[
      'business',
      'businessDescription',
    ]),
  ]);
  final manager = _firstNonBlank(<String?>[
    operatingCompanyContent?.manager,
    _detailString(project.detailData, const <String>[
      'manager',
      'businessManager',
      'operationManager',
    ]),
  ]);
  final tel = _firstNonBlank(<String?>[
    operatingCompanyContent?.tel,
    _detailString(project.detailData, const <String>[
      'tel',
      'telephone',
      'phone',
      'contactPhone',
    ]),
  ]);

  final lines = <String?>[
    _buildOperatorMetaLine(
      context.l10n.settingsCompanyLicenseTypeLabel,
      licenseType,
    ),
    _buildOperatorMetaLine(
      context.l10n.fundDetailOperatorCapitalLabel,
      capital,
    ),
    _buildOperatorMetaLine(
      context.l10n.fundDetailOperatorEstablishedLabel,
      established,
    ),
    _buildOperatorMetaLine(
      context.l10n.fundDetailOperatorBusinessStartLabel,
      businessStart,
    ),
    _buildOperatorMetaLine(context.l10n.settingsCompanyBusinessLabel, business),
    _buildOperatorMetaLine(context.l10n.settingsCompanyManagerLabel, manager),
    _buildOperatorMetaLine(context.l10n.settingsCompanyTelLabel, tel),
  ].whereType<String>().toList(growable: false);

  if (lines.isEmpty) {
    return null;
  }

  return lines.join('\n');
}

String? _buildOperatorMetaLine(String label, String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return '$label：$trimmed';
}

String _firstNonBlank(Iterable<String?> candidates) {
  for (final candidate in candidates) {
    final trimmed = candidate?.trim();
    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }
  }
  return '';
}

List<FundProjectDetailDocumentGroupData> _buildDocumentGroups(
  BuildContext context,
  FundProject project,
) {
  return project.pdfDocuments.map((FundProjectPdfDocument document) {
    final availablePdfs = _availablePdfUrls(document);
    final title = _documentGroupTitle(context, document);
    return FundProjectDetailDocumentGroupData(
      title: title,
      items: availablePdfs
          .asMap()
          .entries
          .map((MapEntry<int, FundProjectPdfUrl> entry) {
        final itemTitle = _documentLinkTitle(
          context,
          entry.value,
          entry.key,
        );
        return FundDetailDocumentItemData(
          title: itemTitle,
          subtitle: _formatDocumentCreatedAt(context, entry.value) ??
              context.l10n.fundDetailDocumentReady,
          onTap: () => _openPdfDocument(
            context,
            groupTitle: title,
            linkTitle: itemTitle,
            item: entry.value,
          ),
        );
      }).toList(growable: false),
    );
  }).toList(growable: false);
}

List<FundProjectPdfUrl> _availablePdfUrls(FundProjectPdfDocument document) {
  final list = <FundProjectPdfUrl>[];
  for (final item in document.urls) {
    final url = item.url?.trim();
    if (url != null && url.isNotEmpty) {
      list.add(item);
    }
  }
  return List<FundProjectPdfUrl>.unmodifiable(list);
}

String _documentGroupTitle(
  BuildContext context,
  FundProjectPdfDocument document,
) {
  final title = document.description?.trim();
  if (title != null && title.isNotEmpty) {
    return title;
  }
  return context.l10n.fundDetailDocumentsTitle;
}

String _documentLinkTitle(
  BuildContext context,
  FundProjectPdfUrl item,
  int index,
) {
  final name = item.name?.trim();
  if (name != null && name.isNotEmpty) {
    return name;
  }
  return context.l10n.fundDetailDocumentPickerItem(index + 1);
}

void _openPdfDocument(
  BuildContext context, {
  required String groupTitle,
  required String linkTitle,
  required FundProjectPdfUrl item,
}) {
  final selectedUrl = item.url?.trim();
  if (selectedUrl == null || selectedUrl.isEmpty) {
    return;
  }
  final l10n = context.l10n;
  final viewerTexts = AppPdfViewerTexts(
    pageTitle: l10n.pdfViewerPageTitle,
    openExternalTooltip: l10n.pdfViewerOpenExternalTooltip,
    openExternalLabel: l10n.pdfViewerOpenExternalLabel,
    loadingLabel: l10n.pdfViewerLoadingLabel,
    loadFailedLabel: l10n.pdfViewerLoadFailedLabel,
    retryLabel: l10n.fundListRetry,
    invalidUrlNotice: l10n.pdfViewerInvalidUrlNotice,
    openExternalFailedNotice: l10n.pdfViewerOpenExternalFailedNotice,
  );
  openAppPdfViewer(
    context,
    url: selectedUrl,
    title: linkTitle.isNotEmpty ? linkTitle : groupTitle,
    texts: viewerTexts,
  );
}

String? _formatDocumentCreatedAt(BuildContext context, FundProjectPdfUrl item) {
  final raw = item.createTime?.trim();
  if (raw == null || raw.isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    return raw;
  }
  final formatter = DateFormat.yMd(
    Localizations.localeOf(context).toLanguageTag(),
  ).add_Hm();
  return formatter.format(parsed.toLocal());
}

FundProjectDetailProtectionStructureData? _buildProtectionStructure(
  BuildContext context,
  FundProject project,
) {
  final primary = _detailDouble(project.detailData, const <String>[
    'preferredRatio',
    'seniorRatio',
    'priorityInvestmentRatio',
  ]);
  final secondary = _detailDouble(project.detailData, const <String>[
    'subordinateRatio',
    'juniorRatio',
    'operatorRatio',
  ]);
  if (primary == null || secondary == null) {
    return null;
  }

  final normalizedPrimary = primary > 1 ? primary / 100 : primary;
  final normalizedSecondary = secondary > 1 ? secondary / 100 : secondary;
  final total = normalizedPrimary + normalizedSecondary;
  if (total <= 0) {
    return null;
  }

  return FundProjectDetailProtectionStructureData(
    primaryLabel: context.l10n.fundDetailSeniorInvestmentLabel,
    primaryRatio: normalizedPrimary / total,
    secondaryLabel: context.l10n.fundDetailJuniorInvestmentLabel,
    secondaryRatio: normalizedSecondary / total,
  );
}

List<FundDetailBadgeData> _buildHeroBadges(
  BuildContext context,
  FundProject project,
) {
  final colors = context.appColors;
  return <FundDetailBadgeData>[
    _buildStatusBadge(context, project.projectStatus),
    FundDetailBadgeData(
      label: resolveFundProjectGainTypeLabel(context, project.gainType),
      backgroundColor: colors.communitySecondary.withValues(alpha: 0.88),
      foregroundColor: colors.brandWhite,
    ),
  ];
}

FundDetailBadgeData _buildStatusBadge(BuildContext context, int? status) {
  final colors = context.appColors;
  switch (status) {
    case 1:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOpen,
        backgroundColor: colors.success,
        foregroundColor: colors.brandWhite,
      );
    case 0:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusUpcoming,
        backgroundColor: colors.warning,
        foregroundColor: colors.brandWhite,
      );
    case 4:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOperating,
        backgroundColor: colors.primary,
        foregroundColor: colors.brandWhite,
      );
    case 5:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusOperatingEnded,
        backgroundColor: colors.textSecondary.withValues(alpha: 0.88),
        foregroundColor: colors.brandWhite,
      );
    case 7:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusCompleted,
        backgroundColor: colors.successForeground,
        foregroundColor: colors.brandWhite,
      );
    case 2:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusFailed,
        backgroundColor: colors.danger,
        foregroundColor: colors.brandWhite,
      );
    default:
      return FundDetailBadgeData(
        label: context.l10n.fundListStatusUnknown,
        backgroundColor: colors.textTertiary.withValues(alpha: 0.88),
        foregroundColor: colors.brandWhite,
      );
  }
}

List<Color> _resolveHeroGradientColors(BuildContext context, int? status) {
  final colors = context.appColors;
  switch (status) {
    case 1:
      return <Color>[colors.successForeground, colors.success, colors.primary];
    case 0:
      return <Color>[
        colors.warningForeground,
        colors.warningAction,
        colors.warning,
      ];
    case 4:
      return <Color>[colors.infoForeground, colors.primary, colors.primaryAlt];
    case 5:
      return <Color>[colors.heroStart, colors.heroMiddle, colors.heroEnd];
    case 7:
      return <Color>[colors.successForeground, colors.success, colors.primary];
    case 2:
      return <Color>[colors.dangerForeground, colors.danger, colors.brandAlert];
    default:
      return <Color>[colors.heroStart, colors.heroMiddle, colors.heroEnd];
  }
}

String _resolveActionLabel(BuildContext context, FundProject project) {
  switch (project.projectStatus) {
    case 1:
      return context.l10n.fundDetailApplyNowAction;
    case 0:
      return context.l10n.fundDetailOpenSoonAction;
    default:
      return context.l10n.fundDetailUnavailableAction;
  }
}

bool _isActionEnabled(FundProject project) {
  return project.projectStatus == 1 || project.projectStatus == 0;
}

String _resolveMethodLabel(BuildContext context, String? offeringMethod) {
  final l10n = context.l10n;
  final value = offeringMethod?.trim();
  if (value == null || value.isEmpty) {
    return l10n.fundListMethodLottery;
  }

  final normalized = value.toLowerCase();
  if (normalized.contains('lottery') ||
      value.contains('抽選') ||
      value.contains('抽签')) {
    return l10n.fundListMethodLottery;
  }
  return value;
}

String _resolveTargetAmountText(
  FundProject project,
  NumberFormat decimalFormatter,
) {
  return _formatYenAmount(project.amountApplication, decimalFormatter);
}

String _resolveInvestmentUnitText(
  BuildContext context,
  FundProject project,
  NumberFormat decimalFormatter,
) {
  final amount = project.investmentUnit;
  if (amount == null || amount <= 0) {
    return context.l10n.fundDetailUnknownValue;
  }
  return context.l10n.fundDetailInvestmentUnitValue(
    decimalFormatter.format(amount),
  );
}

String _resolveMaximumInvestmentPerPersonText(
  BuildContext context,
  FundProject project,
  NumberFormat decimalFormatter,
) {
  final unitAmount = project.investmentUnit;
  final rawMaximum = project.maximumInvestmentPerPerson;
  if (unitAmount == null ||
      unitAmount <= 0 ||
      rawMaximum == null ||
      rawMaximum <= 0) {
    return context.l10n.fundDetailUnknownValue;
  }

  final maximumAmount = rawMaximum < unitAmount
      ? rawMaximum * unitAmount
      : rawMaximum;
  final unitCount = rawMaximum < unitAmount
      ? rawMaximum
      : (maximumAmount / unitAmount).floor();

  if (maximumAmount <= 0 || unitCount <= 0) {
    return context.l10n.fundDetailUnknownValue;
  }

  return context.l10n.fundDetailMaximumInvestmentPerPersonValue(
    _formatAmount(maximumAmount, decimalFormatter),
    decimalFormatter.format(unitCount),
  );
}

String _resolvePeriodText(BuildContext context, FundProject project) {
  final period = project.investmentPeriod?.trim();
  if (period != null && period.isNotEmpty) {
    return period;
  }
  return context.l10n.fundDetailUnknownValue;
}

String? _resolveDistributionDateText(BuildContext context, FundProject project) {
  if (project.distributionDate != null &&
      project.distributionDate!.trim().isNotEmpty) {
    return project.distributionDate!.trim();
  }
  return null;
}

String _resolveOfferingTypeText(BuildContext context, FundProject project) {
  final detailValue = _detailString(project.detailData, const <String>[
    'recruitmentType',
    'offeringCategory',
    'offeringTypeLabel',
    'fundType',
    'contractType',
    'schemeType',
  ]);
  if (detailValue != null) {
    return detailValue;
  }

  final raw = project.typeOfOffering?.trim();
  if (raw == null || raw.isEmpty) {
    return context.l10n.fundDetailUnknownValue;
  }

  final normalized = raw.toLowerCase();
  if (normalized.contains('lottery') ||
      normalized.contains('first') ||
      raw.contains('抽選') ||
      raw.contains('先着')) {
    return context.l10n.fundDetailUnknownValue;
  }

  return raw;
}

String? _resolveLocationText(FundProject project) {
  final direct = _detailString(project.detailData, const <String>[
    'location',
    'address',
    'propertyAddress',
  ]);
  if (direct != null) {
    return direct;
  }

  final name = project.projectName.trim();
  if (name.contains(' ')) {
    return name.split(' ').first;
  }
  if (name.contains('　')) {
    return name.split('　').first;
  }
  final company = project.operatingCompany?.trim();
  if (company != null && company.isNotEmpty) {
    return company;
  }
  return null;
}

FundPropertyCoordinate _resolvePropertyCoordinate(
  FundProject project,
  String resolvedLocation,
) {
  final latitude = _detailDouble(project.detailData, const <String>[
    'latitude',
    'lat',
    'locationLat',
    'propertyLatitude',
    'mapLatitude',
  ]);
  final longitude = _detailDouble(project.detailData, const <String>[
    'longitude',
    'lng',
    'lon',
    'locationLng',
    'propertyLongitude',
    'mapLongitude',
  ]);
  if (_isValidCoordinate(latitude, longitude)) {
    return FundPropertyCoordinate(latitude: latitude!, longitude: longitude!);
  }
  final fallback = _defaultPropertyCoordinate(resolvedLocation);
  return fallback;
}

bool _isValidCoordinate(double? latitude, double? longitude) {
  if (latitude == null || longitude == null) {
    return false;
  }
  return latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;
}

FundPropertyCoordinate _defaultPropertyCoordinate(String location) {
  final normalized = location.toLowerCase();
  if (normalized.contains('大阪') || normalized.contains('osaka')) {
    return const FundPropertyCoordinate(latitude: 34.6937, longitude: 135.5023);
  }
  if (normalized.contains('京都') || normalized.contains('kyoto')) {
    return const FundPropertyCoordinate(latitude: 35.0116, longitude: 135.7681);
  }
  if (normalized.contains('福岡') || normalized.contains('fukuoka')) {
    return const FundPropertyCoordinate(latitude: 33.5902, longitude: 130.4017);
  }
  if (normalized.contains('名古屋') || normalized.contains('nagoya')) {
    return const FundPropertyCoordinate(latitude: 35.1815, longitude: 136.9066);
  }
  if (normalized.contains('札幌') || normalized.contains('sapporo')) {
    return const FundPropertyCoordinate(latitude: 43.0618, longitude: 141.3545);
  }
  if (normalized.contains('神戸') || normalized.contains('kobe')) {
    return const FundPropertyCoordinate(latitude: 34.6901, longitude: 135.1955);
  }
  if (normalized.contains('横浜') || normalized.contains('yokohama')) {
    return const FundPropertyCoordinate(latitude: 35.4437, longitude: 139.6380);
  }
  return const FundPropertyCoordinate(latitude: 35.6721, longitude: 139.7366);
}

String _defaultPropertyLocation(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'en') {
    return 'Akasaka, Minato-ku, Tokyo';
  }
  if (code == 'zh') {
    final scriptCode = Localizations.localeOf(context).scriptCode;
    if (scriptCode == 'Hant') {
      return '東京都港區赤坂';
    }
    return '東京都港区赤坂';
  }
  return '東京都港区赤坂';
}

String _defaultPropertyType(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'en') {
    return 'Apartment';
  }
  if (code == 'zh') {
    final scriptCode = Localizations.localeOf(context).scriptCode;
    if (scriptCode == 'Hant') {
      return '公寓';
    }
    return '公寓';
  }
  return 'マンション';
}

String _defaultPropertyStructure(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'en') {
    return 'RC, 15 floors';
  }
  if (code == 'zh') {
    final scriptCode = Localizations.localeOf(context).scriptCode;
    if (scriptCode == 'Hant') {
      return 'RC造 15層';
    }
    return 'RC造 15层';
  }
  return 'RC造 15階建';
}

String _defaultPropertyBuiltYear(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'en') {
    return '2019';
  }
  if (code == 'zh') {
    final scriptCode = Localizations.localeOf(context).scriptCode;
    if (scriptCode == 'Hant') {
      return '2019年';
    }
    return '2019年';
  }
  return '2019年';
}

String _formatCurrency(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
}

String _formatAmount(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return formatter.format(amount);
}

String _formatYenAmount(int? amount, NumberFormat formatter) {
  if (amount == null) {
    return '--';
  }
  return '${formatter.format(amount)}円';
}

String? _resolveCompactDateRangeText(String? start, String? end) {
  final startText = _resolveCompactDateText(start);
  final endText = _resolveCompactDateText(end);
  if (startText == null || endText == null) {
    return null;
  }
  return '$startText～$endText';
}

String? _resolveCompactDateText(String? raw) {
  final parsed = _parseDateTime(raw);
  if (parsed != null) {
    return DateFormat('yyyy-MM-dd').format(parsed);
  }

  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  if (trimmed.length >= 10) {
    return trimmed.substring(0, 10);
  }
  return trimmed;
}

DateTime? _parseDateTime(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return null;
  }
  final normalized = raw.trim().replaceAll(' ', 'T');
  return DateTime.tryParse(normalized);
}

String? _detailString(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null) {
      continue;
    }
    final normalized = value.toString().trim();
    if (normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}

int? _detailInt(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value == null) {
      continue;
    }
    final parsed = int.tryParse(value.toString());
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}

double? _detailDouble(Map<String, Object?> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value == null) {
      continue;
    }
    final parsed = double.tryParse(value.toString());
    if (parsed != null) {
      return parsed;
    }
  }
  return null;
}
