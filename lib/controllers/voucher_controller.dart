import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/voucher_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var vouchers = <VoucherModel>[].obs;

  Future<void> loadVouchers(int offset, {int? type, String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      "voucher_type": type,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "retrieve-all-voucher", module: "VoucherController - loadVouchers", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[VoucherModel.keyVoucher] ?? [];

      vouchers.assignAll(list.map((e) => VoucherModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<void> loadSummaries(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "retrieve-all-summary", module: "VoucherController - loadSummaries", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[VoucherModel.keyVoucher] ?? [];

      vouchers.assignAll(list.map((e) => VoucherModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createVoucher(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "create-voucher", module: "VoucherController - createVoucher", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgCreateSuccess.trParams({"item": Globalization.voucher.tr.toLowerCase()}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> updateVoucher(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "update-voucher", module: "VoucherController - updateVoucher", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgUpdateSuccess.trParams({"item": Globalization.voucher.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> deleteVoucher(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.delete(endPoint: "delete-voucher", module: "VoucherController - deleteVoucher", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.success(Globalization.msgDeleteSuccess.trParams({"item": Globalization.voucher.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
