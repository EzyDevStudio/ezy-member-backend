import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/company_model.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class CompanyController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  final ApiService _api = ApiService();

  var totalItems = 0.obs;
  var company = CompanyModel.empty().obs;

  Future<void> loadCompany() async {
    final responsePOS = await _api.get(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "get-company-information/${_auth.user.value.companyID}",
      module: "CompanyController - loadCompany",
    );

    if (responsePOS == null) return;

    if (responsePOS.data[ApiService.keyStatusCode] == 200) {
      final response = await _api.get(
        endPoint: "get-company",
        module: "CompanyController - loadCompany",
        data: {"company_id": _auth.user.value.companyID},
      );

      if (response == null) return;

      if (response.data[ApiService.keyStatusCode] == 200) {
        company.value = CompanyModel.fromJson(responsePOS.data["company_info"], response.data[CompanyModel.keyCompany]);
      }
    }
  }

  Future<bool> updateCompany(Map<String, dynamic> data, PlatformFile? file, String categories) async {
    data.addAll({"company_id": _auth.user.value.companyID, "database_name": _auth.user.value.databaseName});

    final response = await _api.post(endPoint: "update-company", module: "CompanyController - updateCompany", data: data, file: file);

    if (response == null) {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    } else if (response.data[ApiService.keyStatusCode] == 200) {
      final responsePOS = await _api.post(
        baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
        endPoint: "update-business-category",
        module: "CompanyController - updateCompany",
        data: {
          "customer_id": _auth.user.value.companyID,
          "business_category": categories,
          if (response.data["company_logo"] != null) "company_logo": response.data["company_logo"],
        },
      );

      if (responsePOS == null) {
        MessageHelper.showWarning(Globalization.msgSystemError.tr);
        return false;
      } else if (responsePOS.data[ApiService.keyStatusCode] == 200) {
        MessageHelper.showSuccess(Globalization.msgUpdateSuccess.trParams({"item": Globalization.company.tr}));

        return true;
      } else {
        MessageHelper.showWarning(Globalization.msgSystemError.tr);
        return false;
      }
    } else {
      MessageHelper.showWarning(Globalization.msgSystemError.tr);
      return false;
    }
  }
}
