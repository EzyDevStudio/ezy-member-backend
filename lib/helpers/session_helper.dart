import 'dart:async';

import 'package:ezymember_backend/constants/app_colors.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionHelper {
  static final SessionHelper _instance = SessionHelper._internal();
  factory SessionHelper() => _instance;
  SessionHelper._internal();

  final _authController = Get.find<AuthController>();
  final Duration _timeoutApp = Duration(minutes: 15);
  final Duration _timeoutDialog = Duration(minutes: 15);

  bool _showDialog = false;
  Timer? _timerApp, _timerDialog;

  void startTimer() {
    if (!_authController.isSignIn.value || _showDialog) return;

    _timerApp?.cancel();
    _timerApp = Timer(_timeoutApp, _onTimeout);
  }

  void resetTimer() {
    if (!_authController.isSignIn.value || _showDialog) return;

    startTimer();
  }

  void _onTimeout() async {
    if (!_authController.isSignIn.value) return;

    _showDialog = true;
    _timerDialog?.cancel();
    _timerDialog = Timer(_timeoutDialog, _signOut);

    final result = await Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        backgroundColor: AppColors.defaultWhite,
        surfaceTintColor: AppColors.defaultWhite,
        actions: <Widget>[
          Row(
            spacing: 16.0,
            children: <Widget>[
              Expanded(
                child: CustomFilledButton(
                  backgroundColor: AppColors.defaultRed,
                  label: Globalization.no.tr,
                  onTap: () => Get.isDialogOpen == true ? Get.back() : null,
                ),
              ),
              Expanded(
                child: CustomFilledButton(label: Globalization.yes.tr, onTap: () => Get.back(result: true)),
              ),
            ],
          ),
        ],
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: <Widget>[
            CustomCountdownText(seconds: _timeoutDialog.inSeconds),
            CustomText(Globalization.msgInactivity.tr, fontSize: 16.0, maxLines: null, textAlign: TextAlign.center),
          ],
        ),
        title: Column(
          spacing: 8.0,
          children: <Widget>[
            Image.asset("assets/icons/confirmation.png", height: 30.0),
            CustomText(Globalization.msgConfirmation.tr, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    _showDialog = false;
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
