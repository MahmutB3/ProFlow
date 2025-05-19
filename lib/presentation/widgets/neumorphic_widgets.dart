import 'package:flutter/material.dart';

/// Nöromorfik stil için container widget
class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final bool isPressed;
  final double borderRadius;

  const NeumorphicContainer({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    this.isPressed = false,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            isPressed
                ? [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.15),
                    offset: const Offset(2, 2),
                    blurRadius: 2,
                    spreadRadius: -2,
                  ),
                  BoxShadow(
                    color: lightShadowColor.withOpacity(0.7),
                    offset: const Offset(-2, -2),
                    blurRadius: 2,
                    spreadRadius: -2,
                  ),
                ]
                : [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.4),
                    offset: const Offset(5, 5),
                    blurRadius: 10,
                    spreadRadius: -3,
                  ),
                  BoxShadow(
                    color: lightShadowColor.withOpacity(0.7),
                    offset: const Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: -3,
                  ),
                ],
      ),
      child: child,
    );
  }
}

/// Nöromorfik stil için daire widget
class NeumorphicCircle extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final double size;

  const NeumorphicCircle({
    super.key,
    required this.child,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: lightShadowColor.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
  }
}

/// Nöromorfik stil için bölüm başlığı widget
class SectionHeader extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color accentColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.textColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
