import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/point_history_controller.dart';
import 'package:ezymember_backend/models/point_history_model.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointHistoryScreen extends StatefulWidget {
  const PointHistoryScreen({super.key});

  @override
  State<PointHistoryScreen> createState() => _PointHistoryScreenState();
}

class _PointHistoryScreenState extends State<PointHistoryScreen> {
  final _historyController = Get.put(PointHistoryController(), tag: "point_history");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _historyController.loadHistories(_currentPage, search: search));

  Future<T> _withLoading<T>(Future<T> Function() action) async {
    LoadingOverlay.show(context);

    try {
      return await action();
    } finally {
      LoadingOverlay.hide();
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
            CustomDataTable<PointHistoryModel>(
              ratios: PointHistoryModel.ratios,
              headers: PointHistoryModel.headers,
              models: List.from(_historyController.histories),
              variables: PointHistoryModel.variables,
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _historyController.totalItems.value,
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
}
