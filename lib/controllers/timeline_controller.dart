import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/timeline_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class TimelineController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var timelines = <TimelineModel>[].obs;

  Future<void> loadTimelines(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-all-timeline", module: "TimelineController - loadTimelines", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[TimelineModel.keyTimeline] ?? [];

      timelines.assignAll(list.map((e) => TimelineModel.fromJson(e)).toList());
      timelines.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      totalItems.value = response.data["total_count"];
    }
  }

  Future<bool> createTimeline(Map<String, dynamic> data, PlatformFile file) async {
    data.addAll({"company_id": _auth.user.value.companyID});

    final response = await _api.post(endPoint: "create-timeline", module: "TimelineController - createTimeline", data: data, file: file);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.showSuccess(Globalization.msgCreateSuccess.trParams({"item": Globalization.timeline.tr.toLowerCase()}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }

  Future<bool> deleteTimeline(Map<String, dynamic> data) async {
    data.addAll({"company_id": _auth.user.value.companyID});

    final response = await _api.delete(endPoint: "delete-timeline", module: "TimelineController - deleteTimeline", data: data);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      if (Get.isDialogOpen ?? false) Get.back();

      MessageHelper.showSuccess(Globalization.msgDeleteSuccess.trParams({"item": Globalization.timeline.tr}));

      return true;
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
