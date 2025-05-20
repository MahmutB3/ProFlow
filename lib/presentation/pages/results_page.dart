import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surecproject/core/utils.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';
import 'package:surecproject/presentation/widgets/activity_frequency_chart.dart';
import 'package:surecproject/presentation/widgets/expandable_list.dart';
import 'package:surecproject/presentation/widgets/info_card.dart';
import 'package:surecproject/presentation/widgets/neumorphic_widgets.dart';
import 'package:surecproject/presentation/widgets/process_flow_diagram.dart';
import 'package:surecproject/presentation/widgets/transition_frequency_chart.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProcessController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Nöromorfik stil için renkler
    final backgroundColor =
        isDark ? const Color(0xFF1E1E24) : const Color(0xFFF0F0F5);
    final shadowColor = isDark ? Colors.black : Colors.grey.shade500;
    final lightShadowColor = isDark ? Colors.grey.shade800 : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D2D3A);
    final accentColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Analiz Sonuçları',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (!controller.hasData.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicCircle(
                  child: Icon(
                    Icons.search_off_rounded,
                    color: textColor.withOpacity(0.6),
                    size: 28,
                  ),
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  lightShadowColor: lightShadowColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Veri bulunamadı',
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Özet başlık
                  SectionHeader(
                    title: 'Özet Bilgiler',
                    textColor: textColor,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),

                  // Özet kartlar
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.3,
                    children: [
                      InfoCard(
                        title: 'İşlemler',
                        value: controller.cases.value.length.toString(),
                        icon: Icons.folder,
                        backgroundColor: backgroundColor,
                        shadowColor: shadowColor,
                        lightShadowColor: lightShadowColor,
                        textColor: textColor,
                        accentColor: accentColor,
                      ),
                      InfoCard(
                        title: 'Aktiviteler',
                        value: controller.events.value.length.toString(),
                        icon: Icons.event,
                        backgroundColor: backgroundColor,
                        shadowColor: shadowColor,
                        lightShadowColor: lightShadowColor,
                        textColor: textColor,
                        accentColor: accentColor,
                      ),
                      InfoCard(
                        title: 'Çeşitlilik',
                        value:
                            controller.activityFrequencies.value.length
                                .toString(),
                        icon: Icons.category,
                        backgroundColor: backgroundColor,
                        shadowColor: shadowColor,
                        lightShadowColor: lightShadowColor,
                        textColor: textColor,
                        accentColor: accentColor,
                      ),
                      InfoCard(
                        title: 'Süre',
                        value: Utils.formatDuration(
                          controller.averageDuration.value,
                        ),
                        icon: Icons.timer,
                        backgroundColor: backgroundColor,
                        shadowColor: shadowColor,
                        lightShadowColor: lightShadowColor,
                        textColor: textColor,
                        accentColor: accentColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // En sık aktiviteler
                  SectionHeader(
                    title: 'En Sık Gerçekleşen Aktiviteler',
                    textColor: textColor,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),

                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: ExpandableList(
                      items: controller.sortedActivityFrequencies,
                      expandText: 'İlk 5 Aktiviteyi Göster',
                      collapseText: 'Tüm Aktiviteleri Göster',
                      textColor: textColor,
                      accentColor: accentColor,
                    ),
                  ),

                  const SizedBox(height: 32),
                  // En sık geçişler
                  SectionHeader(
                    title: 'En Sık Geçişler',
                    textColor: textColor,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),

                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: ExpandableList(
                      items: controller.sortedTransitionFrequencies,
                      expandText: 'İlk 5 Geçişi Göster',
                      collapseText: 'Tüm Geçişleri Göster',
                      textColor: textColor,
                      accentColor: accentColor,
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Süreç akış diyagramı
                  SectionHeader(
                    title: 'Süreç Akış Diyagramı',
                    textColor: textColor,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),

                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const ProcessFlowDiagram(),
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Grafikler
                  SectionHeader(
                    title: 'Grafikler',
                    textColor: textColor,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 16),

                  // Aktivite frekansları
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                    child: Text(
                      'Aktivite Frekansları',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),

                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const ActivityFrequencyChart(),
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Geçiş frekansları
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
                    child: Text(
                      'Geçiş Frekansları',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),

                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const TransitionFrequencyChart(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Altbilgi
                  Center(
                    child: Text(
                      'ProFlow v1.0 © 2025 Mahmut Basmacı',
                      style: TextStyle(
                        color: textColor.withOpacity(0.4),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
