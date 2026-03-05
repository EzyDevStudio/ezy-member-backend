import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DevicePlatform { android, ios, web, unknown }

enum DeviceType { mobile, tablet, desktop }

class OldResponsiveHelper {
  static final OldResponsiveHelper _instance = OldResponsiveHelper._internal();
  factory OldResponsiveHelper() => _instance;
  OldResponsiveHelper._internal();

  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  late double aspectRatio;
  late double screenHeight, screenWidth;
  late DevicePlatform platform;
  late DeviceType deviceType;
  late Orientation orientation;

  void init(BuildContext context) {
    final mq = MediaQuery.of(context);

    screenHeight = mq.size.height;
    screenWidth = mq.size.width;
    aspectRatio = screenWidth / screenHeight;
    orientation = mq.orientation;

    _detectPlatform();
    _detectDeviceType();
  }

  void _detectPlatform() {
    if (kIsWeb) {
      platform = DevicePlatform.web;
    } else if (Platform.isAndroid) {
      platform = DevicePlatform.android;
    } else if (Platform.isIOS) {
      platform = DevicePlatform.ios;
    } else {
      platform = DevicePlatform.unknown;
    }
  }

  void _detectDeviceType() {
    double deviceWidth = 0.0;

    if (platform == DevicePlatform.android || platform == DevicePlatform.ios) {
      deviceWidth = orientation == Orientation.portrait ? screenWidth : screenHeight;

      if (deviceWidth < mobileBreakpoint) {
        deviceType = DeviceType.mobile;
      } else {
        deviceType = DeviceType.tablet;
      }
    } else {
      deviceWidth = screenWidth;

      if (deviceWidth < mobileBreakpoint) {
        deviceType = DeviceType.mobile;
      } else if (deviceWidth >= mobileBreakpoint && deviceWidth <= tabletBreakpoint) {
        deviceType = DeviceType.tablet;
      } else {
        deviceType = DeviceType.desktop;
      }
    }
  }

  bool isMobile() => deviceType == DeviceType.mobile;
  bool isTablet() => deviceType == DeviceType.tablet;
  bool isDesktop() => deviceType == DeviceType.desktop;

  double _textScale() => isDesktop() ? 1.2 : (isTablet() ? 1.1 : 1.0);
  double _sizeScale() => isDesktop() ? 2.0 : (isTablet() ? 1.5 : 1.0);
}

extension ResponsiveExtensions on num {
  double get sp => this * OldResponsiveHelper()._textScale();
  double get dp => this * OldResponsiveHelper()._sizeScale();
}
