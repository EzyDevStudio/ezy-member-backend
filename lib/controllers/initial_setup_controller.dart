import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/duration_model.dart';
import 'package:ezymember_backend/models/point_setting_model.dart';
import 'package:ezymember_backend/models/referral_program_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class InitialSetupController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final ApiService _api = ApiService();

  var referralProgram = <ReferralProgramModel>[].obs;
  var duration = DurationModel.empty().obs;
  var pointSetting = PointSettingModel.empty().obs;

  Future<void> loadInitialSetup() async {
    final Map<String, dynamic> data = {"database_name": _auth.user.value.databaseName};

    final response = await _api.get(endPoint: "get-initial-setup", module: "InitialSetupController - loadInitialSetup", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[ReferralProgramModel.keyReferralProgram] ?? [];

      referralProgram.assignAll(list.map((e) => ReferralProgramModel.fromJson(e)).toList());
      duration.value = DurationModel.fromJson(response.data[DurationModel.keyDuration]);
      pointSetting.value = PointSettingModel.fromJson(response.data[PointSettingModel.keyPointSetting]);
    }
  }

  Future<bool> updateInitialSetup(Map<String, dynamic> data) async {
    data.addAll({"database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "update-initial-setup", module: "InitialSetupController - updateInitialSetup", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgUpdateSuccess.trParams({"item": Globalization.initialSetup.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
