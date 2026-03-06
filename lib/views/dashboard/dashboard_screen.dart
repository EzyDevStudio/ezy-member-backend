import 'package:ezymember_backend/controllers/dashboard_controller.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_card.dart';
import 'package:ezymember_backend/widgets/custom_chart.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardController = Get.put(DashboardController(), tag: "dashboard");

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh() => _withLoading(() => _dashboardController.loadDashboardData());

  Future<T> _withLoading<T>(Future<T> Function() action) async {
    LoadingOverlay.show(context);

    try {
      return await action();
    } finally {
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: ListView(padding: EdgeInsets.all(16.0), children: <Widget>[_buildCardSection(), SizedBox(height: 16.0), _buildChartSection()]),
  );

  Widget _buildCardSection() => Obx(
    () => GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 16.0,
        mainAxisExtent: 125.0,
        mainAxisSpacing: 16.0,
        crossAxisCount: context.countDashboard,
      ),
      children: <Widget>[
        CustomDashboardCard(
          color: Colors.red,
          iconColor: Colors.red,
          icon: Icons.supervisor_account_rounded,
          data: _dashboardController.totalMember.value.toString(),
          title: Globalization.totalMember.tr,
        ),
        CustomDashboardCard(
          isThisMonth: true,
          color: Colors.blue,
          iconColor: Colors.blue,
          icon: Icons.person_2_rounded,
          data: _dashboardController.cmMember.value.toString(),
          title: Globalization.newMember.tr,
        ),
        CustomDashboardCard(
          color: Colors.green,
          iconColor: Colors.green,
          icon: Icons.attach_money_rounded,
          data: (_dashboardController.totalMember.value - _dashboardController.totalExpiredMember.value).toString(),
          title: Globalization.memberActive.tr,
        ),
        CustomDashboardCard(
          color: Colors.purple,
          iconColor: Colors.purple,
          icon: Icons.credit_card_rounded,
          data: _dashboardController.totalExpiredMember.value.toString(),
          title: Globalization.memberExpired.tr,
        ),
      ],
    ),
  );

  Widget _buildChartSection() => Obx(() {
    final charts = [
      CustomLineChart(
        title: "${Globalization.memberJoined.tr} (6 months)",
        data: _dashboardController.monthlyMember,
        keys: ["total"],
        labels: [Globalization.totalMember.tr],
      ),

      CustomPieChart(
        title: Globalization.memberSummary.tr,
        data: {
          Globalization.memberActive.tr: (_dashboardController.totalMember.value - _dashboardController.totalExpiredMember.value).toDouble(),
          Globalization.memberExpired.tr: _dashboardController.totalExpiredMember.value.toDouble(),
        },
      ),
      CustomLineChart(
        title: "${Globalization.monthlyTransaction.tr} (6 months)",
        data: _dashboardController.monthlyTransaction,
        keys: ["credit", "point"],
        labels: [Globalization.credit.tr, Globalization.point.tr],
      ),
      CustomLineChart(
        title: "${Globalization.monthlyCredit.tr} (6 months)",
        data: _dashboardController.monthlyCredit,
        keys: ["earn", "redeem"],
        labels: [Globalization.earn.tr, Globalization.redeem.tr],
      ),
      CustomLineChart(
        title: "${Globalization.monthlyPoint.tr} (6 months)",
        data: _dashboardController.monthlyPoint,
        keys: ["earn", "redeem"],
        labels: [Globalization.earn.tr, Globalization.redeem.tr],
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: charts.length,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        mainAxisExtent: 300.0,
        crossAxisCount: context.isMobile ? 1 : 2,
      ),
      itemBuilder: (context, index) => charts[index],
    );
  });
}
