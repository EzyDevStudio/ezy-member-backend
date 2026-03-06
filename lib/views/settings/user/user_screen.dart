import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/authentication_controller.dart';
import 'package:ezymember_backend/controllers/user_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/access_role_model.dart';
import 'package:ezymember_backend/models/user_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _authController = Get.put(AuthController(), tag: "user");
  final _userController = Get.put(UserController(), tag: "user");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  List<AccessRoleModel> _accessRoles = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _userController.loadUsers(_currentPage, search: search));

  Future<T> _withLoading<T>(Future<T> Function() action) async {
    LoadingOverlay.show(context);

    try {
      return await action();
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> _handleOperation(Future<bool> Function() operation) async {
    if (!await ConnectionService.checkConnection()) return;

    final success = await _withLoading(operation);

    if (success) _onRefresh();
  }

  void _create(Map<String, dynamic> data) {
    _handleOperation(() => _userController.createUser(data));
  }

  void _update(Map<String, dynamic> data) {
    _handleOperation(() => _userController.updateUser(data));
  }

  void _delete(UserModel user) {
    _handleOperation(() => _userController.deleteUser({"user_id": user.userID}));
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    _accessRoles = _userController.accessRoles;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16.0,
                children: <Widget>[
                  CustomSearchTextField(
                    controller: _searchController,
                    onPressedClear: () {
                      _searchController.clear();
                      _onRefresh();
                    },
                    onPressedSearch: () => _onRefresh(search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim()),
                  ),
                  CustomNewItemButton(onTap: () => _showItemDialog()),
                ],
              ),
            ),
            CustomDataTable<UserModel>(
              ratios: UserModel.ratios,
              headers: UserModel.headers,
              models: List.from(_userController.users),
              variables: UserModel.variables,
              actions: (UserModel user) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.update.tr,
                  onTap: () => _showItemDialog(user: user),
                  child: Icon(Icons.edit_rounded, color: Colors.green),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.delete.tr,
                  onTap: () => _showDeleteDialog(user),
                  child: Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _userController.totalItems.value,
              onPageChanged: (page) => setState(() {
                _currentPage = page;
                _onRefresh();
              }),
            ),
          ],
        ),
      ),
    );
  });

  void _showItemDialog({UserModel? user}) {
    bool isAdmin = user != null && (user.userType == 2 || user.userType == 1);
    List<AccessRoleModel> accessRoles = isAdmin ? _accessRoles : _accessRoles.where((a) => a.accessRight != -1 && a.accessRight != -2).toList();
    TextEditingController nameController = TextEditingController(text: user?.name);
    TextEditingController emailController = TextEditingController(text: user?.email);
    TextEditingController passwordController = TextEditingController();
    TextEditingController contactController = TextEditingController(text: user?.contactNumber);

    AccessRoleModel selectionAction = user == null ? accessRoles.first : accessRoles.firstWhere((a) => a.accessRight == user.accessRight);

    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setStateModal) => CustomItemModal(
          isCreate: user == null,
          title: user == null ? Globalization.newUser.tr : Globalization.update.tr,
          onTap: () {
            String name = nameController.text.trim();
            String email = emailController.text.trim();
            String password = passwordController.text.trim();
            String contact = contactController.text.trim();

            if (name.isNotEmpty && email.isNotEmpty && (user != null || password.isNotEmpty)) {
              if (!RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$").hasMatch(email)) {
                MessageHelper.warning(Globalization.msgInvalidEmailFormat.tr);
                return;
              }

              Map<String, dynamic> data = {
                if (user != null) "user_id": user.userID,
                "name": name,
                "email": email,
                "password": password,
                "contact_number": contact,
                "access_right": selectionAction.accessRight,
              };

              user == null ? _create(data) : _update(data);
            } else {
              MessageHelper.warning(Globalization.msgFieldEmpty.tr);
            }
          },
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: <Widget>[
                CustomTextField(
                  controller: nameController,
                  enabled: !(user != null && user.userType == 1),
                  isRequired: true,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s]")), LengthLimitingTextInputFormatter(100)],
                  label: Globalization.name.tr,
                ),
                CustomTextField(
                  controller: emailController,
                  enabled: !(user != null && user.userType == 1),
                  isRequired: true,
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  label: Globalization.email.tr,
                ),
                CustomTextField(
                  controller: passwordController,
                  enabled: !(user != null && user.userType != 0 && _authController.user.value.userType == 0),
                  isRequired: user == null,
                  label: Globalization.password.tr,
                  type: TextFieldType.password,
                ),
                if (user != null) CustomText(Globalization.msgChangeUserPassword.tr, fontSize: 12.0),
                CustomTextField(controller: contactController, label: Globalization.contactNumber.tr),
                CustomDropdown<AccessRoleModel>(
                  enabled: (user != null && (user.userType == 2 || user.userType == 1)) ? false : true,
                  items: accessRoles,
                  label: Globalization.accessRole.tr,
                  dropdownEntries: (role) => role.accessTitle,
                  initialSelection: selectionAction,
                  onSelected: (role) => selectionAction = role!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(UserModel user) {
    if (user.userType == 2 || user.userType == 1) {
      MessageHelper.info(Globalization.msgDeleteAdminError.tr);
      return;
    }

    Get.dialog(CustomConfirmationDialog(content: Globalization.msgConfirmationDelete.tr, onConfirm: () => _delete(user)));
  }
}
