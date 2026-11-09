import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../host_miles/presentation/providers/host_miles_providers.dart';
import '../../domain/entities/mypage_chart.dart';
import 'mypage_membership_providers.dart';

final cumulativeMilesProvider = FutureProvider.autoDispose
    .family<MyPageChartData, ({DateTime month, int years})>((ref, range) async {
      if (ref.watch(myPageMembershipIdentityProvider) == null) {
        throw StateError('Authenticated user required');
      }
      final start = DateTime(range.month.year - range.years, range.month.month);
      final chart = await ref
          .watch(hostMilesRepositoryProvider)
          .fetchCumulativeChart(startMonth: start);
      final points = <MyPageChartPoint>[];
      for (var i = 0; i < chart.xaxis.length; i++) {
        final label = chart.xaxis[i].trim();
        final date = DateTime.tryParse(label.length == 7 ? '$label-01' : label);
        if (date != null) {
          points.add(MyPageChartPoint(date, chart.yaxis[i], label: label));
        }
      }
      return MyPageChartData(
        start: start,
        end: range.month,
        total: points.lastOrNull?.value,
        points: points,
      );
    });

final monthlyMilesProvider = FutureProvider.autoDispose
    .family<num, ({DateTime month, bool expected})>((ref, query) {
      if (ref.watch(myPageMembershipIdentityProvider) == null) {
        throw StateError('Authenticated user required');
      }
      final repo = ref.watch(hostMilesRepositoryProvider);
      return query.expected
          ? repo.fetchExpectedNextMonth()
          : repo.fetchEarnedMonth(query.month);
    });
