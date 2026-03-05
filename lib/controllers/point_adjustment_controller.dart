import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/models/point_adjustment_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class PointAdjustmentController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final int _limit = kItemsPerPage;
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var adjustments = <PointAdjustmentModel>[].obs;

  Future<void> loadPointAdjustments(int offset, {String? search}) async {
    final Map<String, dynamic> data = {
      "company_id": _auth.user.value.companyID,
      "database_name": _auth.user.value.databaseName,
      "limit": _limit,
      "offset": (offset - 1) * _limit,
      if (search != null) "search": search,
    };

    final response = await _api.get(endPoint: "get-all-point-adjustment", module: "PointAdjustmentController - loadPointAdjustments", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      final List<dynamic> list = response.data[PointAdjustmentModel.keyAdjustment] ?? [];

      adjustments.assignAll(list.map((e) => PointAdjustmentModel.fromJson(e)).toList());
      totalItems.value = response.data["total_count"];
    }
  }
}
