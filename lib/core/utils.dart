import 'package:intl/intl.dart';

class Utils {
  static DateTime parseDateTime(String dateTimeStr) {
    // Temizleme: Gereksiz karakterleri (tırnak, boşluk vb.) temizle
    dateTimeStr = dateTimeStr.trim().replaceAll('"', '');

    try {
      // Try standard ISO format
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      try {
        // Try common date time formats
        final formats = [
          'yyyy-MM-dd HH:mm:ss',
          'dd/MM/yyyy HH:mm:ss',
          'MM/dd/yyyy HH:mm:ss',
          'yyyy/MM/dd HH:mm:ss',
          'dd.MM.yyyy HH:mm:ss', // Türkçe formatta tarih
          'dd-MM-yyyy HH:mm:ss',
          'dd-MM-yyyy HH:mm',
          'dd/MM/yyyy HH:mm',
          'yyyy-MM-dd HH:mm',
        ];

        for (final format in formats) {
          try {
            return DateFormat(format).parse(dateTimeStr);
          } catch (e) {
            // Continue trying other formats
          }
        }

        // Eğer saati olmayan bir format varsa, saat ekleyip tekrar dene
        if (!dateTimeStr.contains(':')) {
          try {
            // Eğer sadece tarih kısmı varsa, saat ekleyip dene
            final onlyDateFormats = [
              'yyyy-MM-dd',
              'dd/MM/yyyy',
              'MM/dd/yyyy',
              'yyyy/MM/dd',
              'dd.MM.yyyy',
              'dd-MM-yyyy',
            ];

            for (final format in onlyDateFormats) {
              try {
                // Saat 00:00:00 olarak varsayalım
                return DateFormat(format).parse(dateTimeStr);
              } catch (e) {
                // Continue trying other formats
              }
            }
          } catch (e) {
            // Diğer formatlara devam et
          }
        }

        // Debugging: Tarih biçiminde sorun varsa detayları göster
        print(
          'Tarih ayrıştırılamadı: "$dateTimeStr". Desteklenen formatlar: $formats',
        );

        // If all formats fail, throw error
        throw FormatException('Tarih biçimi ayrıştırılamadı: $dateTimeStr');
      } catch (e) {
        throw FormatException('Tarih biçimi ayrıştırılamadı: $dateTimeStr');
      }
    }
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
