import 'package:ezymember_backend/constants/app_strings.dart';
import 'package:ezymember_backend/controllers/company_controller.dart';
import 'package:ezymember_backend/helpers/formatter_helper.dart';
import 'package:ezymember_backend/helpers/media_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/category_model.dart';
import 'package:ezymember_backend/models/company_model.dart';
import 'package:ezymember_backend/services/local/connection_service.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_container.dart';
import 'package:ezymember_backend/widgets/custom_loading.dart';
import 'package:ezymember_backend/widgets/custom_modal.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:ezymember_backend/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final _companyController = Get.put(CompanyController(), tag: "about_us");
  final List<CategoryModel> _categories = AppStrings.categories;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  PlatformFile? _image;
  Set<CategoryModel> _selectedCategories = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onRefresh());
  }

  void _onRefresh() => _withLoading(() async {
    await _companyController.loadCompany();

    final company = _companyController.company.value;

    _descriptionController.text = company.companyDescription;
    _visionController.text = company.companyVision;
    _missionController.text = company.companyMission;
    _valueController.text = company.companyValue;

    if (company.categories.isNotEmpty) {
      List<String> categories = company.categories.split(", ").map((c) => c.trim()).toList();

      setState(() => _selectedCategories = _categories.where((cat) => categories.contains(cat.name.split(" ").first)).toSet());
    }
  });

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

  void _update() {
    String categories = _selectedCategories.map((cat) => cat.name.split(" ").first).join(", ");

    _handleOperation(
      () => _companyController.updateCompany(
        {
          "company_description": _descriptionController.text.trim(),
          "company_vision": _visionController.text.trim(),
          "company_mission": _missionController.text.trim(),
          "company_value": _valueController.text.trim(),
        },
        _image,
        categories,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _visionController.dispose();
    _missionController.dispose();
    _valueController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
    CompanyModel company = _companyController.company.value;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: EdgeInsets.all(24.0),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24.0,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: <Widget>[
                    CustomText(
                      Globalization.companyLogo.tr,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomImageContainer(
                      size: 120.0,
                      file: _image,
                      image: company.companyLogo,
                      onDelete: () => setState(() => _image = null),
                      onSelect: () async {
                        final pickedImg = await MediaHelper.processImage();

                        if (pickedImg != null) setState(() => _image = pickedImg);
                      },
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.companyID),
                      enabled: false,
                      label: Globalization.companyID.tr,
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.companyName),
                      enabled: false,
                      label: Globalization.companyName.tr,
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.expiredDate.tsToStrDateTime),
                      enabled: false,
                      label: Globalization.expiresOn.tr,
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.contactNumber),
                      enabled: false,
                      label: Globalization.contactNumber.tr,
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.email),
                      enabled: false,
                      label: Globalization.email.tr,
                    ),
                    const SizedBox(),
                    CustomTextField(
                      controller: TextEditingController(text: company.fullAddress),
                      enabled: false,
                      maxLines: 5,
                      label: Globalization.address.tr,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: <Widget>[
                    CustomTextField(controller: _descriptionController, maxLines: 5, label: Globalization.companyDescription.tr),
                    const SizedBox(),
                    CustomTextField(controller: _visionController, maxLines: 5, label: Globalization.companyVision.tr),
                    const SizedBox(),
                    CustomTextField(controller: _missionController, maxLines: 5, label: Globalization.companyMission.tr),
                    const SizedBox(),
                    CustomTextField(controller: _valueController, maxLines: 5, label: Globalization.companyValue.tr),
                    const SizedBox(),
                    CustomText(Globalization.category.tr, color: Theme.of(context).colorScheme.primary, fontSize: 13.0, fontWeight: FontWeight.bold),
                    CustomFilledButton(
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      label: Globalization.selectCategory.tr,
                      onTap: () => _showCategorySelection(),
                    ),
                    const SizedBox(),
                    if (_selectedCategories.isNotEmpty) ...[
                      CustomText(
                        _selectedCategories.toList().asMap().entries.map((entry) => "${entry.key + 1}. ${entry.value.name}").join('\n'),
                        fontSize: 14.0,
                        maxLines: null,
                      ),
                      const SizedBox(),
                    ],
                    CustomFilledButton(label: Globalization.saveProfile.tr, onTap: () => _update()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });

  void _showCategorySelection() async {
    Set<CategoryModel>? request = await Get.dialog(
      barrierDismissible: false,
      CustomCategoryDialog(categories: _categories, selectedCategories: _selectedCategories),
    );

    if (request != null) setState(() => _selectedCategories = request);
  }
}
