import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/member_card_controller.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/member_card_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/views/settings/member_card/card_item_widget.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberCardScreen extends StatefulWidget {
  const MemberCardScreen({super.key});

  @override
  State<MemberCardScreen> createState() => _MemberCardScreenState();
}

class _MemberCardScreenState extends State<MemberCardScreen> {
  final _cardController = Get.put(MemberCardController(), tag: "member_card");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _cardController.loadMemberCards(_currentPage, search: search));

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

  void _delete(MemberCardModel card) {
    _handleOperation(() => _cardController.deleteMemberCard({"card_code": card.cardCode}));
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
            CustomDataTable<MemberCardModel>(
              ratios: MemberCardModel.ratios,
              headers: MemberCardModel.headers,
              models: List.from(_cardController.memberCards),
              variables: MemberCardModel.variables,
              actions: (MemberCardModel card) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.update.tr,
                  onTap: () => _showItemDialog(card: card),
                  child: Icon(Icons.edit_rounded, color: Colors.green),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.delete.tr,
                  onTap: () => _showDeleteDialog(card),
                  child: Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _cardController.totalItems.value,
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

  void _showItemDialog({MemberCardModel? card}) async {
    final request = await Get.dialog(CardItemWidget(card: card, title: card == null ? Globalization.newMemberCard.tr : Globalization.update.tr));

    if (request != null && request) _onRefresh();
  }

  void _showDeleteDialog(MemberCardModel card) {
    if (card.isDefault == 1) {
      MessageHelper.info(Globalization.msgDeleteDefaultCard.tr);
      return;
    }

    Get.dialog(CustomConfirmationDialog(content: Globalization.msgConfirmationDelete.tr, onConfirm: () => _delete(card)));
  }
}
