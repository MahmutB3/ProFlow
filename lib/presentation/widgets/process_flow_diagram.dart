import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';

class ProcessFlowDiagram extends StatefulWidget {
  const ProcessFlowDiagram({super.key});

  @override
  State<ProcessFlowDiagram> createState() => _ProcessFlowDiagramState();
}

class _ProcessFlowDiagramState extends State<ProcessFlowDiagram> {
  final Map<String, Offset> _nodePositions = {};
  String? _selectedNode;

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
          // Initialize node positions if not set yet
          if (_nodePositions.isEmpty) {
            _initializeNodePositions(
              activities.toList(),
              300,
              constraints.maxWidth,
            );
          }

          return SizedBox(
            height: 300,
            width: constraints.maxWidth,
            child: InteractiveViewer(
              constrained: true,
              boundaryMargin: const EdgeInsets.all(16),
              minScale: 0.5,
              maxScale: 2.0,
              child: Stack(
                children: [
                  // Background for edges
                  CustomPaint(
                    size: Size(constraints.maxWidth, 300),
                    painter: DiagramEdgesPainter(
                      transitions: transitions,
                      nodePositions: _nodePositions,
                      maxFrequency: maxFrequency,
                      textColor: textColor,
                      accentColor: accentColor,
                      isDark: isDark,
                    ),
                  ),

                  // Draggable nodes
                  for (final activity in activities)
                    _buildDraggableNode(
                      activity,
                      textColor,
                      nodeColor,
                      accentColor,
                      isDark,
                      activities.length,
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildDraggableNode(
    String activity,
    Color textColor,
    Color nodeColor,
    Color accentColor,
    bool isDark,
    int activityCount,
  ) {
    final position = _nodePositions[activity] ?? const Offset(0, 0);
    final nodeRadius = min(40.0, 25.0 + (activityCount < 8 ? 15.0 : 0.0));

    return Positioned(
      left: position.dx - nodeRadius,
      top: position.dy - nodeRadius,
      width: nodeRadius * 2,
      height: nodeRadius * 2,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            _selectedNode = activity;
          });
        },
        onPanUpdate: (details) {
          // Hız çarpanı ekle - sürükleme daha hızlı olacak
          const speedMultiplier = 1.5;
          setState(() {
            _nodePositions[activity] = Offset(
              position.dx + details.delta.dx * speedMultiplier,
              position.dy + details.delta.dy * speedMultiplier,
            );
          });
        },
        onPanEnd: (_) {
          setState(() {
            _selectedNode = null;
          });
        },
        child: CustomPaint(
          size: Size(nodeRadius * 2, nodeRadius * 2),
          painter: DiagramNodePainter(
            activity: activity,
            nodeRadius: nodeRadius,
            textColor: textColor,
            nodeColor: nodeColor,
            accentColor: accentColor,
            isDark: isDark,
            isSelected: _selectedNode == activity,
          ),
        ),
      ),
    );
  }

  void _initializeNodePositions(
    List<String> activities,
    double height,
    double width,
  ) {
    final nodeRadius = min(40.0, 25.0 + (activities.length < 8 ? 15.0 : 0.0));

    // Temizle önceki pozisyonları
    _nodePositions.clear();

    // Position activities in a circular layout
    final centerX = width / 2;
    final centerY = height / 2;
    final radius =
        min(centerX, centerY) * 0.6; // Merkeze daha yakın daha küçük bir daire

    // Position nodes in a circle
    for (int i = 0; i < activities.length; i++) {
      final angle = 2 * pi * i / activities.length;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      _nodePositions[activities[i]] = Offset(x, y);
    }
  }
}

class DiagramEdgesPainter extends CustomPainter {
  final List<MapEntry<String, int>> transitions;
  final Map<String, Offset> nodePositions;
  final double maxFrequency;
  final Color textColor;
  final Color accentColor;
  final bool isDark;

