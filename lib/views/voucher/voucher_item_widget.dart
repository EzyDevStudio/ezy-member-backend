import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/voucher_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/voucher_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_stepper.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class VoucherItemWidget extends StatefulWidget {
  final VoucherModel? voucher;
  final int voucherType;
  final String title;

  const VoucherItemWidget({super.key, this.voucher, required this.voucherType, required this.title});

  @override
  State<VoucherItemWidget> createState() => _VoucherItemWidgetState();
}

class _VoucherItemWidgetState extends State<VoucherItemWidget> {
  final _voucherController = Get.put(VoucherController(), tag: "voucher");
  final Map<int, String> _actionMap = AppStrings.voucherTypes;
  final List<int> _selectedMonths = [];
  final List<String> _months = AppStrings.months;
  final TextEditingController _additionalController = TextEditingController(text: "1");

  late int _selectedAction;
  late TextEditingController _descriptionController;
  late TextEditingController _discountController;
  late TextEditingController _minimumController;
  late TextEditingController _quantityController;
  late TextEditingController _startCollectController;
  late TextEditingController _endCollectController;
  late TextEditingController _startController;
  late TextEditingController _expiredController;
  late TextEditingController _tncController;
  late TextEditingController _pointRedeemController;

  DateTime? _startCollectDate, _endCollectDate, _startDate, _expiredDate;

  @override
  void initState() {
    super.initState();

    if (widget.voucher != null && !widget.voucher!.isNormal) {
      _selectedAction = widget.voucher!.batchCategory;
    } else {
      _selectedAction = _actionMap.keys.first;
    }

    _descriptionController = TextEditingController(text: widget.voucher?.batchDescription);
    _discountController = TextEditingController(text: widget.voucher?.discountValue.toString());
    _minimumController = TextEditingController(text: widget.voucher?.minimumSpend.toStringAsFixed(2));
    _quantityController = TextEditingController(text: widget.voucher?.quantity.toString());
    _startCollectController = TextEditingController(text: widget.voucher?.startCollectDate.tsToStr);
    _endCollectController = TextEditingController(text: widget.voucher?.endCollectDate.tsToStr);
    _startController = TextEditingController(text: widget.voucher?.startDate.tsToStr);
    _expiredController = TextEditingController(text: widget.voucher?.expiredDate.tsToStr);
    _tncController = TextEditingController(text: widget.voucher?.termsCondition);
    _pointRedeemController = TextEditingController(text: widget.voucher?.usePointRedeem.toString());
    _startCollectDate = widget.voucher != null ? DateTime.fromMillisecondsSinceEpoch(widget.voucher!.startCollectDate) : null;
    _endCollectDate = widget.voucher != null ? DateTime.fromMillisecondsSinceEpoch(widget.voucher!.endCollectDate) : null;
    _startDate = widget.voucher != null ? DateTime.fromMillisecondsSinceEpoch(widget.voucher!.startDate) : null;
    _expiredDate = widget.voucher != null ? DateTime.fromMillisecondsSinceEpoch(widget.voucher!.expiredDate) : null;
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

  Future<DateTime?> _selectDate(TextEditingController controller, DateTime? startDate, DateTime? endDate, bool isStart) async {
    final DateTime now = DateTime.now();

    DateTime firstDate, initialDate, lastDate;

    if (startDate != null && endDate == null) {
      firstDate = isStart ? now : startDate;
      initialDate = startDate;
      lastDate = DateTime(now.year + 50);
    } else if (startDate == null && endDate != null) {
      firstDate = now;
      initialDate = isStart ? now : endDate;
      lastDate = isStart ? endDate : DateTime(now.year + 50);
    } else if (startDate != null && endDate != null) {
      firstDate = isStart ? now : startDate;
      initialDate = isStart ? startDate : endDate;
      lastDate = isStart ? endDate : DateTime(now.year + 50);
    } else {
      firstDate = now;
      initialDate = now;
      lastDate = DateTime(now.year + 50);
    }

    final DateTime? pickedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate, initialDate: initialDate);

    if (pickedDate != null) {
      controller.text = pickedDate.dtToStr;

      return pickedDate;
    }

    return null;
  }

