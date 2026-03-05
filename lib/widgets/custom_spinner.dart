import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomSpinner extends StatefulWidget {
  final bool isRequired;
  final int max, min, value;
  final String? label;
  final ValueChanged<int>? onChanged;

  const CustomSpinner({super.key, this.isRequired = false, this.max = 99, this.min = 1, this.value = 1, this.label, this.onChanged});

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _onTextChanged(String value) {
    String digits = value.replaceAll(RegExp(r"[^0-9]"), "");

    if (digits.length > 2) digits = digits.substring(digits.length - 2);

    int number = int.tryParse(digits) ?? widget.min;

    if (number > widget.max) number = widget.max;
    if (number < widget.min) number = widget.min;

    if (_controller.text != number.toString()) {
      _controller.text = number.toString();
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }

    widget.onChanged?.call(number);
    setState(() {});
  }

  void _increment(bool add) {
    int current = int.tryParse(_controller.text) ?? widget.min;

    if (add) {
      if (current < widget.max) current++;
    } else {
      if (current > widget.min) current--;
    }

    _onTextChanged(current.toString());
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 4.0,
    children: <Widget>[
      if (widget.label != null) ...[
        CustomText(
          widget.isRequired ? "* ${widget.label!}" : widget.label!,
          color: widget.isRequired ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          maxLines: null,
        ),
        const SizedBox(),
      ],
      Container(
        width: 60.0,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: const Offset(0.0, 0.5)),
            BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: const Offset(2.0, 2.0)),
          ],
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            prefixIcon: IconButton(onPressed: () => _increment(false), icon: Icon(Icons.remove_circle_outline_rounded)),
            suffixIcon: IconButton(onPressed: () => _increment(true), icon: Icon(Icons.add_circle_outline_rounded)),
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          onChanged: _onTextChanged,
        ),
      ),
    ],
  );
}

class CustomDoubleSpinner extends StatefulWidget {
  final bool isRequired;
  final double max, min, step, value;
  final String? label;
  final ValueChanged<double>? onChanged;

  const CustomDoubleSpinner({
    super.key,
    this.isRequired = false,
    this.max = 99.9,
    this.min = 0.0,
    this.step = 0.1,
    this.value = 0.0,
    this.label,
    this.onChanged,
  });

  @override
  State<CustomDoubleSpinner> createState() => _CustomDoubleSpinnerState();
}

class _CustomDoubleSpinnerState extends State<CustomDoubleSpinner> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.value.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _onTextChanged(String value) {
    String digits = value.replaceAll(RegExp(r"[^0-9]"), "");

    if (digits.isEmpty) digits = "0";

    int maxDigits = widget.max.toString().replaceAll(".", "").length;

    if (digits.length > maxDigits) digits = digits.substring(digits.length - maxDigits);

    double number = double.parse(digits) / 10;

    if (number > widget.max) number = widget.max;
    if (number < widget.min) number = widget.min;

    String textValue = number.toStringAsFixed(1);

    if (_controller.text != textValue) {
      _controller.text = textValue;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    }

    widget.onChanged?.call(number);
    setState(() {});
  }

  void _increment(bool add) {
    double current = double.tryParse(_controller.text) ?? widget.min;
    current += add ? widget.step : -widget.step;

    if (current > widget.max) current = widget.max;
    if (current < widget.min) current = widget.min;

    _onTextChanged(current.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 4.0,
    children: <Widget>[
      if (widget.label != null) ...[
        CustomText(
          widget.isRequired ? "* ${widget.label!}" : widget.label!,
          color: widget.isRequired ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          maxLines: null,
        ),
        const SizedBox(),
      ],
      Container(
        width: 80.0,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 2.0, offset: const Offset(0.0, 0.5)),
            BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: const Offset(2.0, 2.0)),
          ],
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kBorderRadius), borderSide: BorderSide.none),
            prefixIcon: IconButton(onPressed: () => _increment(false), icon: const Icon(Icons.remove_circle_outline_rounded)),
            suffixIcon: IconButton(onPressed: () => _increment(true), icon: const Icon(Icons.add_circle_outline_rounded)),
          ),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: _onTextChanged,
        ),
      ),
    ],
  );
}
