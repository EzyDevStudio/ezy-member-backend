import 'package:ezymember_backend/constants/app_routes.dart';
import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/user_model.dart';
import 'package:ezymember_backend/services/local/user_storage_service.dart';
import 'package:ezymember_backend/services/remote/api_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final ApiService _api = ApiService();
  final UserStorageService _storage = UserStorageService();

  var isSignIn = false.obs;
  var user = UserModel.empty().obs;

  @override
  void onInit() {
    isSignIn.value = _storage.isSignIn;
    user.value = _storage.isSignIn ? _storage.user : UserModel.empty();

    super.onInit();
  }

  void signIn(UserModel tmpUser, DateTime expiryDate) {
    _storage.saveUser(user: tmpUser);
    isSignIn.value = true;
    user.value = tmpUser;

    Get.offAllNamed(AppRoutes.dashboard);

    if (expiryDate.isBefore(DateTime.now())) MessageHelper.info(Globalization.msgCustomerExpired.tr);
  }

  void signOut() {
    _storage.clear();
    isSignIn.value = false;
    user.value = UserModel.empty();

    Get.offAllNamed(AppRoutes.authentication);
  }

  Future<void> login(Map<String, dynamic> data) async {
    String companyID = data["company_id"];

    final responsePOS = await _api.post(
      baseUrl: "${AppStrings.serverEzyPos}/${AppStrings.serverDirectory}",
      endPoint: "check-member-subscription",
      module: "AuthController - login",
      data: {"customer_id": companyID},
    );

    if (responsePOS == null) {
      MessageHelper.error(Globalization.msgSystemError.tr);
    } else if (responsePOS.data[ApiService.keyStatusCode] == 200) {
      String value = (responsePOS.data["expired_date"] ?? "0");
      DateTime expiryDate = value.strToDT;
      String databaseName = responsePOS.data["database_name"];

      data.addAll({"database_name": databaseName});

      final response = await _api.post(endPoint: "login", module: "AuthController - login", data: data);

      if (response == null) {
        MessageHelper.error(Globalization.msgSystemError.tr);
      } else if (response.data[ApiService.keyStatusCode] == 200) {
        user.value = UserModel.login(response.data[UserModel.keyUser], companyID, databaseName);
        signIn(user.value, expiryDate);
      } else {
        MessageHelper.warning(Globalization.msgLoginFailed.tr);
      }
    } else if (responsePOS.data[ApiService.keyStatusCode] == 400) {
      MessageHelper.warning(Globalization.msgLoginFailed.tr);
    } else if (responsePOS.data[ApiService.keyStatusCode] == 401) {
      MessageHelper.warning(Globalization.msgCustomerInactive.tr);
    }
  }
}
