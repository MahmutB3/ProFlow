import 'dart:io';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surecproject/domain/entities/process_case.dart';
import 'package:surecproject/domain/entities/process_event.dart';
import 'package:surecproject/domain/usecases/analyze_process_data.dart';

class ProcessController extends GetxController {
  final AnalyzeProcessData analyzeProcessData;

  ProcessController({required this.analyzeProcessData});

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool hasData = false.obs;
  final RxString filePath = ''.obs;
  final RxString fileName = ''.obs;
  final RxString error = ''.obs;

  // Analysis results
  final Rx<List<ProcessEvent>> events = Rx<List<ProcessEvent>>([]);
  final Rx<List<ProcessCase>> cases = Rx<List<ProcessCase>>([]);
  final Rx<Map<String, int>> activityFrequencies = Rx<Map<String, int>>({});
  final Rx<Map<String, int>> transitionFrequencies = Rx<Map<String, int>>({});
  final Rx<Duration> averageDuration = Rx<Duration>(Duration.zero);

  // Computed values for UI
  List<MapEntry<String, int>> get sortedActivityFrequencies =>
      activityFrequencies.value.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

  List<MapEntry<String, int>> get sortedTransitionFrequencies =>
      transitionFrequencies.value.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

  Future<void> pickAndAnalyzeCsvFile() async {
    try {
      const csvTypeGroup = XTypeGroup(
        label: 'CSV',
        extensions: <String>['csv'],
      );

      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[csvTypeGroup],
      );

      if (file != null) {
        final path = file.path;
        final name =
            path.split('/').last.split('\\').last; // Handle both path formats

        filePath.value = path;
        fileName.value = name;

        await analyzeCsvFile(path);
      }
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> analyzeCsvFile(String path) async {
    try {
      isLoading.value = true;
      error.value = '';

      final result = await analyzeProcessData(path);

      events.value = result.events;
      cases.value = result.cases;
      activityFrequencies.value = result.activityFrequencies;
      transitionFrequencies.value = result.transitionFrequencies;
      averageDuration.value = result.averageDuration;

      hasData.value = true;
    } catch (e) {
      error.value = 'Dosya analiz edilirken hata oluştu: ${e.toString()}';
      hasData.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSampleDataFromAssets() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Load the sample data from assets
      final data = await rootBundle.loadString(
        'assets/sample_process_data.csv',
      );

      // Create a temporary file to store the data
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/sample_process_data.csv');
      await tempFile.writeAsString(data);

      final path = tempFile.path;
      filePath.value = path;
      fileName.value = 'sample_process_data.csv';

      await analyzeCsvFile(path);
    } catch (e) {
      error.value = 'Örnek veri yüklenirken hata oluştu: ${e.toString()}';
      hasData.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
