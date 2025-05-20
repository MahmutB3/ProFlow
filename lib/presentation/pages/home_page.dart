import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:surecproject/presentation/controllers/process_controller.dart';
import 'package:surecproject/presentation/controllers/theme_controller.dart';
import 'package:surecproject/presentation/widgets/home_widgets.dart';
import 'package:surecproject/presentation/widgets/neumorphic_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProcessController>();
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Nöromorfik stil için renkler
    final backgroundColor =
        isDark ? const Color(0xFF1E1E24) : const Color(0xFFF0F0F5);
    final shadowColor = isDark ? Colors.black : Colors.grey.shade500;
    final lightShadowColor = isDark ? Colors.grey.shade800 : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D2D3A);
    final accentColor =
        isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);

    final cardColor =
        isDark ? const Color(0xFF2A2A36) : const Color(0xFFFFFFFF);

    // Status bar rengini arka plan ile eşle
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeumorphicCircle(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      color: accentColor,
                      strokeWidth: 3,
                    ),
                  ),
                  backgroundColor: backgroundColor,
                  shadowColor: shadowColor,
                  lightShadowColor: lightShadowColor,
                ),
                const SizedBox(height: 24),
                Text(
                  'Veri işleniyor...',
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
                  const SizedBox(height: 40),
                  // Logo ve başlık
                  Row(
                    children: [
                      NeumorphicCircle(
                        child: Icon(
                          Icons.analytics,
                          color: accentColor,
                          size: 28,
                        ),
                        backgroundColor: backgroundColor,
                        shadowColor: shadowColor,
                        lightShadowColor: lightShadowColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Süreç Madenciliği',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'İş süreçlerinizi analiz edin',
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Tema değiştirme butonu
                      Transform.translate(
                        offset: const Offset(0, -14),
                        child: GestureDetector(
                          onTap: themeController.toggleTheme,
                          child: Obx(
                            () => NeumorphicCircle(
                              child: Icon(
                                themeController.isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                color: accentColor,
                                size: 18,
                              ),
                              backgroundColor: backgroundColor,
                              shadowColor: shadowColor,
                              lightShadowColor: lightShadowColor,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Ana bilgi kartı
                  NeumorphicContainer(
                    backgroundColor: backgroundColor,
                    shadowColor: shadowColor,
                    lightShadowColor: lightShadowColor,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Süreç verilerinizi analiz edin',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'CSV dosyalarındaki süreç verilerinizi yükleyin ve analiz edin. Aktivite frekanslarını, süreç akışlarını ve daha fazlasını keşfedin.',
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Hata mesajı
                  if (controller.error.value.isNotEmpty)
                    ErrorMessage(
                      errorText: controller.error.value,
                      isDark: isDark,
                    ),

                  // Sonuçlar veya işlem butonları
                  if (controller.hasData.value)
                    ResultsView(
                      controller: controller,
                      backgroundColor: backgroundColor,
                      shadowColor: shadowColor,
                      lightShadowColor: lightShadowColor,
                      textColor: textColor,
                      accentColor: accentColor,
                    )
                  else
                    ActionButtons(
                      controller: controller,
                      backgroundColor: backgroundColor,
                      shadowColor: shadowColor,
                      lightShadowColor: lightShadowColor,
                      textColor: textColor,
                      accentColor: accentColor,
                    ),

                  const SizedBox(height: 40),

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
