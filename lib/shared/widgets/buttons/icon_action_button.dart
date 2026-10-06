import 'package:flutter/material.dart';
import 'package:flutter_template/core/theme/app_spacing.dart';

/// Reusable icon action button with tooltip and badge count support.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.badgeCount,
    this.color,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final int? badgeCount;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget iconWidget = icon;
    if (badgeCount != null && badgeCount! > 0) {
      iconWidget = Badge(
        label: Text(
          badgeCount! > 99 ? '99+' : badgeCount.toString(),
          style: const TextStyle(fontSize: 10),
        ),
        backgroundColor: colorScheme.error,
        child: icon,
      );
    }

    final button = IconButton(
      icon: iconWidget,
      onPressed: onPressed,
      color: color ?? colorScheme.onSurfaceVariant,
      padding: const EdgeInsets.all(AppSpacing.sm),
      visualDensity: VisualDensity.compact,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