  DiagramEdgesPainter({
    required this.transitions,
    required this.nodePositions,
    required this.maxFrequency,
    required this.textColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeRadius = 40.0;

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

      if (distance < 0.1) continue; // Avoid division by zero

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

      // Draw edge
      final strokeWidth = 1.0 + 4.0 * (transition.value / maxFrequency);
      final paint =
          Paint()
            ..color = accentColor.withOpacity(0.6)
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;

      canvas.drawLine(adjustedSourcePos, adjustedTargetPos, paint);

      // Draw arrow
      _drawArrow(canvas, adjustedSourcePos, adjustedTargetPos);

      // Draw frequency label
      _drawFrequencyLabel(
        canvas,
        adjustedSourcePos,
        adjustedTargetPos,
        transition.value,
      );
    }
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end) {
    // Calculate arrow points
    final arrowLength = 15.0;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final angle = atan2(dy, dx);

    final arrowPaint =
        Paint()
          ..color = accentColor
          ..style = PaintingStyle.fill;

    final arrowTip = end;
    final arrowPoint1 = Offset(
      end.dx - arrowLength * cos(angle - pi / 8),
      end.dy - arrowLength * sin(angle - pi / 8),
    );
    final arrowPoint2 = Offset(
      end.dx - arrowLength * cos(angle + pi / 8),
      end.dy - arrowLength * sin(angle + pi / 8),
    );

    final path =
        Path()
          ..moveTo(arrowTip.dx, arrowTip.dy)
          ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
          ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
          ..close();

    canvas.drawPath(path, arrowPaint);
  }

  void _drawFrequencyLabel(Canvas canvas, Offset start, Offset end, int value) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: value.toString(),
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 10 + 2.0 * value / maxFrequency,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Position label at the middle of the line
    final midpoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);

    // Draw background for the label
    final bgRect = Rect.fromCenter(
      center: midpoint,
      width: textPainter.width + 8,
      height: textPainter.height + 4,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      Paint()..color = (isDark ? Colors.black : Colors.white).withOpacity(0.8),
    );

    // Draw the text
    textPainter.paint(
      canvas,
      Offset(
        midpoint.dx - textPainter.width / 2,
        midpoint.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(DiagramEdgesPainter oldDelegate) {
    return transitions != oldDelegate.transitions ||
        nodePositions != oldDelegate.nodePositions ||
        maxFrequency != oldDelegate.maxFrequency ||
        textColor != oldDelegate.textColor ||
        accentColor != oldDelegate.accentColor ||
        isDark != oldDelegate.isDark;
  }
}

class DiagramNodePainter extends CustomPainter {
  final String activity;
  final double nodeRadius;
  final Color textColor;
  final Color nodeColor;
  final Color accentColor;
  final bool isDark;
  final bool isSelected;

  DiagramNodePainter({
    required this.activity,
    required this.nodeRadius,
    required this.textColor,
    required this.nodeColor,
    required this.accentColor,
    required this.isDark,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw node with shadow
    final shadowPaint =
        Paint()
          ..color = Colors.black.withOpacity(isDark ? 0.6 : 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(nodeRadius, nodeRadius), nodeRadius, shadowPaint);

    // Draw node background
    final paint =
        Paint()
          ..color = nodeColor
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(nodeRadius, nodeRadius), nodeRadius, paint);

    // Draw node border
    final borderPaint =
        Paint()
          ..color = isSelected ? Colors.orange : accentColor
          ..strokeWidth = isSelected ? 3.0 : 2.0
          ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(nodeRadius, nodeRadius), nodeRadius, borderPaint);

    // Draw node label
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
        nodeRadius - textPainter.width / 2,
        nodeRadius - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(DiagramNodePainter oldDelegate) {
    return activity != oldDelegate.activity ||
        nodeRadius != oldDelegate.nodeRadius ||
        textColor != oldDelegate.textColor ||
        nodeColor != oldDelegate.nodeColor ||
        accentColor != oldDelegate.accentColor ||
        isDark != oldDelegate.isDark ||
        isSelected != oldDelegate.isSelected;
  }
}
