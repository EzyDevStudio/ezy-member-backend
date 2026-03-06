import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final ApiService _api = ApiService();

  var cmMember = 0.obs;
  var cmCreditHistory = 0.obs;
  var cmPointHistory = 0.obs;
  var totalMember = 0.obs;
  var totalExpiredMember = 0.obs;
  var monthlyMember = <Map<String, dynamic>>[].obs;
  var monthlyCredit = <Map<String, dynamic>>[].obs;
  var monthlyPoint = <Map<String, dynamic>>[].obs;
  var monthlyTransaction = <Map<String, dynamic>>[].obs;

  Future<void> loadDashboardData() async {
    final Map<String, dynamic> data = {"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName};

    final response = await _api.get(endPoint: "get-dashboard-data", module: "DashboardController - loadDashboardData", data: data);

    if (response == null) return;

    if (response.data[ApiService.keyStatusCode] == 200) {
      cmMember.value = response.data["current_month_member"];
      cmCreditHistory.value = response.data["current_month_credit_history"];
      cmPointHistory.value = response.data["current_month_point_history"];
      totalMember.value = response.data["total_member"];
      totalExpiredMember.value = response.data["total_expired_member"];
      monthlyMember.value = List<Map<String, dynamic>>.from(response.data["monthly_member"] ?? []);
      monthlyCredit.value = List<Map<String, dynamic>>.from(response.data["monthly_credit"] ?? []);
      monthlyPoint.value = List<Map<String, dynamic>>.from(response.data["monthly_point"] ?? []);
      monthlyTransaction.value = List<Map<String, dynamic>>.from(response.data["monthly_transaction"] ?? []);
    }
  }
}
