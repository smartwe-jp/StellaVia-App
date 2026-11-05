import '../entities/mypage_models.dart';
import '../repositories/mypage_repository.dart';

class FetchSecondaryMarketHoldingsUseCase {
  const FetchSecondaryMarketHoldingsUseCase(this.repository);
  final MyPageRepository repository;
  Future<List<SecondaryMarketHolding>> call() =>
      repository.fetchSecondaryMarketHoldings();
}
