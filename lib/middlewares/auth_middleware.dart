import 'package:ezymember_backend/constants/app_routes.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    return authController.isSignIn.value ? null : const RouteSettings(name: AppRoutes.authentication);
  }
}
