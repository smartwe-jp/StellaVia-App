import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_overview_tab_page.dart';

class GuestDiscoveryPage extends StatelessWidget {
  const GuestDiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: HomeOverviewTabPage.guestGuide(),
      ),
    );
  }
}
