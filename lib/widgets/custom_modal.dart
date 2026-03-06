import 'package:ezymember_backend/constants/app_colors.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/category_model.dart';
import 'package:ezymember_backend/widgets/custom_button.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCategoryDialog extends StatefulWidget {
  final List<CategoryModel> categories;
  final Set<CategoryModel> selectedCategories;

  const CustomCategoryDialog({super.key, required this.categories, required this.selectedCategories});

  @override
  State<CustomCategoryDialog> createState() => _CustomCategoryDialogState();
}

class _CustomCategoryDialogState extends State<CustomCategoryDialog> {
  late Set<CategoryModel> _selectedCategories;

  @override
  void initState() {
    super.initState();

    _selectedCategories = Set.from(widget.selectedCategories);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    constraints: BoxConstraints(maxHeight: 600.0, maxWidth: 600.0),
    backgroundColor: AppColors.defaultWhite,
    surfaceTintColor: AppColors.defaultWhite,
    actions: <Widget>[
      Row(
        spacing: 16.0,
        children: <Widget>[
          Expanded(
            child: CustomFilledButton(
              backgroundColor: AppColors.defaultRed,
              label: Globalization.cancel.tr,
              onTap: () => Get.isDialogOpen == true ? Get.back() : null,
            ),
          ),
          Expanded(
            child: CustomFilledButton(
              label: Globalization.confirm.tr,
              onTap: () => Get.back(result: _selectedCategories),
            ),
          ),
        ],
      ),
    ],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isSelected = _selectedCategories.contains(category);

          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) => setState(() => value == true ? _selectedCategories.add(category) : _selectedCategories.remove(category)),
            subtitle: Text(category.description),
            title: Text(category.name),
          );
        },
      ),
    ),
    title: CustomText(Globalization.selectCategory.tr, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
  );
}

class CustomConfirmationDialog extends StatelessWidget {
  final String content;
  final VoidCallback? onConfirm;

  const CustomConfirmationDialog({super.key, required this.content, this.onConfirm});

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: AppColors.defaultWhite,
    surfaceTintColor: AppColors.defaultWhite,
    actions: <Widget>[
      Row(
        spacing: 16.0,
        children: <Widget>[
          Expanded(
            child: CustomFilledButton(
              backgroundColor: AppColors.defaultRed,
              label: Globalization.no.tr,
              onTap: () => Get.isDialogOpen == true ? Get.back() : null,
            ),
          ),
          if (onConfirm != null)
            Expanded(
              child: CustomFilledButton(label: Globalization.yes.tr, onTap: onConfirm!),
            ),
        ],
      ),
    ],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: CustomText(content, fontSize: 16.0, maxLines: null, textAlign: TextAlign.center),
    title: Column(
      spacing: 8.0,
      children: <Widget>[
        Image.asset("assets/icons/confirmation.png", height: 30.0),
        CustomText(Globalization.msgConfirmation.tr, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
      ],
    ),
  );
}

class CustomDetailModal extends StatelessWidget {
  final String? title;
  final Widget content;

  const CustomDetailModal({super.key, this.title, required this.content});

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    constraints: BoxConstraints(maxHeight: 600.0, maxWidth: 600.0),
    backgroundColor: AppColors.defaultWhite,
    surfaceTintColor: AppColors.defaultWhite,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CustomFilledButton(
          backgroundColor: AppColors.defaultRed,
          label: Globalization.close.tr,
          onTap: () => Get.isDialogOpen == true ? Get.back() : null,
        ),
      ),
    ],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: SizedBox(width: double.maxFinite, child: content),
    title: CustomText(title ?? Globalization.details.tr, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
  );
}

class CustomItemModal extends StatelessWidget {
  final bool isCreate;
  final String title;
  final VoidCallback onTap;
  final Widget content;

  const CustomItemModal({super.key, this.isCreate = true, required this.title, required this.onTap, required this.content});

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    constraints: BoxConstraints(maxHeight: 600.0, maxWidth: 600.0),
    backgroundColor: AppColors.defaultWhite,
    surfaceTintColor: AppColors.defaultWhite,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          spacing: 16.0,
          children: <Widget>[
            Expanded(
              child: CustomFilledButton(
                backgroundColor: AppColors.defaultRed,
                label: Globalization.cancel.tr,
                onTap: () => Get.isDialogOpen == true ? Get.back() : null,
              ),
            ),
            Expanded(
              child: CustomFilledButton(label: isCreate ? Globalization.create.tr : Globalization.update.tr, onTap: onTap),
            ),
          ],
        ),
      ),
    ],
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
    content: content,
    title: CustomText(title, fontSize: 20.0, fontWeight: FontWeight.bold, maxLines: null, textAlign: TextAlign.center),
  );
}
