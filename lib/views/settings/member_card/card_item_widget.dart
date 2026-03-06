import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/member_card_controller.dart';
import 'package:ezymember_backend/helpers/media_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_spinner.dart';
import 'package:ezymember_backend/widgets/custom_stepper.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardItemWidget extends StatefulWidget {
  final MemberCardModel? card;
  final String title;

  const CardItemWidget({super.key, this.card, required this.title});

  @override
  State<CardItemWidget> createState() => _CardItemWidgetState();
}

class _CardItemWidgetState extends State<CardItemWidget> {
  final _cardController = Get.find<MemberCardController>(tag: "member_card");
  final Map<int, String> _actionMap = AppStrings.isDefaults;

  late double _magnification = 1.0;
  late int _selectedAction;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _tierController;

  PlatformFile? _image;

  @override
  void initState() {
    super.initState();

    _magnification = widget.card == null ? 1.0 : widget.card!.cardMagnification;
    _selectedAction = widget.card == null ? _actionMap.keys.first : widget.card!.isDefault;
    _codeController = TextEditingController(text: widget.card?.cardCode);
    _descriptionController = TextEditingController(text: widget.card?.cardDescription);
    _tierController = TextEditingController(text: widget.card?.cardTier);
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

  void _create(Map<String, dynamic> data) {
    if (_image != null) {
      _handleOperation(() => _cardController.createMemberCard(data, _image!));
    } else {
      MessageHelper.warning(Globalization.msgImageEmpty.tr);
    }
  }

  void _update(Map<String, dynamic> data) {
    _handleOperation(() => _cardController.updateMemberCard(data, _image));
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _tierController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomStepper(
    steps: _buildSteps(),
    title: widget.title,
    onSubmit: () {
      String code = _codeController.text.trim();
      String tier = _tierController.text.trim();
      String description = _descriptionController.text.trim();

      if (code.isEmpty || tier.isEmpty || description.isEmpty) {
        MessageHelper.warning(Globalization.msgFieldEmpty.tr);
      } else if (widget.card != null && widget.card!.isDefault == 1 && _selectedAction == 0) {
        MessageHelper.info(Globalization.msgDeleteDefaultCard.tr);
      } else {
        Map<String, dynamic> data = {
          "card_code": _codeController.text.trim(),
          "card_tier": _tierController.text.trim(),
          "card_description": _descriptionController.text.trim(),
          "card_magnification": _magnification,
          "is_default": _selectedAction,
        };

        widget.card == null ? _create(data) : _update(data);
      }
    },
  );

  List<Step> _buildSteps() => [
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          CustomTextField(controller: _codeController, enabled: widget.card == null, maxLength: 100, label: Globalization.cardCode.tr),
          CustomTextField(controller: _tierController, maxLength: 100, label: Globalization.cardTier.tr),
          CustomTextField(controller: _descriptionController, maxLength: 2000, maxLines: 5, label: Globalization.cardDescription.tr),
        ],
      ),
      title: SizedBox.shrink(),
    ),
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16.0,
        children: <Widget>[
          SizedBox(
            height: 200.0,
            child: CustomDottedContainer(
              onTap: () async {
                final pickedImg = await MediaHelper.processImage();

                if (pickedImg != null) setState(() => _image = pickedImg);
              },
              child: _buildImage(),
            ),
          ),
          const SizedBox(),
          SizedBox(
            width: double.infinity,
            child: CustomDoubleSpinner(
              min: 1.0,
              value: _magnification,
              label: Globalization.cardMagnification.tr,
              onChanged: (value) => setState(() => _magnification = value),
            ),
          ),
          CustomDropdown<int>(
            enableSearch: false,
            items: _actionMap.keys.toList(),
            label: Globalization.lblDefault.tr,
            dropdownEntries: (key) => _actionMap[key]!,
            initialSelection: _selectedAction,
            onSelected: (value) => setState(() => _selectedAction = value!),
          ),
        ],
      ),
      title: SizedBox.shrink(),
    ),
  ];

  Widget _buildImage() {
    if (_image != null) return Image.memory(_image!.bytes!, fit: BoxFit.contain);
    if (widget.card != null && widget.card!.cardImage.isNotEmpty) return Image.network(widget.card!.cardImage, fit: BoxFit.contain);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.0,
        children: <Widget>[
          Icon(Icons.add_rounded, color: Colors.black87, size: 50.0),
          CustomText(Globalization.chooseImage.tr, fontSize: 18.0),
        ],
      ),
    );
  }
}
