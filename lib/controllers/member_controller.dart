import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/models/member_history_model.dart';
import 'package:ezymember_backend/models/member_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class MemberController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var members = <MemberModel>[].obs;
  var memberCards = <MemberCardModel>[].obs;
  var memberHistories = <MemberHistoryModel>[].obs;

  Future<void> loadMembers(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-all-member", module: "MemberController - loadMembers", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> memberList = response.data[MemberModel.keyMember] ?? [];
      final List<dynamic> memberCardList = response.data[MemberCardModel.keyCard] ?? [];

      members.assignAll(memberList.map((e) => MemberModel.fromJson(e)).toList());
      memberCards.assignAll(memberCardList.map((e) => MemberCardModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<void> loadMemberHistories(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-member-history-adjustment", module: "MemberController - loadMemberHistories", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[MemberHistoryModel.keyMemberHistory] ?? [];

      memberHistories.assignAll(list.map((e) => MemberHistoryModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> requestUpdate(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName, "user_id": _auth.user.value.userID});

    final response = await _api.post(endPoint: "request-update", module: "MemberController - requestUpdate", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgUpdateSuccess.trParams({"item": Globalization.member.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<List<MemberHistoryModel>> getRequest(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.get(endPoint: "get-request", module: "MemberController - getRequest", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return [];
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[MemberHistoryModel.keyMemberHistory] ?? [];

      return list.map((e) => MemberHistoryModel.fromJson(e)).toList();
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return [];
    }
  }

  Future<bool> processRequest(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName, "user_id": _auth.user.value.userID});

    final response = await _api.post(endPoint: "process-request", module: "MemberController - processRequest", data: data);

    if (response == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back(result: true);

      MessageHelper.success(Globalization.msgUpdateSuccess.trParams({"item": Globalization.member.tr}));

      return true;
    } else {
      MessageHelper.error(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
