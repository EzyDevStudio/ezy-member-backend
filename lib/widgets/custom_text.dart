import 'dart:async';

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;
  final Color? color;
  final double fontSize;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const CustomText(
    this.data, {
    super.key,
    this.color,
    required this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.maxLines = 1,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Text(
    data,
    maxLines: maxLines,
    textAlign: textAlign,
    overflow: maxLines == null ? null : overflow ?? TextOverflow.ellipsis,
    style: TextStyle(color: color ?? Colors.black87, fontSize: fontSize, fontStyle: fontStyle, fontWeight: fontWeight),
  );
}

class CustomCountdownText extends StatefulWidget {
  final int seconds;

  const CustomCountdownText({super.key, required this.seconds});

  @override
  State<CustomCountdownText> createState() => _CustomCountdownTextState();
}

class _CustomCountdownTextState extends State<CustomCountdownText> {
  late int remaining;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    remaining = widget.seconds;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 0) {
        timer?.cancel();
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  String get _display {
    final hours = remaining ~/ 3600;
    final minutes = (remaining ~/ 60) % 60;
    final seconds = remaining % 60;

    if (hours > 0) return "${hours}h:${minutes}m:${seconds}s";
    if (minutes > 0) return "${minutes}m:${seconds}s";
    return "${seconds}s";
  }

  @override
  Widget build(BuildContext context) => CustomText(
    _display,
    color: Theme.of(context).colorScheme.primary,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    maxLines: null,
    textAlign: TextAlign.center,
  );
}
