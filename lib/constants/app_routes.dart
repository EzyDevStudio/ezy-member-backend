import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/middlewares/auth_middleware.dart';
import 'package:ezymember_backend/views/authentication/authentication_screen.dart';
import 'package:ezymember_backend/views/credit/credit_history_screen.dart';
import 'package:ezymember_backend/views/dashboard/dashboard_screen.dart';
import 'package:ezymember_backend/views/home/home_screen.dart';
import 'package:ezymember_backend/views/member/member_screen.dart';
import 'package:ezymember_backend/views/point/point_history_screen.dart';
import 'package:ezymember_backend/views/reports/member_card_summary_screen.dart';
import 'package:ezymember_backend/views/reports/member_history_summary_screen.dart';
import 'package:ezymember_backend/views/reports/point_adjustment_summary_screen.dart';
import 'package:ezymember_backend/views/reports/voucher_summary_screen.dart';
import 'package:ezymember_backend/views/settings/about_us/about_us_screen.dart';
import 'package:ezymember_backend/views/settings/access_role/access_role_screen.dart';
import 'package:ezymember_backend/views/settings/branch/branch_screen.dart';
import 'package:ezymember_backend/views/settings/initial_setup/initial_setup_screen.dart';
import 'package:ezymember_backend/views/settings/member_card/member_card_screen.dart';
import 'package:ezymember_backend/views/settings/user/user_screen.dart';
import 'package:ezymember_backend/views/timeline/timeline_screen.dart';
import 'package:ezymember_backend/views/voucher/normal_voucher_screen.dart';
import 'package:ezymember_backend/views/voucher/special_voucher_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const authentication = "/authentication";
  static const home = "/home";
  static const dashboard = "$home/dashboard";
  static const member = "$home/member";
  static const timeline = "$home/timeline";
  static const pointHistory = "$home/point-history";
  static const creditHistory = "$home/credit-history";
  static const normalVoucher = "$home/normal-voucher";
  static const specialVoucher = "$home/special-voucher";
  static const membershipCardSummary = "$home/membership-card-summary";
  static const memberHistorySummary = "$home/member-history-summary";
  static const pointAdjustmentSummary = "$home/point-adjustment-summary";
  static const voucherSummary = "$home/voucher-summary";
  static const initialSetup = "$home/initial-setup";
  static const aboutUs = "$home/about-us";
  static const accessRole = "$home/access-role";
  static const branch = "$home/branch";
  static const memberCard = "$home/member-card";
  static const user = "$home/user";

  static final pages = <GetPage>[
    GetPage(name: authentication, page: () => AuthenticationScreen()),
    GetPage(preventDuplicates: true, participatesInRootNavigator: true, middlewares: [AuthMiddleware()], name: home, page: () => HomeScreen()),
  ];

  final List<MenuEntry> entries = [
    MenuItemEntry(MenuItem(index: 100, label: Globalization.dashboard.tr, route: dashboard, screen: const DashboardScreen())),
    MenuItemEntry(MenuItem(index: 101, label: Globalization.member.tr, route: member, screen: const MemberScreen())),
    MenuItemEntry(MenuItem(index: 102, label: Globalization.timeline.tr, route: timeline, screen: const TimelineScreen())),
    MenuItemEntry(MenuItem(index: 103, label: Globalization.pointHistory.tr, route: pointHistory, screen: const PointHistoryScreen())),
    MenuItemEntry(MenuItem(index: 104, label: Globalization.creditHistory.tr, route: creditHistory, screen: const CreditHistoryScreen())),
    MenuGroupEntry(
      title: Globalization.voucher.tr,
      items: [
        MenuItem(index: 400, label: Globalization.normalVoucher.tr, route: normalVoucher, screen: const NormalVoucherScreen()),
        MenuItem(index: 401, label: Globalization.specialVoucher.tr, route: specialVoucher, screen: const SpecialVoucherScreen()),
      ],
    ),
    MenuGroupEntry(
      title: Globalization.reports.tr,
      items: [
        MenuItem(index: 500, label: Globalization.membershipCardSummary.tr, route: membershipCardSummary, screen: const MemberCardSummaryScreen()),
        MenuItem(index: 501, label: Globalization.memberHistorySummary.tr, route: memberHistorySummary, screen: const MemberHistorySummaryScreen()),
        MenuItem(
          index: 502,
          label: Globalization.pointAdjustmentSummary.tr,
          route: pointAdjustmentSummary,
          screen: const PointAdjustmentSummaryScreen(),
        ),
        MenuItem(index: 503, label: Globalization.voucherSummary.tr, route: voucherSummary, screen: const VoucherSummaryScreen()),
      ],
    ),
    MenuGroupEntry(
      title: Globalization.settings.tr,
      items: [
        MenuItem(index: 600, label: Globalization.initialSetup.tr, route: initialSetup, screen: const InitialSetupScreen()),
        MenuItem(index: 601, label: Globalization.aboutUs.tr, route: aboutUs, screen: const AboutUsScreen()),
        MenuItem(index: 603, label: Globalization.accessRole.tr, route: accessRole, screen: const AccessRoleScreen()),
        MenuItem(index: 604, label: Globalization.branch.tr, route: branch, screen: const BranchScreen()),
        MenuItem(index: 605, label: Globalization.memberCard.tr, route: memberCard, screen: const MemberCardScreen()),
        MenuItem(index: 606, label: Globalization.user.tr, route: user, screen: const UserScreen()),
      ],
    ),
  ];
}

sealed class MenuEntry {}

class MenuItem {
  final int index;
  final String label, route;
  final Widget screen;

  const MenuItem({required this.index, required this.label, required this.route, required this.screen});
}

class MenuItemEntry extends MenuEntry {
  final MenuItem item;

  MenuItemEntry(this.item);
}

class MenuGroupEntry extends MenuEntry {
  final String title;
  final List<MenuItem> items;

  MenuGroupEntry({required this.title, required this.items});
}
