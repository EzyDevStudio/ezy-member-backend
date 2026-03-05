import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:get/get.dart';

class MessageHelper {
  static void _show(DialogType type, String message) => Get.dialog(CustomDialog(type: type, content: message));

  static void showDisconnected() => _show(DialogType.disconnected, Globalization.msgDisconnected.tr);
  static void showSuccess(String message) => _show(DialogType.success, message);
  static void showWarning(String message) => _show(DialogType.warning, message);
}
