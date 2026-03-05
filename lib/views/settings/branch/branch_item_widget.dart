import 'package:ezymember_backend/controllers/branch_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/branch_model.dart';
import 'package:ezymember_backend/models/postcode_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_stepper.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BranchItemWidget extends StatefulWidget {
  final BranchModel? branch;
  final List<PostcodeModel> postcodes;
  final String title;

  const BranchItemWidget({super.key, this.branch, required this.postcodes, required this.title});

  @override
  State<BranchItemWidget> createState() => _BranchItemWidgetState();
}

class _BranchItemWidgetState extends State<BranchItemWidget> {
  final _branchController = Get.find<BranchController>(tag: "branch");
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _postcodeFocusNode = FocusNode();

  late List<String> _stateList;
  late String _selectedState;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _contact1Controller;
  late TextEditingController _contact2Controller;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _address3Controller;
  late TextEditingController _address4Controller;
  late TextEditingController _postcodeController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();

    _stateList = widget.postcodes.map((p) => p.stateName).toSet().toList()..sort((a, b) => a.compareTo(b));
    _selectedState = widget.branch == null ? _stateList.first : widget.branch!.state;
    _nameController = TextEditingController(text: widget.branch?.branchName);
    _descriptionController = TextEditingController(text: widget.branch?.branchDescription);
    _contact1Controller = TextEditingController(text: widget.branch?.contactNumber);
    _contact2Controller = TextEditingController(text: widget.branch?.contactNumber2);
    _address1Controller = TextEditingController(text: widget.branch?.address1);
    _address2Controller = TextEditingController(text: widget.branch?.address2);
    _address3Controller = TextEditingController(text: widget.branch?.address3);
    _address4Controller = TextEditingController(text: widget.branch?.address4);
    _postcodeController = TextEditingController(text: widget.branch?.postcode);
    _cityController = TextEditingController(text: widget.branch?.city);
    _stateController = TextEditingController(text: widget.branch?.state);
    _latitudeController = TextEditingController(text: widget.branch?.latitude.toString());
    _longitudeController = TextEditingController(text: widget.branch?.longitude.toString());
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
    _handleOperation(() => _branchController.createBranch(data));
  }

  void _update(Map<String, dynamic> data) {
    _handleOperation(() => _branchController.updateBranch(data));
  }

  @override
  void dispose() {
    _cityFocusNode.dispose();
    _postcodeFocusNode.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _contact1Controller.dispose();
    _contact2Controller.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _address4Controller.dispose();
    _postcodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomStepper(
    steps: _buildSteps(),
    title: widget.title,
    onSubmit: () {
      String name = _nameController.text.trim();
      String description = _descriptionController.text.trim();
      String contact1 = _contact1Controller.text.trim();
      String contact2 = _contact2Controller.text.trim();
      String address1 = _address1Controller.text.trim();
      String address2 = _address2Controller.text.trim();
      String address3 = _address3Controller.text.trim();
      String address4 = _address4Controller.text.trim();
      String postcode = _postcodeController.text.trim();
      String city = _cityController.text.trim();
      String state = _stateController.text.trim();
      String latitude = _latitudeController.text.trim();
      String longitude = _longitudeController.text.trim();

      if (name.isEmpty || description.isEmpty || contact1.isEmpty || address1.isEmpty || postcode.isEmpty || city.isEmpty || state.isEmpty) {
        MessageHelper.showWarning(Globalization.msgFieldRequired.tr);
      } else {
        Map<String, dynamic> data = {
          if (widget.branch != null) "branch_code": widget.branch!.branchCode,
          "branch_name": name,
          "branch_description": description,
          "contact_number": contact1,
          "contact_number2": contact2,
          "address1": address1,
          "address2": address2,
          "address3": address3,
          "address4": address4,
          "postcode": postcode,
          "city": city,
          "state": state,
          "latitude": latitude,
          "longitude": longitude,
        };

        widget.branch == null ? _create(data) : _update(data);
      }
    },
  );

  List<Step> _buildSteps() => [
    Step(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: <Widget>[
          if (widget.branch != null)
            CustomTextField(
              controller: TextEditingController(text: widget.branch?.branchCode),
              enabled: widget.branch == null,
              label: Globalization.branchCode.tr,
            ),
          CustomTextField(controller: _nameController, isRequired: true, maxLength: 100, label: Globalization.branchName.tr),
          CustomTextField(
            controller: _descriptionController,
            isRequired: true,
            maxLength: 150,
            maxLines: 2,
            label: Globalization.branchDescription.tr,
          ),
          _buildRow(
            CustomTextField(
              controller: _contact1Controller,
              isRequired: true,
              inputFormatters: [LengthLimitingTextInputFormatter(15), FilteringTextInputFormatter.allow(RegExp(r"[0-9+\-]"))],
              label: "${Globalization.contactNumber.tr} 1",
            ),
            CustomTextField(
              controller: _contact2Controller,
              inputFormatters: [LengthLimitingTextInputFormatter(15), FilteringTextInputFormatter.allow(RegExp(r"[0-9+\-]"))],
              label: "${Globalization.contactNumber.tr} 2",
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
          _buildRow(
            CustomTextField(controller: _address1Controller, isRequired: true, maxLength: 50, label: "${Globalization.address.tr} 1"),
            CustomTextField(controller: _address2Controller, maxLength: 50, label: "${Globalization.address.tr} 2"),
          ),
          _buildRow(
            CustomTextField(controller: _address3Controller, maxLength: 50, label: "${Globalization.address.tr} 3"),
            CustomTextField(controller: _address4Controller, maxLength: 50, label: "${Globalization.address.tr} 4"),
          ),
          _buildRow(
            CustomAutocomplete(
              controller: _cityController,
              focusNode: _cityFocusNode,
              postcodes: widget.postcodes,
              type: PostType.city,
              selectedState: _selectedState,
              onSelected: (PostcodeModel selection) => setState(() {
                _selectedState = selection.stateName;
                _postcodeController.text = selection.postcode;
                _cityController.text = selection.city;
                _stateController.text = selection.stateName;
              }),
            ),
            CustomAutocomplete(
              controller: _postcodeController,
              focusNode: _postcodeFocusNode,
              postcodes: widget.postcodes,
              type: PostType.postcode,
              selectedState: _selectedState,
              onSelected: (PostcodeModel selection) => setState(() {
                _selectedState = selection.stateName;
                _postcodeController.text = selection.postcode;
                _cityController.text = selection.city;
                _stateController.text = selection.stateName;
              }),
            ),
          ),
          if (_stateList.isNotEmpty)
            CustomDropdown<String>(
              isRequired: true,
              items: _stateList,
              label: Globalization.state.tr,
              dropdownEntries: (s) => s,
              initialSelection: _selectedState,
              onSelected: (value) => setState(() => _selectedState = value!),
            ),
          _buildRow(
            CustomTextField(controller: _latitudeController, inputFormatters: [CoordinateFormatter()], label: Globalization.latitude.tr),
            CustomTextField(controller: _longitudeController, inputFormatters: [CoordinateFormatter()], label: Globalization.longitude.tr),
          ),
        ],
      ),
      title: SizedBox.shrink(),
    ),
  ];

  Widget _buildRow(Widget widget1, Widget widget2) => Row(
    spacing: 16.0,
    children: <Widget>[
      Expanded(child: widget1),
      Expanded(child: widget2),
    ],
  );
}
