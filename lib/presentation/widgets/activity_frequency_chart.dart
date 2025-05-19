import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';

class ActivityFrequencyChart extends StatelessWidget {
  const ActivityFrequencyChart({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProcessController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2D2D3A);
    final barColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

    return Obx(() {
      final frequencies = controller.sortedActivityFrequencies;

      if (frequencies.isEmpty) {
        return Center(
          child: Text(
            'Veri yok',
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
        );
      }

      // Create a custom horizontal bar chart display that can be scrolled with the page
      return LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final labelWidth = availableWidth * 0.3; // 30% for labels
          final maxBarWidth =
              availableWidth - labelWidth - 16; // 16px for padding

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(frequencies.length, (index) {
                final item = frequencies[index];
                final maxValue = frequencies.first.value.toDouble();
                final barWidth = (item.value / maxValue) * maxBarWidth;

                return Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      // Activity name on the left
                      Container(
                        width: labelWidth,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(right: 8),
                        child: Tooltip(
                          message: item.key,
                          child: Text(
                            item.key,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Bar
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: barWidth,
                              decoration: BoxDecoration(
                                color: barColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              // Value label at the end of the bar
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                item.value.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Flexible spacer to fill the width
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        },
      );
    });
  }
}
