import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? hoverColor;
  final Color? defaultColor;
  final Duration duration;

  const HoverButton({
    super.key,
    required this.child,
    this.onPressed,
    this.hoverColor,
    this.defaultColor,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? iconColor;
  final Color? hoverColor;

  const HoverIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.iconColor,
    this.hoverColor,
  });

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.hoverColor ?? const Color(0xFFDC143C)).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(widget.icon),
            color: _isHovered
                ? (widget.hoverColor ?? const Color(0xFFDC143C))
                : (widget.iconColor ?? const Color(0xFFDC143C)),
            onPressed: widget.onPressed,
          ),
        ),
      ),
    );
  }
}

