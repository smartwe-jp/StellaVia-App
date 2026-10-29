import 'package:flutter/material.dart';
import 'my_page_chart_refresh_scope.dart';
import 'my_page_membership_section.dart';
import 'my_page_summary_charts.dart';

class MyPageSummarySection extends StatelessWidget {
  const MyPageSummarySection({super.key});
  @override
  Widget build(BuildContext context) => const MyPageChartRefreshScope(
    child: Column(children: [MyPageMembershipSection(), MyPageSummaryCharts()]),
  );
}
