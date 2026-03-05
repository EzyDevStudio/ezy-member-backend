import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/models/postcode_model.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum TextFieldType { normal, password }

enum PostType { city, postcode }

class CustomAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final List<PostcodeModel> postcodes;
  final PostType type;
  final String selectedState;
  final ValueChanged<PostcodeModel> onSelected;

  const CustomAutocomplete({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.postcodes,
    required this.type,
    required this.selectedState,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 4.0,
      children: <Widget>[
        RawAutocomplete<PostcodeModel>(
          textEditingController: controller,
          focusNode: focusNode,
          displayStringForOption: (option) => type == PostType.city ? option.city : option.postcode,
          optionsBuilder: (value) {
            if (value.text.isEmpty) return const Iterable<PostcodeModel>.empty();

            return postcodes.where((option) {
              final matches = option.stateName == selectedState;

              return (type == PostType.city ? option.city : option.postcode).toLowerCase().startsWith(value.text.toLowerCase()) && matches;
            });
          },
          onSelected: onSelected,
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) => CustomTextField(
            controller: controller,
            focusNode: focusNode,
            isRequired: true,
            label: type == PostType.city ? Globalization.city.tr : Globalization.postcode.tr,
          ),
          optionsViewBuilder: (context, onSelectedOption, options) => Material(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);

                  return ListTile(onTap: () => onSelectedOption(option), title: Text("${option.city} (${option.postcode})"));
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class CustomDropdown<T> extends StatelessWidget {
  final bool enabled, enableSearch, isRequired;
  final List<T> items;
  final String? label;
  final String Function(T) dropdownEntries;
  final T initialSelection;
  final ValueChanged<T?>? onSelected;

  const CustomDropdown({
    super.key,
    this.enabled = true,
    this.enableSearch = true,
    this.isRequired = false,
    required this.items,
    this.label,
    required this.dropdownEntries,
    required this.initialSelection,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 4.0,
    children: <Widget>[
      if (label != null) ...[
        CustomText(
          isRequired ? "* ${label!}" : label!,
          color: isRequired ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          maxLines: null,
        ),
        const SizedBox(),
      ],
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
          color: enabled ? Colors.white : Theme.of(context).colorScheme.surfaceContainerLow,
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: const Offset(0.0, 0.5)),
            BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: const Offset(2.0, 2.0)),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            ),
          ),
          child: DropdownMenu<T>(
            enabled: enabled,
            enableFilter: enableSearch,
            enableSearch: enableSearch,
            requestFocusOnTap: enableSearch,
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: items.map((item) => DropdownMenuEntry<T>(label: dropdownEntries(item), value: item)).toList(),
            textStyle: TextStyle(
              color: enabled ? Colors.black87 : Colors.black54,
              fontSize: 14.0,
              fontStyle: enabled ? FontStyle.normal : FontStyle.italic,
            ),
            initialSelection: initialSelection,
            onSelected: onSelected,
            selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_rounded),
            trailingIcon: Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ),
      ),
    ],
  );
}

class CustomSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressedClear, onPressedSearch;

  const CustomSearchTextField({super.key, required this.controller, required this.onPressedClear, required this.onPressedSearch});

  @override
  Widget build(BuildContext context) => Container(
    alignment: Alignment.centerLeft,
    constraints: BoxConstraints(maxWidth: 350.0),
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: const Offset(0.0, 0.5)),
        BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: const Offset(2.0, 2.0)),
      ],
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
        label: Text(Globalization.search.tr),
        prefixIcon: IconButton(
          onPressed: onPressedClear,
          icon: Icon(Icons.clear_rounded, color: Theme.of(context).colorScheme.error),
        ),
        suffixIcon: IconButton(
          onPressed: onPressedSearch,
          icon: Icon(Icons.search_rounded, color: Theme.of(context).colorScheme.primary),
        ),
      ),
      onSubmitted: (_) => onPressedSearch(),
    ),
  );
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled, isRequired, showTitle;
  final FocusNode? focusNode;
  final IconData? icon;
  final int? maxLength, maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final TextFieldType type;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.isRequired = false,
    this.showTitle = true,
    this.focusNode,
    this.icon,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    required this.label,
    this.type = TextFieldType.normal,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();

    _isObscure = widget.type == TextFieldType.password;

    if (widget.maxLength != null) widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    if (widget.maxLength != null) widget.controller.removeListener(_onTextChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 4.0,
    children: <Widget>[
      if (widget.showTitle) ...[
        CustomText(
          widget.isRequired ? "* ${widget.label}" : widget.label,
          color: widget.isRequired ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          maxLines: null,
        ),
        const SizedBox(),
      ],
      Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: const Offset(0.0, 0.5)),
            BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: const Offset(2.0, 2.0)),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: widget.type == TextFieldType.password && _isObscure,
          readOnly: widget.onTap != null,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.enabled ? Colors.white : Theme.of(context).colorScheme.surfaceContainerLow,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            label: CustomText(widget.label, color: Colors.black38, fontSize: 14.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
            prefixIcon: widget.icon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(widget.icon, color: Theme.of(context).colorScheme.primary),
                  ),
            suffixIcon: widget.type != TextFieldType.password
                ? null
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: IconButton(
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                      icon: Icon(_isObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
          ),
          maxLines: widget.maxLines ?? 1,
          minLines: widget.maxLines ?? 1,
          inputFormatters: <TextInputFormatter>[
            if (widget.maxLength != null) LengthLimitingTextInputFormatter(widget.maxLength),
            ...?widget.inputFormatters,
          ],
          style: TextStyle(
            color: widget.enabled ? Colors.black87 : Colors.black54,
            fontSize: 14.0,
            fontStyle: widget.enabled ? FontStyle.normal : FontStyle.italic,
          ),
          onTap: widget.onTap,
        ),
      ),
      if (widget.maxLength != null)
        CustomText("${widget.controller.text.length}/${widget.maxLength}", color: Colors.black54, fontSize: 14.0, textAlign: TextAlign.end),
    ],
  );
}

class CoordinateFormatter extends TextInputFormatter {
  final int maxIntegerChars;
  final int maxDecimalDigits;
  final RegExp validRegExp = RegExp(r"^-?\d*\.?\d*$");

  CoordinateFormatter({this.maxIntegerChars = 4, this.maxDecimalDigits = 8});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.isEmpty) return newValue;
    if (text == "-") return newValue;
    if (text == ".") return newValue;

    List<String> parts = text.split(".");
    String decimalPart = parts.length > 1 ? parts[1] : "";
    String integerPart = parts[0];

    if (integerPart.length > maxIntegerChars) return oldValue;
    if (decimalPart.length > maxDecimalDigits) return oldValue;
    if (!validRegExp.hasMatch(text)) return oldValue;

    return newValue;
  }
}
