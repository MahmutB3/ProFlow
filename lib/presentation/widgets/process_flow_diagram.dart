import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';

class ProcessFlowDiagram extends StatelessWidget {
  const ProcessFlowDiagram({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProcessController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2D2D3A);
    final nodeColor = isDark ? const Color(0xFF2A2A36) : Colors.white;
    final accentColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

    return Obx(() {
      final transitions = controller.sortedTransitionFrequencies;

      if (transitions.isEmpty) {
        return Center(
          child: Text(
            'Akış diyagramı için veri bulunamadı',
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
        );
      }

      // Extract all unique activities
      final activities = <String>{};
      for (final transition in transitions) {
        final parts = transition.key.split(' -> ');
        if (parts.length == 2) {
          activities.add(parts[0]);
          activities.add(parts[1]);
        }
      }

      // Find max transition frequency for scaling
      final maxFrequency =
          transitions.isNotEmpty ? transitions.first.value.toDouble() : 1.0;

      return LayoutBuilder(
        builder: (context, constraints) {
          // Calculate minimum width needed based on node count
          final minWidth = max(constraints.maxWidth, activities.length * 120.0);

          return SizedBox(
            height: 300,
            child: InteractiveViewer(
              constrained: true, // Değiştirildi - sınırlı olarak ayarlandı
              boundaryMargin: const EdgeInsets.all(8),
              minScale: 0.5,
              maxScale: 2.0,
              child: SizedBox(
                height: 300,
                width: minWidth,
                child: CustomPaint(
                  painter: ProcessFlowPainter(
                    transitions: transitions,
                    activities: activities.toList(),
                    maxFrequency: maxFrequency,
                    textColor: textColor,
                    nodeColor: nodeColor,
                    accentColor: accentColor,
                    isDark: isDark,
                  ),
                  size: Size(minWidth, 300), // Yükseklik sabitlendi
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class ProcessFlowPainter extends CustomPainter {
  final List<MapEntry<String, int>> transitions;
  final List<String> activities;
  final double maxFrequency;
  final Color textColor;
  final Color nodeColor;
  final Color accentColor;
  final bool isDark;

  ProcessFlowPainter({
    required this.transitions,
    required this.activities,
    required this.maxFrequency,
    required this.textColor,
    required this.nodeColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeRadius = min(40.0, 25.0 + (activities.length < 8 ? 15.0 : 0.0));
    final nodePositions = <String, Offset>{};

    // Position activities in a circular layout
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY) - nodeRadius - 30.0;

    // Position nodes in a circle
    for (int i = 0; i < activities.length; i++) {
      final angle = 2 * pi * i / activities.length;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      nodePositions[activities[i]] = Offset(x, y);
    }

    // Draw edges (transitions)
    for (final transition in transitions) {
      final parts = transition.key.split(' -> ');
      if (parts.length != 2) continue;

      final sourceActivity = parts[0];
      final targetActivity = parts[1];

      if (!nodePositions.containsKey(sourceActivity) ||
          !nodePositions.containsKey(targetActivity)) {
        continue;
      }

      final sourcePos = nodePositions[sourceActivity]!;
      final targetPos = nodePositions[targetActivity]!;

      // Calculate direction vector
      final dx = targetPos.dx - sourcePos.dx;
      final dy = targetPos.dy - sourcePos.dy;
      final distance = sqrt(dx * dx + dy * dy);

      // Normalize
      final ndx = dx / distance;
      final ndy = dy / distance;

      // Adjust start and end points to be on the node borders
      final adjustedSourcePos = Offset(
        sourcePos.dx + ndx * nodeRadius,
        sourcePos.dy + ndy * nodeRadius,
      );

      final adjustedTargetPos = Offset(
        targetPos.dx - ndx * nodeRadius,
        targetPos.dy - ndy * nodeRadius,
      );

      // Calculate arrow points
      final arrowLength = 15.0;
      final arrowWidth = 8.0;

      final arrowTip = adjustedTargetPos;
      final angle = atan2(ndy, ndx);
      final arrowPoint1 = Offset(
        arrowTip.dx - arrowLength * cos(angle - pi / 8),
        arrowTip.dy - arrowLength * sin(angle - pi / 8),
      );
      final arrowPoint2 = Offset(
        arrowTip.dx - arrowLength * cos(angle + pi / 8),
        arrowTip.dy - arrowLength * sin(angle + pi / 8),
      );

      // Draw edge
      final strokeWidth = 1.0 + 5.0 * transition.value / maxFrequency;
      final paint =
          Paint()
            ..color = accentColor.withOpacity(0.6)
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;

      canvas.drawLine(adjustedSourcePos, adjustedTargetPos, paint);

      // Draw arrow
      final arrowPaint =
          Paint()
            ..color = accentColor
            ..style = PaintingStyle.fill;

      final path =
          Path()
            ..moveTo(arrowTip.dx, arrowTip.dy)
            ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
            ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
            ..close();

      canvas.drawPath(path, arrowPaint);

      // Draw frequency label
      final textPainter = TextPainter(
        text: TextSpan(
          text: transition.value.toString(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 10 + 2.0 * transition.value / maxFrequency,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelPos = Offset(
        (adjustedSourcePos.dx + adjustedTargetPos.dx) / 2 -
            textPainter.width / 2,
        (adjustedSourcePos.dy + adjustedTargetPos.dy) / 2 -
            textPainter.height / 2,
      );

      // Add background to label
      final bgRect = Rect.fromCenter(
        center: Offset(
          (adjustedSourcePos.dx + adjustedTargetPos.dx) / 2,
          (adjustedSourcePos.dy + adjustedTargetPos.dy) / 2,
        ),
        width: textPainter.width + 8,
        height: textPainter.height + 4,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
        Paint()
          ..color = (isDark ? Colors.black : Colors.white).withOpacity(0.8),
      );

      textPainter.paint(canvas, labelPos);
    }

    // Draw nodes (activities)
    for (final entry in nodePositions.entries) {
      final activity = entry.key;
      final position = entry.value;

      // Draw node with shadow
      final shadowPaint =
          Paint()
            ..color = Colors.black.withOpacity(isDark ? 0.6 : 0.2)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(position.dx + 2.0, position.dy + 2.0),
        nodeRadius,
        shadowPaint,
      );

      // Draw node
      final paint =
          Paint()
            ..color = nodeColor
            ..style = PaintingStyle.fill;

      final borderPaint =
          Paint()
            ..color = accentColor
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke;

      canvas.drawCircle(position, nodeRadius, paint);
      canvas.drawCircle(position, nodeRadius, borderPaint);

      // Draw activity name
      final activityName =
          activity.length > 15 ? '${activity.substring(0, 12)}...' : activity;

      final textPainter = TextPainter(
        text: TextSpan(
          text: activityName,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: nodeRadius * 1.8);

      textPainter.paint(
        canvas,
        Offset(
          position.dx - textPainter.width / 2,
          position.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(ProcessFlowPainter oldDelegate) {
    return transitions != oldDelegate.transitions ||
        activities != oldDelegate.activities ||
        maxFrequency != oldDelegate.maxFrequency ||
        textColor != oldDelegate.textColor ||
        nodeColor != oldDelegate.nodeColor ||
        accentColor != oldDelegate.accentColor ||
        isDark != oldDelegate.isDark;
  }
}
