import 'package:flutter/material.dart';
import 'package:surecproject/presentation/widgets/neumorphic_widgets.dart';

/// Özet bilgi kartı widget'ı
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final Color textColor;
  final Color accentColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    required this.textColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      lightShadowColor: lightShadowColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                NeumorphicCircle(
                  child: Icon(icon, color: accentColor, size: 20),
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  lightShadowColor: lightShadowColor,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
