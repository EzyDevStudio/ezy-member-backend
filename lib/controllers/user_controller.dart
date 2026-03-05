import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/access_role_model.dart';
import 'package:ezymember_backend/models/user_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var accessRoles = <AccessRoleModel>[].obs;
  var users = <UserModel>[].obs;

  Future<void> loadUsers(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-all-user", module: "UserController - loadUsers", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> listAccess = response.data[AccessRoleModel.keyAccessRole] ?? [];
      final List<dynamic> listUser = response.data[UserModel.keyUser] ?? [];

      accessRoles.assignAll(listAccess.map((e) => AccessRoleModel.fromJson(e)).toList());
      users.assignAll(listUser.map((e) => UserModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "create-user", module: "UserController - createUser", data: data);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.showSuccess(Globalization.msgCreateSuccess.trParams({"item": Globalization.user.tr.toLowerCase()}));

      return true;
    } else if (response.data[ApiService.keyStatusCode] == 400) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.name.tr}));
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 401) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.email.tr}));
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 402) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.contactNumber.tr}));
      return false;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "update-user", module: "UserController - updateUser", data: data);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.showSuccess(Globalization.msgUpdateSuccess.trParams({"item": Globalization.user.tr}));

      return true;
    } else if (response.data[ApiService.keyStatusCode] == 400) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.name.tr}));
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 401) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.email.tr}));
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 402) {
      MessageHelper.showWarning(Globalization.msgInUse.trParams({"label": Globalization.contactNumber.tr}));
      return false;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> deleteUser(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.delete(endPoint: "delete-user", module: "UserController - deleteUser", data: data);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.showSuccess(Globalization.msgDeleteSuccess.trParams({"item": Globalization.user.tr}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
