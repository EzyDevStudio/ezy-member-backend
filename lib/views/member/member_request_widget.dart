import 'dart:math';

import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/member_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/models/member_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_stepper.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MemberRequestWidget extends StatefulWidget {
  final List<MemberCardModel> memberCards;
  final MemberModel member;
  final MemberCardModel initialCard;
  final String title;

  const MemberRequestWidget({super.key, required this.memberCards, required this.member, required this.initialCard, required this.title});

  @override
  State<MemberRequestWidget> createState() => _MemberRequestWidgetState();
}

class _MemberRequestWidgetState extends State<MemberRequestWidget> {
  final _memberController = Get.find<MemberController>(tag: "member");
  final TextEditingController _reasonTierController = TextEditingController();
  final TextEditingController _reasonCreditController = TextEditingController();
  final TextEditingController _reasonPointController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final Map<int, String> _actionMap = AppStrings.action;

  late bool _isExpired;
  late int _selectedActionCredit;
  late int _selectedActionPoint;
  late MemberCardModel _selectedCard;

  bool _isCardDetail = false;
  bool _isCardTier = false;
  bool _isCredit = false;
  bool _isPoint = false;

  @override
  void initState() {
    super.initState();

    _isExpired = widget.member.memberCard.expiredDate.isExpired;
    _selectedActionCredit = _actionMap.keys.first;
    _selectedActionPoint = _actionMap.keys.first;
    _selectedCard = widget.initialCard;
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

  void _requestUpdate(Map<String, dynamic> data) {
    _handleOperation(() => _memberController.requestUpdate(data));
  }

  @override
  void dispose() {
    _reasonTierController.dispose();
    _reasonCreditController.dispose();
    _reasonPointController.dispose();
    _creditController.dispose();
    _pointController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomStepper(
    steps: _buildSteps(),
    title: widget.title,
    onSubmit: () {
      List<int> types = [];
      List<String> values = [];
      List<String> reasons = [];

      String reasonTier = _reasonTierController.text.trim();
      String reasonCredit = _reasonCreditController.text.trim();
      String reasonPoint = _reasonPointController.text.trim();
      String credit = _creditController.text.trim();
      String point = _pointController.text.trim();

      Map<String, dynamic> data = {"member_code": widget.member.memberCode};

      if (_isCardTier) {
        if (_selectedCard.cardTier == widget.initialCard.cardTier) {
          MessageHelper.showWarning(Globalization.msgCardTierSimilar.tr);
          return;
        } else if (reasonTier.isEmpty) {
          MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
          return;
        } else {
          types.add(2);
          values.add(_selectedCard.cardCode);
          reasons.add(reasonTier);
        }
      }

      if (_isCredit) {
        if (reasonCredit.isEmpty || credit.isEmpty) {
          MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
          return;
        } else {
          types.add(3);
          values.add(_selectedActionCredit == 0 ? "-$credit" : credit);
          reasons.add(reasonCredit);
        }
      }

      if (_isPoint) {
        if (reasonPoint.isEmpty || point.isEmpty) {
          MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
          return;
        } else {
          types.add(4);
          values.add(_selectedActionPoint == 0 ? "-$point" : point);
          reasons.add(reasonPoint);
        }
      }

      if (types.isNotEmpty && types.length == values.length && types.length == reasons.length) {
        data.addAll({"types": types, "values": values, "reasons": reasons});

        _requestUpdate(data);
      }
    },
  );

  List<Step> _buildSteps() => [
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
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _isCardTier,
            onChanged: (value) => setState(() => _isCardTier = value!),
            title: CustomText(
              Globalization.msgTickReminder.trParams({"item": Globalization.cardTier.tr.toLowerCase()}),
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              maxLines: null,
            ),
          ),
          CustomDropdown<MemberCardModel>(
            enableSearch: false,
            items: widget.memberCards,
            dropdownEntries: (m) => "${m.cardTier} (x${m.cardMagnification.toStringAsFixed(1)})",
            initialSelection: _selectedCard,
            onSelected: (value) => setState(() => _selectedCard = value!),
          ),
          CustomTextField(controller: _reasonTierController, maxLength: 2000, maxLines: 10, label: Globalization.reason.tr),
          CustomFilledButton(
            isLarge: false,
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            foregroundColor: Theme.of(context).colorScheme.onTertiary,
            label: Globalization.cardDetails.tr,
            onTap: () => setState(() => _isCardDetail = !_isCardDetail),
          ),
          if (_isCardDetail)
            for (var card in widget.memberCards)
              Column(
                children: <Widget>[
                  CustomRow(data: card.cardTier, title: Globalization.cardTier.tr),
                  CustomRow(data: card.cardDescription, title: Globalization.cardDescription.tr),
                ],
              ),
        ],
      ),
      title: SizedBox.shrink(),
    ),
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _isCredit,
            onChanged: (value) => setState(() => _isCredit = value!),
            title: CustomText(
              Globalization.msgTickReminder.trParams({"item": Globalization.credit.tr.toLowerCase()}),
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              maxLines: null,
            ),
          ),
          Row(
            spacing: 16.0,
            children: <Widget>[
              Expanded(
                child: CustomDropdown<int>(
                  enableSearch: false,
                  items: _actionMap.keys.toList(),
                  dropdownEntries: (key) => _actionMap[key]!,
                  initialSelection: _selectedActionCredit,
                  onSelected: (value) => setState(() => _selectedActionCredit = value!),
                ),
              ),
              Expanded(
                child: CustomTextField(
                  controller: _creditController,
                  showTitle: false,
                  inputFormatters: [CoordinateFormatter(maxIntegerChars: 9, maxDecimalDigits: 2)],
                  label: Globalization.credit.tr,
                ),
              ),
            ],
          ),
          CustomTextField(controller: _reasonCreditController, maxLength: 2000, maxLines: 10, label: Globalization.reason.tr),
        ],
      ),
      title: SizedBox.shrink(),
    ),
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _isPoint,
            onChanged: (value) => setState(() => _isPoint = value!),
            title: CustomText(
              Globalization.msgTickReminder.trParams({"item": Globalization.point.tr.toLowerCase()}),
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              maxLines: null,
            ),
          ),
          Row(
            spacing: 16.0,
            children: <Widget>[
              Expanded(
                child: CustomDropdown<int>(
                  enableSearch: false,
                  items: _actionMap.keys.toList(),
                  dropdownEntries: (key) => _actionMap[key]!,
                  initialSelection: _selectedActionPoint,
                  onSelected: (value) => setState(() => _selectedActionPoint = value!),
                ),
              ),
              Expanded(
                child: CustomTextField(
                  controller: _pointController,
                  showTitle: false,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                  label: Globalization.point.tr,
                ),
              ),
            ],
          ),
          CustomTextField(controller: _reasonPointController, maxLength: 2000, maxLines: 10, label: Globalization.reason.tr),
        ],
      ),
      title: SizedBox.shrink(),
    ),
  ];
}
