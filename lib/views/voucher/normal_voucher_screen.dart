import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/voucher_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/voucher_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/views/voucher/voucher_item_widget.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NormalVoucherScreen extends StatefulWidget {
  const NormalVoucherScreen({super.key});

  @override
  State<NormalVoucherScreen> createState() => _NormalVoucherScreenState();
}

class _NormalVoucherScreenState extends State<NormalVoucherScreen> {
  final _voucherController = Get.put(VoucherController(), tag: "normal_voucher");
  final TextEditingController _searchController = TextEditingController();
  final int _voucherType = 0;

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _voucherController.loadVouchers(_currentPage, type: _voucherType, search: search));

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

  void _delete(VoucherModel voucher) {
    _handleOperation(() => _voucherController.deleteVoucher({"batch_code": voucher.batchCode, "voucher_type": _voucherType}));
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
            CustomDataTable<VoucherModel>(
              ratios: VoucherModel.normalRatios,
              headers: VoucherModel.normalHeaders,
              models: List.from(_voucherController.vouchers),
              variables: VoucherModel.normalVariables,
              actions: (VoucherModel voucher) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.update.tr,
                  onTap: () => _showItemDialog(voucher: voucher),
                  child: Icon(Icons.edit_rounded, color: Colors.green),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.delete.tr,
                  onTap: () => _showDeleteDialog(voucher),
                  child: Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _voucherController.totalItems.value,
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

  void _showItemDialog({VoucherModel? voucher}) async {
    final request = await Get.dialog(
      VoucherItemWidget(voucher: voucher, voucherType: _voucherType, title: voucher == null ? Globalization.newVoucher.tr : Globalization.update.tr),
    );

    if (request != null && request) _onRefresh();
  }

  void _showDeleteDialog(VoucherModel voucher) {
    if (voucher.startCollectDate.isExpiredToday) {
      MessageHelper.showWarning(Globalization.msgVoucherReleased.tr);
      return;
    }

    Get.dialog(CustomDialog(type: DialogType.confirmation, content: Globalization.msgConfirmationDelete.tr, onConfirm: () => _delete(voucher)));
  }
}
