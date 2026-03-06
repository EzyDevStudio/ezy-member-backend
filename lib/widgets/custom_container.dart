import 'dart:ui';

import 'package:ezymember_backend/constants/app_constants.dart';
import 'package:ezymember_backend/helpers/responsive_helper.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(padding: EdgeInsets.all(context.isDesktop ? 16.0 : 8.0), decoration: kDecoration, child: child);
}

class CustomDottedContainer extends StatelessWidget {
  final Color? color;
  final double height, width;
  final double? dashSpace, dashWidth, padding, strokeWidth;
  final VoidCallback? onTap;
  final Widget? child;

  const CustomDottedContainer({
    super.key,
    this.color,
    this.height = 0.0,
    this.width = 0.0,
    this.dashSpace,
    this.dashWidth,
    this.padding,
    this.strokeWidth,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
    onTap: onTap,
    child: CustomPaint(
      painter: _DottedBorderPainter(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
        color: color ?? Theme.of(context).colorScheme.primary,
        dashSpace: dashSpace ?? 4.0,
        dashWidth: dashWidth ?? 8.0,
        strokeWidth: strokeWidth ?? 2.0,
      ),
      size: Size(width, height),
      child: Padding(padding: EdgeInsets.all(padding ?? 0.0), child: child),
    ),
  );
}

class CustomImageContainer extends StatefulWidget {
  final double size;
  final PlatformFile? file;
  final String image;
  final VoidCallback onDelete, onSelect;

  const CustomImageContainer({super.key, required this.size, this.file, this.image = "", required this.onDelete, required this.onSelect});

  @override
  State<CustomImageContainer> createState() => _CustomImageContainerState();
}

class _CustomImageContainerState extends State<CustomImageContainer> {
  bool _pressedDelete = false;
  bool _pressedSelect = false;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8.0,
    children: <Widget>[
      Container(
        decoration: kDecoration,
        height: widget.size,
        width: widget.size,
        child: ClipRRect(borderRadius: BorderRadius.circular(kBorderRadius), child: _buildImage()),
      ),
      Column(
        spacing: 8.0,
        children: <Widget>[
          _buildButton(_pressedSelect, Icons.image_outlined, (v) => setState(() => _pressedSelect = v), () => widget.onSelect.call()),
          _buildButton(_pressedDelete, Icons.delete_rounded, (v) => setState(() => _pressedDelete = v), () => widget.onDelete.call()),
        ],
      ),
    ],
  );

  Widget _buildImage() {
    if (widget.file != null) return Image.memory(widget.file!.bytes!, fit: BoxFit.contain);
    if (widget.image.isNotEmpty) return Image.network(widget.image, fit: BoxFit.contain);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FittedBox(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey)),
    );
  }

  Widget _buildButton(bool pressed, IconData icon, ValueChanged<bool> onPressedState, VoidCallback onPressed) => InkWell(
    borderRadius: BorderRadius.circular(kBorderRadius),
    onTapCancel: () => onPressedState(false),
    onTapDown: (_) => onPressedState(true),
    onTapUp: (_) {
      onPressedState(false);
      onPressed();
    },
    child: AnimatedScale(
      curve: Curves.easeOut,
      scale: pressed ? 0.8 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        decoration: kDecoration,
        height: widget.size * 0.3,
        width: widget.size * 0.3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(child: Icon(icon, color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ),
    ),
  );
}

class CustomRow extends StatelessWidget {
  final Color? color;
  final String data, title;

  const CustomRow({super.key, this.color, required this.data, required this.title});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(flex: 2, child: CustomText(title, color: Colors.black54, fontSize: 14.0, maxLines: null)),
      CustomText(" : ", color: Colors.grey, fontSize: 14.0, maxLines: null),
      Expanded(
        flex: 6,
        child: CustomText(data, color: color, fontSize: 14.0, fontWeight: FontWeight.bold, maxLines: null),
      ),
    ],
  );
}

class _DottedBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final Color color;
  final double dashSpace, dashWidth, strokeWidth;

  _DottedBorderPainter({
    required this.borderRadius,
    required this.color,
    required this.dashSpace,
    required this.dashWidth,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
    );

    final path = Path()..addRRect(rect);
    final pathMetrics = path.computeMetrics();

    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;

      while (distance < pathMetric.length) {
        final extractedPath = pathMetric.extractPath(distance, distance + dashWidth);

        canvas.drawPath(extractedPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
