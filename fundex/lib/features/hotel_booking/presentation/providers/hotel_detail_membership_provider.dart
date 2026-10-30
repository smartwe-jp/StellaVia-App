import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../host_miles/domain/entities/host_miles_models.dart';
import '../../../host_miles/domain/usecases/load_host_miles_home_usecase.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';

final hotelDetailAccountProvider = FutureProvider.autoDispose
    .family<HostMilesAccount, Object>((ref, identity) {
      return LoadHostMilesHomeUseCase(
        ref.watch(hostMilesRepositoryProvider),
      ).loadAccount();
    });
