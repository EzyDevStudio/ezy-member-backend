import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/branch_controller.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/branch_model.dart';
import 'package:ezymember_backend/models/postcode_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/views/settings/branch/branch_item_widget.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen({super.key});

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final _branchController = Get.put(BranchController(), tag: "branch");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  List<PostcodeModel> _postcodes = [];

  @override
  void initState() {
    super.initState();

    _loadPostcodes();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  Future<void> _loadPostcodes() async {
    final list = await PostcodeModel.load();

    setState(() => _postcodes = list);
  }

  void _onRefresh({String? search}) => _withLoading(() => _branchController.loadBranches(_currentPage, search: search));

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

  void _delete(BranchModel branch) {
    _handleOperation(() => _branchController.deleteBranch(branch.branchCode));
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
            CustomDataTable<BranchModel>(
              ratios: BranchModel.ratios,
              headers: BranchModel.headers,
              models: List.from(_branchController.branches),
              variables: BranchModel.variables,
              actions: (BranchModel branch) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.update.tr,
                  onTap: () => _showItemDialog(branch: branch),
                  child: Icon(Icons.edit_rounded, color: Colors.green),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.delete.tr,
                  onTap: () => _showDeleteDialog(branch),
                  child: Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _branchController.totalItems.value,
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

  void _showItemDialog({BranchModel? branch}) async {
    final request = await Get.dialog(
      BranchItemWidget(branch: branch, postcodes: _postcodes, title: branch == null ? Globalization.newBranch.tr : Globalization.update.tr),
    );

    if (request != null && request) _onRefresh();
  }

  void _showDeleteDialog(BranchModel branch) =>
      Get.dialog(CustomConfirmationDialog(content: Globalization.msgConfirmationDelete.tr, onConfirm: () => _delete(branch)));
}
