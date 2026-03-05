import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomFilledButton extends StatefulWidget {
  final bool isLarge;
  final Color? backgroundColor, foregroundColor;
  final String label;
  final VoidCallback onTap;

  const CustomFilledButton({super.key, this.isLarge = true, this.backgroundColor, this.foregroundColor, required this.label, required this.onTap});

  @override
  State<CustomFilledButton> createState() => _CustomFilledButtonState();
}

class _CustomFilledButtonState extends State<CustomFilledButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapCancel: () => setState(() => _pressed = false),
    onTapDown: (_) => setState(() => _pressed = true),
    onTapUp: (_) => setState(() => _pressed = false),
    child: AnimatedScale(
      curve: Curves.easeOut,
      scale: _pressed ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: SizedBox(
        width: widget.isLarge ? double.infinity : null,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
          ),
          onPressed: widget.onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomText(
              widget.label,
              color: widget.foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

class CustomNewItemButton extends StatelessWidget {
  final VoidCallback onTap;

  const CustomNewItemButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => context.isMobile
      ? AspectRatio(
          aspectRatio: kSquareRatio,
          child: CustomPaginationButton(
            onTap: onTap,
            child: Icon(Icons.add_rounded, color: Colors.black87),
          ),
        )
      : ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 175.0),
          child: CustomFilledButton(label: Globalization.newItem.tr, onTap: onTap),
        );
}

class CustomOutlinedButton extends StatefulWidget {
  final String tooltip;
  final VoidCallback? onTap;
  final Widget child;

  const CustomOutlinedButton({super.key, required this.tooltip, this.onTap, required this.child});

  @override
  State<CustomOutlinedButton> createState() => _CustomOutlinedButtonState();
}

class _CustomOutlinedButtonState extends State<CustomOutlinedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: widget.tooltip,
    child: SizedBox(
      height: 40.0,
      width: 40.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(kBorderRadius),
        onTapCancel: () => setState(() => _pressed = false),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);

          widget.onTap?.call();
        },
        child: AnimatedScale(
          curve: Curves.easeOut,
          scale: _pressed ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: FittedBox(fit: BoxFit.scaleDown, child: widget.child),
        ),
      ),
    ),
  );
}

class CustomPaginationButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget child;

  const CustomPaginationButton({super.key, this.isSelected = false, this.onTap, required this.child});

  @override
  State<CustomPaginationButton> createState() => _CustomPaginationButtonState();
}

class _CustomPaginationButtonState extends State<CustomPaginationButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: kSquareRatio,
    child: InkWell(
      borderRadius: BorderRadius.circular(kBorderRadius),
      onTapCancel: () => setState(() => _pressed = false),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);

        widget.onTap?.call();
      },
      child: AnimatedScale(
        curve: Curves.easeOut,
        scale: _pressed ? 0.8 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(color: widget.isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300, width: 1.5),
            color: widget.isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: widget.child),
          ),
        ),
      ),
    ),
  );
}
