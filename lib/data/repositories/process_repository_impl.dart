import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:surecproject/core/utils.dart';
import 'package:surecproject/domain/entities/process_case.dart';
import 'package:surecproject/domain/entities/process_event.dart';
import 'package:surecproject/domain/repositories/process_repository.dart';

class ProcessRepositoryImpl implements ProcessRepository {
  @override
  Future<List<ProcessEvent>> loadEventsFromCsv(String filePath) async {
    final file = File(filePath);
    return _loadEventsFromCsv(file);
  }

  Future<List<ProcessEvent>> _loadEventsFromCsv(File file) async {
    String csvString;

    // Try UTF-8 first
    try {
      csvString = await file.readAsString(encoding: utf8);
    } catch (e) {
      // If UTF-8 fails, try Latin-1 (ISO-8859-1)
      try {
        csvString = await file.readAsString(encoding: latin1);
      } catch (e) {
        // If Latin-1 fails too, try Windows-1252 encoding (common for Windows files)
        try {
          // Read as bytes and convert manually since dart:io doesn't have Windows-1252 codec
          final bytes = await file.readAsBytes();
          // This is a simplified approach - in real implementation you'd need a proper Windows-1252 decoder
          csvString = String.fromCharCodes(bytes);
        } catch (e) {
          throw Exception(
            'CSV dosyası okunamadı: Dosya kodlaması desteklenmiyor. Lütfen UTF-8 formatında bir dosya kullanın.',
          );
        }
      }
    }

    // Önce virgülle deneyeceğiz, hata alırsak veya sonuç anlamsızsa noktalı virgülle deneyeceğiz
    List<List<dynamic>> csvTable;
    bool usingSemicolon = false;

    // Virgül ile ayrılmış olarak dene
    csvTable = const CsvToListConverter().convert(csvString);

    // Eğer anlamsız sonuç elde edildiyse (tek sütun gibi) noktalı virgülle dene
    if (csvTable.isNotEmpty && csvTable[0].length <= 1) {
      // Noktalı virgül ile ayrılmış olarak dene
      csvTable = const CsvToListConverter(
        fieldDelimiter: ';',
      ).convert(csvString);
      usingSemicolon = true;
    }

    // Handle empty file
    if (csvTable.isEmpty) {
      throw Exception('CSV dosyası boş veya geçersiz format içeriyor.');
    }

    // Hala anlamsız veri varsa (tek sütun)
    if (csvTable[0].length <= 1) {
      throw Exception(
        'CSV dosyası geçersiz format içeriyor. Virgül (,) veya noktalı virgül (;) ile ayrılmış bir dosya kullanın.',
      );
    }

    // Assuming first row is header
    final headers = csvTable[0].map((e) => e.toString().trim()).toList();

    // Debugging
    print('Ayrıştırılan başlıklar: $headers');
    print('Ayırıcı: ${usingSemicolon ? "Noktalı Virgül (;)" : "Virgül (,)"}');

    // Find column indices - check for both normal and with quotes
    int caseIdIndex = headers.indexOf('Case ID');
    int activityIndex = headers.indexOf('Activity Name');
    int startTimeIndex = headers.indexOf('Start Time');
    int endTimeIndex = headers.indexOf('End Time');

    // Tırnak içindeki başlıkları da kontrol et
    if (caseIdIndex == -1) caseIdIndex = headers.indexOf('"Case ID"');
    if (activityIndex == -1) activityIndex = headers.indexOf('"Activity Name"');
    if (startTimeIndex == -1) startTimeIndex = headers.indexOf('"Start Time"');
    if (endTimeIndex == -1) endTimeIndex = headers.indexOf('"End Time"');

    // Benzer içerikleri kontrol et
    if (caseIdIndex == -1) {
      for (int i = 0; i < headers.length; i++) {
        final header = headers[i].toLowerCase();
        if (header.contains('case') && header.contains('id')) {
          caseIdIndex = i;
          break;
        }
      }
    }

    if (activityIndex == -1) {
      for (int i = 0; i < headers.length; i++) {
        final header = headers[i].toLowerCase();
        if ((header.contains('activity') && header.contains('name')) ||
            header.contains('aktivite') ||
            header.contains('işlem')) {
          activityIndex = i;
          break;
        }
      }
    }

    if (startTimeIndex == -1) {
      for (int i = 0; i < headers.length; i++) {
        final header = headers[i].toLowerCase();
        if (header.contains('start') || header.contains('başla')) {
          startTimeIndex = i;
          break;
        }
      }
    }

    if (endTimeIndex == -1) {
      for (int i = 0; i < headers.length; i++) {
        final header = headers[i].toLowerCase();
        if (header.contains('end') || header.contains('bit')) {
          endTimeIndex = i;
          break;
        }
      }
    }

    // Debugging
    print(
      'Bulunan sütun indeksleri: Case ID=$caseIdIndex, Activity=$activityIndex, Start=$startTimeIndex, End=$endTimeIndex',
    );

    // Validate required columns exist
    if (caseIdIndex == -1 ||
        activityIndex == -1 ||
        startTimeIndex == -1 ||
        endTimeIndex == -1) {
      throw Exception(
        'CSV dosyasında gerekli sütunlar bulunamadı. Gerekli sütunlar: Case ID, Activity Name, Start Time, End Time\n' +
            'Bulunan sütunlar: ${headers.join(", ")}',
      );
    }

    final events = <ProcessEvent>[];

    // Parse data rows (skip header)
    for (int i = 1; i < csvTable.length; i++) {
      final row = csvTable[i];

      // Skip empty rows
      if (row.isEmpty || row.length <= endTimeIndex) {
        continue;
      }

      try {
        final caseId = row[caseIdIndex].toString().replaceAll('"', '');
        final activity = row[activityIndex].toString().replaceAll('"', '');
        final startTime = Utils.parseDateTime(
          row[startTimeIndex].toString().replaceAll('"', ''),
        );
        final endTime = Utils.parseDateTime(
          row[endTimeIndex].toString().replaceAll('"', ''),
        );

        events.add(
          ProcessEvent(
            caseId: caseId,
            activityName: activity,
            startTime: startTime,
            endTime: endTime,
          ),
        );
      } catch (e) {
        // Skip invalid rows
        print('$i. CSV satırı ayrıştırılırken hata: $e');
      }
    }

    print('Toplam ayrıştırılan olay sayısı: ${events.length}');
    return events;
  }

