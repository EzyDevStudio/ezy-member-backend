import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/controllers/member_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/models/member_history_model.dart';
import 'package:ezymember_backend/models/member_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/views/member/member_request_widget.dart';
import 'package:ezymember_backend/views/member/member_process_widget.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_spinner.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  final _authController = Get.find<AuthController>();
  final _memberController = Get.put(MemberController(), tag: "member");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  List<MemberCardModel> _memberCards = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _memberController.loadMembers(_currentPage, search: search));

  Future<T> _withLoading<T>(Future<T> Function() action) async {
    LoadingOverlay.show(context);

    try {
      return await action();
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _handleOperation(Future<bool> Function() operation) async {
    if (!await ConnectionService.checkConnection()) return;

    final success = await _withLoading(operation);

    if (success) _onRefresh();
  }

  void _update(Map<String, dynamic> data) {
    _handleOperation(() => _memberController.requestUpdate(data));
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    _memberCards = _memberController.memberCards;

    return Scaffold(
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
            CustomDataTable<MemberModel>(
              ratios: MemberModel.ratios,
              headers: MemberModel.headers,
              models: List.from(_memberController.members),
              variables: MemberModel.variables,
              actions: (MemberModel member) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.update.tr,
                  onTap: () => _showRequestDialog(member, Globalization.update.tr),
                  child: Icon(Icons.credit_card_rounded, color: Colors.grey),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.renewExpiry.tr,
                  onTap: () => _showRenewExpiryDialog(member, Globalization.renewExpiry.tr),
                  child: Icon(Icons.refresh_rounded, color: Colors.green),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.changeStatus.tr,
                  onTap: () => _showChangeStatusDialog(member),
                  child: Icon(Icons.block_rounded, color: Colors.red),
                ),
              ],
              pending: (MemberModel member) => member.isPending
                  ? CustomOutlinedButton(
                      tooltip: Globalization.pending.tr,
                      onTap: () => _showProcessDialog(member, Globalization.updateTier.tr),
                      child: Icon(Icons.pending_actions_rounded, color: Colors.red),
                    )
                  : SizedBox.shrink(),
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
    );
  });

  void _showRequestDialog(MemberModel member, String title) async {
    List<MemberHistoryModel> result = await _withLoading(() => _memberController.getRequest({"member_code": member.memberCode}));

    if (result.isNotEmpty) {
      MessageHelper.info(Globalization.msgMemberPending.tr);
      return;
    }

    final request = await Get.dialog(
      barrierDismissible: false,
      MemberRequestWidget(
        memberCards: _memberCards,
        member: member,
        initialCard: _memberCards.firstWhere((card) => card.cardCode == member.memberCard.cardCode, orElse: () => MemberCardModel.empty()),
        title: title,
      ),
    );

    if (request != null && request) _onRefresh();
  }

  void _showProcessDialog(MemberModel member, String title) async {
    if (_memberCards.isEmpty) {
      return;
    } else if (_authController.user.value.userType == 0) {
      MessageHelper.info(Globalization.msgNoPermission.tr);
      return;
    }

    List<MemberHistoryModel> result = await _withLoading(() => _memberController.getRequest({"member_code": member.memberCode}));

    if (result.isEmpty) return;

    final request = await Get.dialog(
      barrierDismissible: false,
      MemberProcessWidget(
        memberHistory: result,
        member: member,
        initialCard: _memberCards.firstWhere((card) => card.cardCode == member.memberCard.cardCode, orElse: () => MemberCardModel.empty()),
        title: title,
      ),
    );

    if (request != null && request) _onRefresh();
  }

  void _showRenewExpiryDialog(MemberModel member, String title) {
    int year = 1;

    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setStateModal) => CustomItemModal(
          isCreate: false,
          title: title,
          onTap: () => _update({
            "member_code": member.memberCode,
            "types": [0],
            "values": [year],
          }),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: <Widget>[
                CustomRow(data: member.memberCode, title: Globalization.memberCode.tr),
                CustomRow(data: member.name, title: Globalization.name.tr),
                CustomRow(data: member.memberCard.expiredDate.tsToStr, title: Globalization.expiry.tr),
                const SizedBox(),
                CustomSpinner(value: year, label: Globalization.renewalYear.tr, onChanged: (value) => setStateModal(() => year = value)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeStatusDialog(MemberModel member) => Get.dialog(
    CustomConfirmationDialog(
      content: member.status == 0 ? Globalization.msgMemberActivate.tr : Globalization.msgMemberDeactivate.tr,
      onConfirm: () => _update({
        "member_code": member.memberCode,
        "types": [1],
      }),
    ),
  );
}
