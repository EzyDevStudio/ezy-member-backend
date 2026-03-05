import 'dart:async';

import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:get/get.dart';

class SessionHelper {
  static final SessionHelper _instance = SessionHelper._internal();
  factory SessionHelper() => _instance;
  SessionHelper._internal();

  final _authController = Get.find<AuthController>();

  static const Duration timeout = Duration(seconds: 30);

  Timer? _timerApp, _timerDialog;

  void startTimer() {
    if (!_authController.isSignIn.value) return;

    _timerApp?.cancel();
    _timerApp = Timer(timeout, _onTimeout);
  }

  void resetTimer() {
    if (!_authController.isSignIn.value) return;

    startTimer();
  }

  void _onTimeout() async {
    if (!_authController.isSignIn.value) return;

    _timerDialog?.cancel();
    _timerDialog = Timer(timeout, _signOut);

    final result = await Get.dialog(
      CustomDialog(type: DialogType.confirmation, content: Globalization.msgInactivity.tr, onConfirm: () => Get.back(result: true)),
    );

    _timerDialog?.cancel();

    if (result != null && result) {
      resetTimer();
    } else {
      _signOut();
    }
  }

  void _signOut() {
    _authController.signOut();
  }

  void dispose() {
    _timerApp?.cancel();
  }
}
