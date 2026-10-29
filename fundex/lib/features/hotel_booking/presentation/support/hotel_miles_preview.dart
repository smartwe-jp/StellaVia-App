import 'package:flutter/widgets.dart';
import '../../../../app/localization/app_localizations_ext.dart';
import '../../domain/entities/hotel_models.dart';

/// Explicit design fixture, never used in search APIs or booking payloads.
HotelSummary hotelMilesPreviewHotel(BuildContext context) => HotelSummary(
  id: 'design-preview-only',
  name: context.l10n.hotelMilesSampleName,
  address: context.l10n.hotelMilesSampleLocation,
  area: 'nagano',
  imageUrl: '',
  latitude: null,
  longitude: null,
  lowestPrice: null,
  beforeDiscountPrice: null,
  discount: null,
  discountName: '',
  bookingType: 0,
  buildingCode: '01',
  bookingTypeLabel: '',
  buildingType: '',
  isBookable: true,
  remainingRooms: 2,
  stayBenefitParticipate: false,
  tags: const [],
);
