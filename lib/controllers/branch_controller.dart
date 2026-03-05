import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/branch_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class BranchController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var branches = <BranchModel>[].obs;

  Future<void> loadAllBranches() async {
    final Map<String, dynamic> data = {"company_id": _auth.user.value.companyID};

    final response = await _api.get(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "get-branch-list",
      module: "BranchController - loadAllBranches",
      data: data,
    );

    if (response == null) return;

    if (response.data[BranchModel.keyBranch] != null) {
      final List<dynamic> list = response.data[BranchModel.keyBranch] ?? [];

      branches.assignAll(list.map((e) => BranchModel.fromJson(e)).toList());
    }
  }

  Future<void> loadBranches(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "get-all-branch/${_auth.user.value.companyID}",
      module: "BranchController - loadBranches",
      data: data,
    );

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[BranchModel.keyBranch] ?? [];

      branches.assignAll(list.map((e) => BranchModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createBranch(Map<String, dynamic> data) async {
    data.addAll({"customer_id": _auth.user.value.companyID});

    final response = await _api.post(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "create-new-branch",
      module: "BranchController - createBranch",
      data: data,
    );

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.showSuccess(Globalization.msgCreateSuccess.trParams({"item": Globalization.branch.tr.toLowerCase()}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> updateBranch(Map<String, dynamic> data) async {
    data.addAll({"customer_id": _auth.user.value.companyID});

    final response = await _api.post(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "update-branch",
      module: "BranchController - updateBranch",
      data: data,
    );

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.showSuccess(Globalization.msgUpdateSuccess.trParams({"item": Globalization.branch.tr}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> deleteBranch(String branchCode) async {
    final response = await _api.delete(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "delete-branch/${_auth.user.value.companyID}/$branchCode",
      module: "BranchController - deleteBranch",
    );

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.showSuccess(Globalization.msgDeleteSuccess.trParams({"item": Globalization.branch.tr}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
