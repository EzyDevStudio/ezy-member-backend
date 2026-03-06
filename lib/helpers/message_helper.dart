import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_toast.dart';
import 'package:get/get.dart';

class MessageHelper {
  static void _show(String message, ToastType type) => CustomToast.show(message: message, type: type);

  static void disconnected() => _show(Globalization.msgDisconnected.tr, ToastType.disconnected);
  static void error(String message) => _show(message, ToastType.error);
  static void info(String message) => _show(message, ToastType.information);
  static void success(String message) => _show(message, ToastType.success);
  static void warning(String message) => _show(message, ToastType.warning);
}
