import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';

enum ToastType { disconnected, error, information, success, warning }

class CustomToast {
  static ToastificationItem show({required String message, required ToastType type}) => toastification.show(
    alignment: Alignment.topRight,
    closeOnClick: true,
    dragToClose: true,
    pauseOnHover: true,
    borderRadius: BorderRadius.circular(8.0),
    backgroundColor: _getBackgroundColor(type),
    foregroundColor: _getPrimaryColor(type),
    primaryColor: _getPrimaryColor(type),
    dismissDirection: DismissDirection.none,
    autoCloseDuration: _getDuration(type),
    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
    style: ToastificationStyle.minimal,
    type: _getToastType(type),
    description: CustomText(message, fontSize: 13.0),
    icon: Icon(_getIcon(type), color: _getPrimaryColor(type), size: 24.0),
    title: CustomText(_getTitle(type), fontSize: 14.0, fontWeight: FontWeight.w600),
  );

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return const Color(0xFFFEEBEB);
      case ToastType.error:
        return const Color(0xFFFEEBEB);
      case ToastType.information:
        return const Color(0xFFEFF6FF);
      case ToastType.success:
        return const Color(0xFFE4F8F0);
      case ToastType.warning:
        return const Color(0xFFFFFBEB);
    }
  }

  static Color _getPrimaryColor(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return const Color(0xFFFFB600);
      case ToastType.error:
        return const Color(0xFFD32F2F);
      case ToastType.information:
        return const Color(0xFF3B82F6);
      case ToastType.success:
        return const Color(0xFF1EA97C);
      case ToastType.warning:
        return const Color(0xFFF59E0B);
    }
  }

  static Duration? _getDuration(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return null;
      case ToastType.error:
        return null;
      case ToastType.information:
        return const Duration(seconds: 4);
      case ToastType.success:
        return const Duration(seconds: 4);
      case ToastType.warning:
        return null;
    }
  }

  static IconData _getIcon(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return Icons.wifi_off_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.information:
        return Icons.info_rounded;
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
    }
  }

  static String _getTitle(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return Globalization.disconnected.tr;
      case ToastType.error:
        return Globalization.error.tr;
      case ToastType.information:
        return Globalization.information.tr;
      case ToastType.success:
        return Globalization.success.tr;
      case ToastType.warning:
        return Globalization.warning.tr;
    }
  }

  static ToastificationType _getToastType(ToastType type) {
    switch (type) {
      case ToastType.disconnected:
        return ToastificationType.custom('disconnected', Color(0xFFFFB600), Icons.wifi_off_rounded);
      case ToastType.error:
        return ToastificationType.error; // Red
      case ToastType.information:
        return ToastificationType.info; // Blue
      case ToastType.success:
        return ToastificationType.success; // Green
      case ToastType.warning:
        return ToastificationType.warning; // Yellow
    }
  }
}