  @override
  List<ProcessCase> groupEventsByCaseId(List<ProcessEvent> events) {
    final caseMap = <String, List<ProcessEvent>>{};

    // Group events by case ID
    for (final event in events) {
      if (!caseMap.containsKey(event.caseId)) {
        caseMap[event.caseId] = [];
      }
      caseMap[event.caseId]!.add(event);
    }

    // Create ProcessCase objects
    return caseMap.entries.map((entry) {
      return ProcessCase(caseId: entry.key, events: entry.value);
    }).toList();
  }

  @override
  Map<String, int> getActivityFrequencies(List<ProcessEvent> events) {
    final frequencies = <String, int>{};

    for (final event in events) {
      final activity = event.activityName;
      frequencies[activity] = (frequencies[activity] ?? 0) + 1;
    }

    return frequencies;
  }

  @override
  Map<String, int> getTransitionFrequencies(List<ProcessCase> cases) {
    final transitions = <String, int>{};

    for (final processCase in cases) {
      final activities = processCase.activitySequence;

      // Count transitions between consecutive activities
      for (int i = 0; i < activities.length - 1; i++) {
        final transitionKey = '${activities[i]} -> ${activities[i + 1]}';
        transitions[transitionKey] = (transitions[transitionKey] ?? 0) + 1;
      }
    }

    return transitions;
  }

  @override
  Duration getAverageProcessDuration(List<ProcessCase> cases) {
    if (cases.isEmpty) {
      return Duration.zero;
    }

    final totalMicroseconds = cases.fold<int>(
      0,
      (sum, processCase) => sum + processCase.duration.inMicroseconds,
    );

    return Duration(microseconds: totalMicroseconds ~/ cases.length);
  }
}
