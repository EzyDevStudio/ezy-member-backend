import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/initial_setup_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _setupController = Get.put(InitialSetupController(), tag: "initial_setup");
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _refereeController = TextEditingController();
  final TextEditingController _referrerController = TextEditingController();
  final TextEditingController _initiateController = TextEditingController();
  final TextEditingController _earnPointController = TextEditingController();
  final TextEditingController _earnPriceController = TextEditingController();
  final TextEditingController _redeemPointController = TextEditingController();
  final TextEditingController _redeemPriceController = TextEditingController();
  final Map<int, String> _actionMap = AppStrings.roundingMethods;

  late int _selectedAction = _actionMap.keys.first;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh() async {
    await _withLoading(() => _setupController.loadInitialSetup());

    final referee = _setupController.referralProgram.firstWhere((r) => r.referralName == "Referee");
    final referrer = _setupController.referralProgram.firstWhere((r) => r.referralName == "Referrer");

    setState(() {
      _durationController.text = _setupController.duration.value.duration.toString();
      _refereeController.text = referee.referralPoint.toString();
      _referrerController.text = referrer.referralPoint.toString();
      _initiateController.text = _setupController.pointSetting.value.initiatePoint.toString();
      _earnPointController.text = _setupController.pointSetting.value.earnPoint.toString();
      _earnPriceController.text = _setupController.pointSetting.value.earnPrice.toStringAsFixed(2);
      _redeemPointController.text = _setupController.pointSetting.value.redeemPoint.toString();
      _redeemPriceController.text = _setupController.pointSetting.value.redeemPrice.toStringAsFixed(2);
      _selectedAction = _setupController.pointSetting.value.roundingMethod;
    });
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

    final success = await _withLoading(operation);

    if (success) _onRefresh();
  }

  void _update() {
    String duration = _durationController.text.trim();
    String referee = _refereeController.text.trim();
    String referrer = _referrerController.text.trim();
    String initiate = _initiateController.text.trim();
    String earnPoint = _earnPointController.text.trim();
    String earnPrice = _earnPriceController.text.trim();
    String redeemPoint = _redeemPointController.text.trim();
    String redeemPrice = _redeemPriceController.text.trim();

    if (duration.isEmpty ||
        referee.isEmpty ||
        referrer.isEmpty ||
        initiate.isEmpty ||
        earnPoint.isEmpty ||
        earnPrice.isEmpty ||
        redeemPoint.isEmpty ||
        redeemPrice.isEmpty) {
      MessageHelper.warning(Globalization.msgFieldEmpty.tr);
      return;
    }

    Map<String, dynamic> data = {
      "register_duration": duration,
      "referee": referee,
      "referrer": referrer,
      "initiate_point": initiate,
      "earn_point": earnPoint,
      "earn_price": earnPrice,
      "redeem_point": redeemPoint,
      "redeem_price": redeemPrice,
      "rounding_method": _selectedAction,
    };

    _handleOperation(() => _setupController.updateInitialSetup(data));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: ListView(
      padding: EdgeInsets.all(24.0),
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.0,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: <Widget>[
                  CustomTextField(
                    controller: _initiateController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    label: Globalization.initiatePoint.tr,
                  ),
                  CustomText(Globalization.msgInitiatePoint.tr, fontSize: 13.0),
                  const SizedBox(),
                  CustomTextField(
                    controller: _earnPointController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    label: Globalization.earnPoint.tr,
                  ),
                  CustomTextField(
                    controller: _earnPriceController,
                    inputFormatters: [CoordinateFormatter(maxIntegerChars: 9, maxDecimalDigits: 2)],
                    label: Globalization.earnPrice.tr,
                  ),
                  CustomText(Globalization.msgEarnPoint.tr, fontSize: 13.0),
                  const SizedBox(),
                  CustomTextField(
                    controller: _redeemPointController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    label: Globalization.redeemPoint.tr,
                  ),
                  CustomTextField(
                    controller: _redeemPriceController,
                    inputFormatters: [CoordinateFormatter(maxIntegerChars: 9, maxDecimalDigits: 2)],
                    label: Globalization.redeemPrice.tr,
                  ),
                  CustomText(Globalization.msgRedeemPoint.tr, fontSize: 13.0),
                  const SizedBox(),
                  CustomDropdown<int>(
                    enableSearch: false,
                    items: _actionMap.keys.toList(),
                    label: Globalization.roundingMethod.tr,
                    dropdownEntries: (key) => _actionMap[key]!,
                    initialSelection: _selectedAction,
                    onSelected: (value) => setState(() => _selectedAction = value!),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: <Widget>[
                  CustomTextField(
                    controller: _durationController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
                    label: Globalization.membershipDuration.tr,
                  ),
                  CustomText(Globalization.msgDurationSetup.tr, fontSize: 13.0, maxLines: null),
                  const SizedBox(),
                  CustomTextField(
                    controller: _refereeController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    label: Globalization.referee.tr,
                  ),
                  CustomTextField(
                    controller: _referrerController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                    label: Globalization.referrer.tr,
                  ),
                  CustomText(Globalization.msgReferralSetup.tr, fontSize: 13.0, maxLines: null),
                  CustomFilledButton(label: Globalization.update.tr, onTap: () => _update()),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