  void _create(Map<String, dynamic> data) {
    _handleOperation(() => _voucherController.createVoucher(data));
  }

  void _update(Map<String, dynamic> data) {
    _handleOperation(() => _voucherController.updateVoucher(data));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _discountController.dispose();
    _minimumController.dispose();
    _quantityController.dispose();
    _startCollectController.dispose();
    _endCollectController.dispose();
    _startController.dispose();
    _expiredController.dispose();
    _tncController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomStepper(
    steps: _buildSteps(),
    title: widget.title,
    onSubmit: () {
      String description = _descriptionController.text.trim();
      String discount = _discountController.text.trim();
      String minimum = _minimumController.text.trim();
      String quantity = _quantityController.text.trim();
      String tnc = _tncController.text.trim();
      String startCollect = _startCollectController.text.trim();
      String endCollect = _endCollectController.text.trim();
      String start = _startController.text.trim();
      String expired = _expiredController.text.trim();
      String additional = _additionalController.text.trim();
      String pointRedeem = _pointRedeemController.text.trim();

      if (widget.voucher != null) {
        if (quantity.isEmpty) {
          MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
          return;
        }

        _update({"batch_code": widget.voucher!.batchCode, "quantity": quantity, "voucher_type": widget.voucherType});

        return;
      }

      if (description.isEmpty || discount.isEmpty || minimum.isEmpty || quantity.isEmpty || tnc.isEmpty) {
        MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
      } else if (widget.voucherType == 0 && (startCollect.isEmpty || endCollect.isEmpty || start.isEmpty || expired.isEmpty)) {
        MessageHelper.showWarning(Globalization.msgDateEmpty.tr);
      } else if (widget.voucherType == 1 && _selectedMonths.isEmpty) {
        MessageHelper.showWarning(Globalization.msgDateEmpty.tr);
      } else if (widget.voucherType == 1 && additional.isEmpty) {
        MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
      } else if (widget.voucherType == 1 && _selectedAction == 0 && pointRedeem.isEmpty) {
        MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
      } else {
        Map<String, dynamic> data = {
          "batch_description": description,
          "discount_value": discount,
          "minimum_spend": minimum,
          "quantity": quantity,
          "terms_condition": tnc,
          "voucher_type": widget.voucherType,
        };

        if (widget.voucherType == 0) {
          data.addAll({"start_collect_date": startCollect, "end_collect_date": endCollect, "start_date": start, "expired_date": expired});
        } else if (widget.voucherType == 1) {
          data.addAll({"batch_category": _selectedAction, "use_point_redeem": pointRedeem, "additional": additional, "months": _selectedMonths});
        }

        _create(data);
      }
    },
  );

  List<Step> _buildSteps() => [
    if (widget.voucher != null)
      Step(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: <Widget>[
            CustomRow(data: widget.voucher!.batchDescription, title: Globalization.batchDescription.tr),
            if (widget.voucherType == 1) ...[
              CustomRow(data: _actionMap[widget.voucher!.batchCategory]!, title: Globalization.batchCategory.tr),
              CustomRow(data: widget.voucher!.usePointRedeem.toString(), title: Globalization.pointForRedeem.tr),
            ],
            CustomRow(data: widget.voucher!.discountValue.toString(), title: Globalization.discountValue.tr),
            CustomRow(data: widget.voucher!.minimumSpend.toStringAsFixed(2), title: Globalization.minimumSpend.tr),
            CustomRow(data: widget.voucher!.quantity.toString(), title: Globalization.quantity.tr),
            CustomRow(data: widget.voucher!.startCollectDate.tsToStr, title: Globalization.startCollectDate.tr),
            CustomRow(data: widget.voucher!.endCollectDate.tsToStr, title: Globalization.endCollectDate.tr),
            CustomRow(data: widget.voucher!.startDate.tsToStr, title: Globalization.startDate.tr),
            CustomRow(data: widget.voucher!.expiredDate.tsToStr, title: Globalization.expiredDate.tr),
            CustomRow(data: widget.voucher!.termsCondition, title: Globalization.tncLong.tr),
          ],
        ),
        title: SizedBox.shrink(),
      ),
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: <Widget>[
          CustomTextField(controller: _descriptionController, enabled: widget.voucher == null, label: Globalization.batchDescription.tr),
          if (widget.voucherType == 1) ...[
            CustomDropdown<int>(
              enabled: widget.voucher == null,
              enableSearch: false,
              items: _actionMap.keys.toList(),
              label: Globalization.lblDefault.tr,
              dropdownEntries: (key) => _actionMap[key]!,
              initialSelection: _selectedAction,
              onSelected: (value) {
                _pointRedeemController.text = "";
                setState(() => _selectedAction = value!);
              },
            ),
            if (_selectedAction == 0)
              CustomTextField(
                controller: _pointRedeemController,
                enabled: widget.voucher == null,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                label: Globalization.pointForRedeem.tr,
              ),
          ],
          _buildRow(
            CustomTextField(
              controller: _discountController,
              enabled: widget.voucher == null,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
              label: Globalization.discountValue.tr,
            ),
            CustomTextField(
              controller: _minimumController,
              enabled: widget.voucher == null,
              inputFormatters: [CoordinateFormatter(maxIntegerChars: 9, maxDecimalDigits: 2)],
              label: Globalization.minimumSpend.tr,
            ),
          ),
          CustomTextField(
            controller: _quantityController,
            enabled: widget.voucher == null || (widget.voucher != null && !widget.voucher!.startCollectDate.isExpiredToday),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
            label: Globalization.quantity.tr,
          ),
        ],
      ),
      title: SizedBox.shrink(),
    ),
    if (widget.voucherType == 0)
      Step(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: <Widget>[
            _buildRow(
              CustomTextField(
                controller: _startCollectController,
                enabled: widget.voucher == null,
                icon: Icons.calendar_today_rounded,
                label: Globalization.startCollectDate.tr,
                onTap: () async {
                  final result = await _selectDate(_startCollectController, _startCollectDate, _endCollectDate, true);

                  if (result != null) _startCollectDate = result;
                },
              ),
              CustomTextField(
                controller: _endCollectController,
                enabled: widget.voucher == null,
                icon: Icons.calendar_today_rounded,
                label: Globalization.endCollectDate.tr,
                onTap: () async {
                  final result = await _selectDate(_endCollectController, _startCollectDate, _endCollectDate, false);

                  if (result != null) _endCollectDate = result;
                },
              ),
            ),
            _buildRow(
              CustomTextField(
                controller: _startController,
                enabled: widget.voucher == null,
                icon: Icons.calendar_today_rounded,
                label: Globalization.startDate.tr,
                onTap: () async {
                  final result = await _selectDate(_startController, _startDate, _expiredDate, true);

                  if (result != null) _startDate = result;
                },
              ),
              CustomTextField(
                controller: _expiredController,
                enabled: widget.voucher == null,
                icon: Icons.calendar_today_rounded,
                label: Globalization.expiredDate.tr,
                onTap: () async {
                  final result = await _selectDate(_expiredController, _startDate, _expiredDate, false);

                  if (result != null) _expiredDate = result;
                },
              ),
            ),
          ],
        ),
        title: SizedBox.shrink(),
      )
    else if (widget.voucherType == 1 && widget.voucher == null)
      Step(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: <Widget>[
            CustomTextField(
              controller: _additionalController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
              label: Globalization.additionalMonths.tr,
            ),
            const SizedBox(),
            CustomText(
              Globalization.msgSelectMonth.tr,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              maxLines: null,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _months.length,
              itemBuilder: (context, index) => CheckboxListTile(
                value: _selectedMonths.contains(index),
                onChanged: (bool? value) => setState(() => value == true ? _selectedMonths.add(index) : _selectedMonths.remove(index)),
                title: CustomText(_months[index], fontSize: 16.0),
              ),
            ),
          ],
        ),
        title: SizedBox.shrink(),
      ),
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: <Widget>[
          CustomTextField(controller: _tncController, enabled: widget.voucher == null, maxLines: 20, label: Globalization.tncLong.tr),
        ],
      ),
      title: SizedBox.shrink(),
    ),
  ];

  Widget _buildRow(Widget child1, Widget child2) => Row(
    spacing: 16.0,
    children: <Widget>[
      Expanded(child: child1),
      Expanded(child: child2),
    ],
  );
}
