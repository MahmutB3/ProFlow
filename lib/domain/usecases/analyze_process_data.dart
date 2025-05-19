import 'package:surecproject/domain/entities/process_case.dart';
import 'package:surecproject/domain/entities/process_event.dart';
import 'package:surecproject/domain/repositories/process_repository.dart';

class AnalyzeProcessData {
  final ProcessRepository repository;

  AnalyzeProcessData(this.repository);

  Future<ProcessAnalysisResult> call(String filePath) async {
    final events = await repository.loadEventsFromCsv(filePath);
    final cases = repository.groupEventsByCaseId(events);
    final activityFrequencies = repository.getActivityFrequencies(events);
    final transitionFrequencies = repository.getTransitionFrequencies(cases);
    final averageDuration = repository.getAverageProcessDuration(cases);

    return ProcessAnalysisResult(
      events: events,
      cases: cases,
      activityFrequencies: activityFrequencies,
      transitionFrequencies: transitionFrequencies,
      averageDuration: averageDuration,
    );
  }
}

class ProcessAnalysisResult {
  final List<ProcessEvent> events;
  final List<ProcessCase> cases;
  final Map<String, int> activityFrequencies;
  final Map<String, int> transitionFrequencies;
  final Duration averageDuration;

  ProcessAnalysisResult({
    required this.events,
    required this.cases,
    required this.activityFrequencies,
    required this.transitionFrequencies,
    required this.averageDuration,
  });
}
