import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class MemberCardController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var memberCards = <MemberCardModel>[].obs;

  Future<void> loadMemberCards(int offset, {int? isSummary, String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
      if (isSummary != null) "is_summary": isSummary,
    };

    final response = await _api.get(endPoint: "get-all-member-card", module: "MemberCardController - loadMemberCards", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[MemberCardModel.keyCard] ?? [];

      memberCards.assignAll(list.map((e) => MemberCardModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createMemberCard(Map<String, dynamic> data, PlatformFile file) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "create-member-card", module: "MemberCardController - createMemberCard", data: data, file: file);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgCreateSuccess.trParams({"item": Globalization.memberCard.tr.toLowerCase()}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> updateMemberCard(Map<String, dynamic> data, PlatformFile? file) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "update-member-card", module: "MemberCardController - updateMemberCard", data: data, file: file);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgUpdateSuccess.trParams({"item": Globalization.memberCard.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> deleteMemberCard(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.delete(endPoint: "delete-member-card", module: "MemberCardController - deleteMemberCard", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.success(Globalization.msgDeleteSuccess.trParams({"item": Globalization.memberCard.tr}));

      return true;
    } else if (response.data[ApiService.keyStatusCode] == 400) {
      MessageHelper.info(Globalization.msgCardInUse.tr);
      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
