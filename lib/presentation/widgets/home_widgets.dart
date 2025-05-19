import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';
import 'package:surecproject/presentation/pages/results_page.dart';
import 'package:surecproject/presentation/widgets/neumorphic_widgets.dart';

class ResultsView extends StatelessWidget {
  final ProcessController controller;
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final Color textColor;
  final Color accentColor;

  const ResultsView({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    required this.textColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphicContainer(
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          lightShadowColor: lightShadowColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: accentColor, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dosya yüklendi',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.fileName.value,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Sonuçları görüntüle buton
        GestureDetector(
          onTap: () => Get.to(() => const ResultsPage()),
          child: NeumorphicContainer(
            backgroundColor: accentColor,
            shadowColor: accentColor.withOpacity(0.3),
            lightShadowColor: accentColor.withOpacity(0.1),
            isPressed: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pie_chart, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Analiz Sonuçlarını Görüntüle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Farklı bir dosya seç buton
        GestureDetector(
          onTap: controller.pickAndAnalyzeCsvFile,
          child: NeumorphicContainer(
            backgroundColor: backgroundColor,
            shadowColor: shadowColor,
            lightShadowColor: lightShadowColor,
            isPressed: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_present, color: textColor, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Farklı Bir Dosya Seç',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  final ProcessController controller;
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final Color textColor;
  final Color accentColor;

  const ActionButtons({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    required this.textColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Veri Kaynağı Seçin',
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        // CSV dosyası seç buton
        ActionButton(
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          lightShadowColor: lightShadowColor,
          textColor: textColor,
          icon: Icons.upload_file,
          title: 'CSV Dosyası Seç',
          subtitle: 'Telefonunuzdan bir süreç verisi dosyası yükleyin',
          onTap: controller.pickAndAnalyzeCsvFile,
        ),
        const SizedBox(height: 16),
        // Örnek veri buton
        ActionButton(
          backgroundColor: backgroundColor,
          shadowColor: shadowColor,
          lightShadowColor: lightShadowColor,
          textColor: textColor,
          icon: Icons.upload_file,
          title: 'Örnek Veriyi Kullan',
          subtitle: 'Hazır örnek veri ile hızlıca başlayın',
          onTap: controller.loadSampleDataFromAssets,
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final Color backgroundColor;
  final Color shadowColor;
  final Color lightShadowColor;
  final Color textColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.backgroundColor,
    required this.shadowColor,
    required this.lightShadowColor,
    required this.textColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeumorphicContainer(
        backgroundColor: backgroundColor,
        shadowColor: shadowColor,
        lightShadowColor: lightShadowColor,
        isPressed: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              NeumorphicCircle(
                child: Icon(icon, color: textColor, size: 24),
                backgroundColor: backgroundColor,
                shadowColor: shadowColor,
                lightShadowColor: lightShadowColor,
                size: 48,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: textColor.withOpacity(0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String errorText;
  final bool isDark;

  const ErrorMessage({
    super.key,
    required this.errorText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D1515) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorText,
              style: TextStyle(
                color:
                    isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
