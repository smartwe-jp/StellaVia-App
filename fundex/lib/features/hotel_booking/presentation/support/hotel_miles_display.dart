import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';

class HotelMilesDisplay {
  HotelMilesDisplay(
    HostMilesAccount? account,
    HostMilesTier? tier,
    AppLocalizations l,
    String locale,
  ) : balance = account?.availablePoints == null
          ? '—'
          : NumberFormat.decimalPattern(
              locale,
            ).format(account!.availablePoints),
      rank = tier?.currentTier?.trim().isNotEmpty == true
          ? tier!.currentTier!.trim()
          : '—',
      rooms = tier?.remainingBookingRooms == null
          ? '—'
          : l.hotelMilesRoomValue(tier!.remainingBookingRooms!),
      advance = tier?.leadTimeMonths == null
          ? null
          : l.hotelMilesAdvanceMonths(tier!.leadTimeMonths!);
  final String balance, rank, rooms;
  final String? advance;
}
