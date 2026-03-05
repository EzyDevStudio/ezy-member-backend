import 'package:ezymember_backend/language/globalization.dart';
import 'package:ezymember_backend/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> with SingleTickerProviderStateMixin {
  final String label = Globalization.msgLoading.tr;

  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: 1200), vsync: this);
    _createAnimations();
    _controller.repeat();
  }

  void _createAnimations() {
    final length = label.length;

    _animations = List.generate(length, (index) {
      final start = (index / length).clamp(0.0, 1.0);
      final end = ((index / length) + 0.5).clamp(0.0, 1.0);

      return TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: -20.0).chain(CurveTween(curve: Curves.easeOut)), weight: 50.0),
        TweenSequenceItem(tween: Tween(begin: -20.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 50.0),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.linear),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        label.length,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) => Transform.translate(offset: Offset(0.0, _animations[index].value), child: child),
          child: CustomText(label[index], color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => AbsorbPointer(
        absorbing: true,
        child: Material(
          color: Colors.black.withValues(alpha: 0.7),
          child: SafeArea(child: Center(child: CustomLoading())),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
