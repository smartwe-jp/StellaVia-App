import '../../../../l10n/app_localizations.dart';

/// Design copy only: not an eligibility policy or an account-rank calculation.
class HomeRankContent {
  const HomeRankContent(
    this.name,
    this.investmentRange,
    this.rate,
    this.validityMonths,
    this.advanceMonths,
    this.rooms,
  );
  final String name, investmentRange, rate;
  final int validityMonths, advanceMonths, rooms;
}

List<HomeRankContent> homeRankContent(AppLocalizations l10n) => [
  HomeRankContent('REGULAR', l10n.homeRankRegularRange, '0.5%', 13, 2, 2),
  HomeRankContent('BRONZE', l10n.homeRankBronzeRange, '0.525%', 15, 3, 3),
  HomeRankContent('SILVER', l10n.homeRankSilverRange, '0.55%', 18, 4, 4),
  HomeRankContent('GOLD', l10n.homeRankGoldRange, '0.575%', 21, 5, 5),
  HomeRankContent('MASTER', l10n.homeRankMasterRange, '0.6%', 24, 6, 6),
];
