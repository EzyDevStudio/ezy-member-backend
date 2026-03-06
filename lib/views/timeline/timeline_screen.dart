import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/controllers/timeline_controller.dart';
import 'package:ezymember_backend/helpers/media_helper.dart';
import 'package:ezymember_backend/helpers/message_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/timeline_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_data_table.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_pagination.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _timelineController = Get.put(TimelineController(), tag: "timeline");
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  int _timelineCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh({String? search}) => _withLoading(() => _timelineController.loadTimelines(_currentPage, search: search));

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

  void _create(PlatformFile file, String caption) {
    _handleOperation(() => _timelineController.createTimeline({"timeline_caption": caption}, file));
  }

  void _delete(TimelineModel timeline) {
    _handleOperation(() => _timelineController.deleteTimeline({"timeline_id": timeline.timelineID}));
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    _timelineCount = _timelineController.timelines.length;

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
                  CustomNewItemButton(onTap: () => _showCreateDialog()),
                ],
              ),
            ),
            CustomDataTable<TimelineModel>(
              ratios: TimelineModel.ratios,
              headers: TimelineModel.headers,
              models: List.from(_timelineController.timelines),
              variables: TimelineModel.variables,
              actions: (TimelineModel timeline) => <CustomOutlinedButton>[
                CustomOutlinedButton(
                  tooltip: Globalization.viewDetails.tr,
                  onTap: () => _showDetailDialog(timeline, Globalization.viewDetails.tr),
                  child: Icon(Icons.visibility_rounded, color: Colors.blue),
                ),
                CustomOutlinedButton(
                  tooltip: Globalization.delete.tr,
                  onTap: () => _showDeleteDialog(timeline),
                  child: Icon(Icons.delete_rounded, color: Colors.red),
                ),
              ],
            ),
            CustomPagination(
              itemsPerPage: kItemsPerPage,
              totalItems: _timelineController.totalItems.value,
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

  void _showCreateDialog() {
    if (_timelineCount >= 10) {
      MessageHelper.info(Globalization.msgMaxTimeline.tr);
      return;
    }

    PlatformFile? image;
    TextEditingController captionController = TextEditingController();

    Get.dialog(
      barrierDismissible: false,
      StatefulBuilder(
        builder: (context, setStateModal) => CustomItemModal(
          title: Globalization.newTimeline.tr,
          onTap: () {
            if (image != null && captionController.text.trim().isNotEmpty) {
              _create(image!, captionController.text.trim());
            } else if (image == null) {
              MessageHelper.warning(Globalization.msgImageEmpty.tr);
            } else if (captionController.text.trim().isEmpty) {
              MessageHelper.warning(Globalization.msgFieldEmpty.tr);
            }
          },
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: <Widget>[
                SizedBox(
                  height: 200.0,
                  child: CustomDottedContainer(
                    onTap: () async {
                      final pickedImg = await MediaHelper.processImage();

                      if (pickedImg != null) setStateModal(() => image = pickedImg);
                    },
                    child: image != null
                        ? Image.memory(image!.bytes!, fit: BoxFit.contain)
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 16.0,
                              children: <Widget>[
                                Icon(Icons.add_rounded, color: Colors.black87, size: 50.0),
                                CustomText(Globalization.chooseImage.tr, fontSize: 18.0),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(),
                CustomTextField(controller: captionController, maxLength: 2000, maxLines: 5, label: Globalization.caption.tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(TimelineModel timeline, String title) => Get.dialog(
    CustomDetailModal(
      title: title,
      content: Column(
        spacing: 16.0,
        children: <Widget>[
          Image.network(timeline.timelineImage, scale: kSquareRatio, width: 300.0),
          CustomText(timeline.timelineCaption, fontSize: 14.0, maxLines: null),
        ],
      ),
    ),
  );

  void _showDeleteDialog(TimelineModel timeline) =>
      Get.dialog(CustomConfirmationDialog(content: Globalization.msgConfirmationDelete.tr, onConfirm: () => _delete(timeline)));
}
