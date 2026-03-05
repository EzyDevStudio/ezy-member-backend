import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/member_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_history_model.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberHistorySummaryScreen extends StatefulWidget {
  const MemberHistorySummaryScreen({super.key});

  @override
  State<MemberHistorySummaryScreen> createState() => _MemberHistorySummaryScreenState();
}

class _MemberHistorySummaryScreenState extends State<MemberHistorySummaryScreen> {
  final _memberController = Get.put(MemberController(), tag: "member_history_summary");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _memberController.loadMemberHistories(_currentPage, search: search));

  Future<T> _withLoading<T>(Future<T> Function() action) async {
    LoadingOverlay.show(context);

    try {
      return await action();
    } finally {
      LoadingOverlay.hide();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: <Widget>[
            CustomSearchTextField(
              controller: _searchController,
              onPressedClear: () {
                _searchController.clear();
                _onRefresh();
              },
              onPressedSearch: () => _onRefresh(search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim()),
            ),
            CustomDataTable<MemberHistoryModel>(
              ratios: MemberHistoryModel.ratios,
              headers: MemberHistoryModel.headers,
              models: List.from(_memberController.memberHistories),
              variables: MemberHistoryModel.variables,
              actions: (MemberHistoryModel history) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.viewDetails.tr,
                  onTap: () => _showDetailDialog(history, Globalization.viewDetails.tr),
                  child: Icon(Icons.visibility_rounded, color: Colors.blue),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _memberController.totalItems.value,
              onPageChanged: (page) => setState(() {
                _currentPage = page;
                _onRefresh();
              }),
            ),
          ],
        ),
      ),
    ),
  );

  void _showDetailDialog(MemberHistoryModel history, String title) => Get.dialog(
    CustomDetailModal(
      title: title,
      content: Column(
        spacing: 16.0,
        children: <Widget>[
          CustomRow(data: history.memberCode, title: Globalization.memberCode.tr),
          CustomRow(data: AppStrings.status[history.status] ?? Globalization.pending.tr, title: Globalization.status.tr),
          CustomRow(data: AppStrings.requestTypes[history.type] ?? Globalization.pending.tr, title: Globalization.requestType.tr),
          CustomRow(data: history.value, title: Globalization.requestValue.tr),
          CustomRow(data: history.requestedName, title: Globalization.requestedBy.tr),
          CustomRow(data: history.requestedOn.tsToStrDateTime, title: Globalization.requestOn.tr),
          CustomRow(data: history.requestReason, title: Globalization.requestReason.tr),
          CustomRow(data: history.actionedName, title: Globalization.actionedBy.tr),
          CustomRow(data: history.actionedOn.tsToStrDateTime, title: Globalization.actionOn.tr),
          CustomRow(data: history.actionReason, title: Globalization.actionReason.tr),
        ],
      ),
    ),
  );
}
