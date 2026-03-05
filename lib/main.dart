import 'package:ezymember_backend/constants/app_routes.dart';
import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/constants/app_themes.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/session_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/language/intl_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Pending: Batch update or batch action for member card tier (when meet certain condition)
// Pending: Hive cache or cookies
// Pending: Create laravel php indexing
// Pending: Create AppConstants and setup and responsive condition

// Get company's member list ->when(name, email, contact number, member code)
// Get member's information ->display(name, email, contact number, member code, credit, point)
// Create member ->create(name, email, contact number)
// Forgot password if no the no send to email
// Company domain name and database name
// form maxWidth 1200
// change password
// scrollable tableview
// tableview action minWidth
// domain pass pasword userid companyid

// Dashboard card change, Dashboard card shadow (member total, this month, expired, active)
// Dashboard remove card summary
// line chart 3-12 months and year filter
// change color
// rotate title bottom
// change transaction graph to listview
// branch point transaction group by "doc_amount"
// tableview use listview

// search field design copy and button small then change color for add item

// full screen dialog add padding

// voucher able to status

// dialog to toast message

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FocusNode _focusNode = FocusNode();
  final SessionHelper _sessionHelper = SessionHelper();

  @override
  void dispose() {
    _focusNode.dispose();
    _sessionHelper.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    builder: (context, child) => KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (_) => _sessionHelper.resetTimer(),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _sessionHelper.resetTimer(),
        onPointerMove: (_) => _sessionHelper.resetTimer(),
        onPointerSignal: (_) => _sessionHelper.resetTimer(),
        child: child!,
      ),
    ),
    debugShowCheckedModeBanner: false,
    title: AppStrings.appName,
    theme: AppThemes().lightTheme,
    getPages: AppRoutes.pages,
    initialRoute: AppRoutes.authentication,
    locale: Get.locale,
    fallbackLocale: Globalization.defaultLocale,
    translations: IntlKeys(),
    supportedLocales: Globalization.languages.values.toList(),
    localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
  );
}
