import 'package:flutter/cupertino.dart';

class ResponsiveHelper {
  static const double mobileSmall = 320.0; // Mobile (Portrait): 320px – 480px
  static const double mobileLarge = 480.0; // Mobile (Landscape): 481px – 600px
  static const double tabletSmall = 600.0; // Tablets (Portrait): 601px – 768px
  static const double tabletLarge = 768.0; // Tablets (Landscape): 769px – 1024px
  static const double desktop = 1024.0; // Desktops: 1025px – 1280px

  static double _width(BuildContext context) => MediaQuery.sizeOf(context).width;

  bool _isMobile(BuildContext context) => _width(context) < tabletSmall;
  bool _isTablet(BuildContext context) => _width(context) >= tabletSmall && _width(context) < desktop;
  bool _isDesktop(BuildContext context) => _width(context) >= desktop;

  bool _isSmallMobile(BuildContext context) => _width(context) < mobileLarge;
  bool _isLargeMobile(BuildContext context) => _width(context) >= mobileLarge && _width(context) < tabletSmall;
  bool _isSmallTablet(BuildContext context) => _width(context) >= tabletSmall && _width(context) < tabletLarge;
  bool _isLargeTablet(BuildContext context) => _width(context) >= tabletLarge && _width(context) < desktop;

  int _countDashboard(BuildContext context) {
    if (_isDesktop(context)) return 4;
    if (_isLargeTablet(context)) return 3;
    if (_isSmallTablet(context)) return 2;
    if (_isLargeMobile(context)) return 2;

    return 1;
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveHelper()._isMobile(this);
  bool get isTablet => ResponsiveHelper()._isTablet(this);
  bool get isDesktop => ResponsiveHelper()._isDesktop(this);

  bool get isSmallMobile => ResponsiveHelper()._isSmallMobile(this);
  bool get isLargeMobile => ResponsiveHelper()._isLargeMobile(this);
  bool get isSmallTablet => ResponsiveHelper()._isSmallTablet(this);
  bool get isLargeTablet => ResponsiveHelper()._isLargeTablet(this);

  int get countDashboard => ResponsiveHelper()._countDashboard(this);
}
