import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/access_role_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/access_role_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessRoleScreen extends StatefulWidget {
  const AccessRoleScreen({super.key});

  @override
  State<AccessRoleScreen> createState() => _AccessRoleScreenState();
}

class _AccessRoleScreenState extends State<AccessRoleScreen> {
  final _accessController = Get.put(AccessRoleController(), tag: "access_role");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _accessController.loadAccessRoles(_currentPage, search: search));

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

  void _create(String title) {
    _handleOperation(() => _accessController.createAccessRole({"access_title": title}));
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
    () => Scaffold(
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
            CustomDataTable<AccessRoleModel>(
              ratios: AccessRoleModel.ratios,
              headers: AccessRoleModel.headers,
              models: List.from(_accessController.accessRoles),
              variables: AccessRoleModel.variables,
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _accessController.totalItems.value,
              onPageChanged: (page) => setState(() {
                _currentPage = page;
                _onRefresh();
              }),
            ),
          ],
        ),
      ),
    ),
  );

  void _showItemDialog() {
    TextEditingController titleController = TextEditingController();

    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setStateModal) => CustomItemModal(
          title: Globalization.newAccessRole.tr,
          onTap: () {
            if (titleController.text.trim().isNotEmpty) {
              _create(titleController.text.trim());
            } else {
              MessageHelper.warning(Globalization.msgFieldEmpty.tr);
            }
          },
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: <Widget>[CustomTextField(controller: titleController, maxLength: 100, label: Globalization.accessRole.tr)],
            ),
          ),
        ),
      ),
    );
  }
}
