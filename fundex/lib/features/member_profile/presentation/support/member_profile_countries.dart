import '../../../../l10n/app_localizations.dart';

// Member profile APIs store country names as text. Keep new selections stable
// across UI languages and preserve unrecognized values from older profiles.
Map<String, String> memberProfileCountries(AppLocalizations l10n) => {
  '日本': l10n.memberCountryJapan,
  'アメリカ': l10n.memberCountryUnitedStates,
  'カナダ': l10n.memberCountryCanada,
  'シンガポール': l10n.memberCountrySingapore,
  'イギリス': l10n.memberCountryUnitedKingdom,
  '中国': l10n.memberCountryChina,
  '香港': l10n.memberCountryHongKong,
  '台湾': l10n.memberCountryTaiwan,
  '韓国': l10n.memberCountrySouthKorea,
  'トルコ': l10n.memberCountryTurkey,
  'ドイツ': l10n.memberCountryGermany,
  'フランス': l10n.memberCountryFrance,
  'タイ': l10n.memberCountryThailand,
  'マレーシア': l10n.memberCountryMalaysia,
  'オーストラリア': l10n.memberCountryAustralia,
  'ロシア': l10n.memberCountryRussia,
  'フィリピン': l10n.memberCountryPhilippines,
  'その他': l10n.memberCountryOther,
};
