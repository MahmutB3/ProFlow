import 'package:surecproject/domain/entities/process_case.dart';
import 'package:surecproject/domain/entities/process_event.dart';

abstract class ProcessRepository {
  Future<List<ProcessEvent>> loadEventsFromCsv(String filePath);
  List<ProcessCase> groupEventsByCaseId(List<ProcessEvent> events);
  Map<String, int> getActivityFrequencies(List<ProcessEvent> events);
  Map<String, int> getTransitionFrequencies(List<ProcessCase> cases);
  Duration getAverageProcessDuration(List<ProcessCase> cases);
}
