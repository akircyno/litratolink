import 'package:flutter/material.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    this.onTap,
    this.scale = 0.98,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final BorderRadius borderRadius;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool isPressed = false;

  void setPressed(bool value) {
    if (isPressed == value) return;
    setState(() => isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: widget.onTap == null ? null : (_) => setPressed(true),
        onTapCancel: widget.onTap == null ? null : () => setPressed(false),
        onTapUp: widget.onTap == null ? null : (_) => setPressed(false),
        child: AnimatedScale(
          scale: isPressed ? widget.scale : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
