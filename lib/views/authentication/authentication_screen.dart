import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _authController = Get.find<AuthController>();
  final _companyIDController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _withLoading(Future<void> Function() action) async {
    LoadingOverlay.show(context);
    await action();
    LoadingOverlay.hide();
  }

  void _login() async {
    if (!await ConnectionService.checkConnection()) return;

    String companyID = _companyIDController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (companyID.isEmpty || email.isEmpty || password.isEmpty) {
      MessageHelper.showWarning(Globalization.msgFieldEmpty.tr);
      return;
    }

    Map<String, dynamic> data = {"company_id": companyID, "email": email, "password": password};

    await _withLoading(() async => await _authController.login(data));
  }

  @override
  void dispose() {
    _companyIDController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: context.isMobile
        ? ListView(children: <Widget>[_buildImage(), _buildForm()])
        : Row(
            children: <Widget>[
              Expanded(flex: 6, child: _buildImage()),
              Expanded(flex: context.isDesktop ? 4 : 6, child: _buildForm()),
            ],
          ),
  );

  Widget _buildImage() => Padding(padding: EdgeInsets.symmetric(horizontal: 24.0), child: Image.asset("assets/images/welcome.png"));

  Widget _buildForm() => Container(
    color: context.isMobile ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
    padding: EdgeInsets.fromLTRB(36.0, context.isMobile ? 0.0 : 24.0, 36.0, 24.0),
    child: context.isMobile
        ? _buildFormContent()
        : LayoutBuilder(
            builder: (context, constraints) => ListView(
              children: <Widget>[
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400.0, minHeight: constraints.maxHeight),
                    child: _buildFormContent(),
                  ),
                ),
              ],
            ),
          ),
  );

  Widget _buildFormContent() => Column(
    crossAxisAlignment: context.isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: 12.0,
    children: <Widget>[
      Image.asset(context.isMobile ? "assets/images/logo.png" : "assets/images/logo_w.png", height: 70.0),
      const SizedBox(),
      if (!context.isMobile) ...[
        CustomText(Globalization.msgLoginLabel.toUpperCase(), color: Colors.white, fontSize: 18.0),
        CustomText(Globalization.loginHere, color: Colors.white, fontSize: 14.0),
        const SizedBox(),
      ],
      CustomTextField(controller: _companyIDController, showTitle: false, icon: Icons.work_rounded, label: Globalization.customerID),
      CustomTextField(controller: _emailController, showTitle: false, icon: Icons.email_rounded, label: Globalization.email),
      CustomTextField(
        controller: _passwordController,
        showTitle: false,
        icon: Icons.key_rounded,
        label: Globalization.password,
        type: TextFieldType.password,
      ),
      const SizedBox(),
      CustomFilledButton(
        backgroundColor: context.isMobile ? null : Theme.of(context).colorScheme.tertiary,
        label: Globalization.login,
        onTap: _login,
      ),
    ],
  );
}
