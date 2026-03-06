import 'dart:math';

import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/member_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/models/member_history_model.dart';
import 'package:ezymember_backend/models/member_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_stepper.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberProcessWidget extends StatefulWidget {
  final List<MemberHistoryModel> memberHistory;
  final MemberModel member;
  final MemberCardModel initialCard;
  final String title;

  const MemberProcessWidget({super.key, required this.memberHistory, required this.member, required this.initialCard, required this.title});

  @override
  State<MemberProcessWidget> createState() => _MemberProcessWidgetState();
}

class _MemberProcessWidgetState extends State<MemberProcessWidget> {
  final _memberController = Get.find<MemberController>(tag: "member");
  final Map<int, String> _statusMap = AppStrings.status;

  late bool _isExpired;
  late List<int> _selectedStatuses;
  late List<TextEditingController> _reasonControllers;

  @override
  void initState() {
    super.initState();

    _isExpired = widget.member.memberCard.expiredDate.isExpired;
    _selectedStatuses = List.filled(widget.memberHistory.length, _statusMap.keys.first);
    _reasonControllers = List.generate(widget.memberHistory.length, (_) => TextEditingController());
  }

  String _displayHistoryLabel(int type) {
    if (type == 2) return Globalization.cardTier.tr;
    if (type == 3) return Globalization.credit.tr;
    if (type == 4) return Globalization.point.tr;

    return "";
  }

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

    await _withLoading(operation);
  }

  void _processRequest(Map<String, dynamic> data) {
    _handleOperation(() => _memberController.processRequest(data));
  }

  @override
  void dispose() {
    for (var controller in _reasonControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomStepper(
    steps: _buildSteps(),
    title: widget.title,
    onSubmit: () {
      List<int> ids = [];
      List<int> statuses = [];
      List<String> reasons = [];

      for (int i = 0; i < _reasonControllers.length; i++) {
        if (_reasonControllers[i].text.trim().isNotEmpty) {
          ids.add(widget.memberHistory[i].id);
          statuses.add(_selectedStatuses[i]);
          reasons.add(_reasonControllers[i].text.trim());
        }
      }

      if (ids.isEmpty) {
        MessageHelper.warning(Globalization.msgFieldRequest.tr);
      } else {
        _processRequest({"ids": ids, "statuses": statuses, "reasons": reasons});
      }
    },
  );

  List<Step> _buildSteps() {
    List<Step> steps = [
      Step(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: <Widget>[
            CustomRow(data: widget.member.memberCode, title: Globalization.memberCode.tr),
            CustomRow(data: widget.member.name, title: Globalization.name.tr),
            CustomRow(data: widget.member.email, title: Globalization.email.tr),
            CustomRow(data: "${widget.member.countryCode}${widget.member.contactNumber}", title: Globalization.phoneNumber.tr),
            CustomRow(data: widget.member.dob.tsToStr, title: Globalization.dateOfBirth.tr),
            CustomRow(data: widget.member.fullAddress, title: Globalization.address.tr),
            CustomRow(data: widget.initialCard.cardTier, title: Globalization.cardTier.tr),
            CustomRow(data: widget.initialCard.cardDescription, title: Globalization.cardDescription.tr),
            CustomRow(data: widget.member.credit.credit.toStringAsFixed(2), title: Globalization.credit.tr),
            CustomRow(data: widget.member.point.point.toString(), title: Globalization.point.tr),
            CustomRow(data: widget.member.memberCard.createdAt.tsToStrWithDays, title: Globalization.joined.tr),
            CustomRow(data: widget.member.memberCard.expiredDate.tsToStr, title: Globalization.expiry.tr),
            CustomRow(
              data: max(widget.member.credit.updatedAt, widget.member.point.updatedAt).tsToStrWithDays,
              title: Globalization.lastTransaction.tr,
            ),
            CustomRow(data: widget.member.totalCredit.abs().toStringAsFixed(2), title: Globalization.totalCreditSpend.tr),
            CustomRow(data: widget.member.totalPoint.abs().toString(), title: Globalization.totalPointSpend.tr),
            CustomRow(
              color: _isExpired ? Colors.red : Colors.green,
              data: _isExpired ? Globalization.inactive.tr : Globalization.active.tr,
              title: Globalization.cardStatus.tr,
            ),
          ],
        ),
        title: SizedBox.shrink(),
      ),
    ];

    for (int i = 0; i < widget.memberHistory.length; i++) {
      var history = widget.memberHistory[i];

      steps.add(
        Step(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              CustomRow(data: "${history.value} (${_displayHistoryLabel(history.type)})", title: Globalization.update.tr),
              CustomRow(data: history.name, title: Globalization.requestBy.tr),
              CustomRow(data: history.requestedOn.tsToStrDateTime, title: Globalization.requestOn.tr),
              CustomRow(data: history.requestReason, title: Globalization.requestReason.tr),
              CustomDropdown<int>(
                enableSearch: false,
                items: _statusMap.keys.toList(),
                dropdownEntries: (key) => _statusMap[key]!,
                initialSelection: _selectedStatuses[i],
                onSelected: (value) => setState(() => _selectedStatuses[i] = value!),
              ),
              CustomTextField(controller: _reasonControllers[i], maxLength: 2000, maxLines: 10, label: Globalization.reason.tr),
            ],
          ),
          title: SizedBox.shrink(),
        ),
      );
    }

    return steps;
  }
}
