import '../../../../l10n/app_localizations.dart';

String memberIndustryLabel(AppLocalizations l10n, String code) =>
    switch (code) {
      'IT' => l10n.memberIndustryIt,
      'FINANCE' => l10n.memberIndustryFinance,
      'MANUFACTURING' => l10n.memberIndustryManufacturing,
      'RETAIL' => l10n.memberIndustryRetail,
      'REAL_ESTATE' => l10n.memberIndustryRealEstate,
      'MEDICAL' => l10n.memberIndustryMedical,
      'PUBLIC' => l10n.memberIndustryPublic,
      'EDUCATION' => l10n.memberIndustryEducation,
      'OTHER' => l10n.memberIndustryOther,
      _ => code,
    };
