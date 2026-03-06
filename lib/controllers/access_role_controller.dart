import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/access_role_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class AccessRoleController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var accessRoles = <AccessRoleModel>[].obs;

  Future<void> loadAccessRoles(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-all-access-role", module: "AccessRoleController - loadAccessRoles", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[AccessRoleModel.keyAccessRole] ?? [];

      accessRoles.assignAll(list.map((e) => AccessRoleModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createAccessRole(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "create-access-role", module: "AccessRoleController - createAccessRole", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgCreateSuccess.trParams({"item": Globalization.accessRole.tr.toLowerCase()}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
