import 'package:flutter/material.dart';

import 'pressable_scale.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.secondary = false,
    super.key,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    final button = secondary
        ? OutlinedButton(onPressed: onPressed == null ? null : () {}, child: child)
        : ElevatedButton(onPressed: onPressed == null ? null : () {}, child: child);

    return PressableScale(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: IgnorePointer(child: button),
    );
  }
}
