import 'package:surecproject/domain/entities/process_event.dart';

class ProcessCase {
  final String caseId;
  final List<ProcessEvent> events;

  ProcessCase({required this.caseId, required this.events});

  DateTime get startTime =>
      events.map((e) => e.startTime).reduce((a, b) => a.isBefore(b) ? a : b);

  DateTime get endTime =>
      events.map((e) => e.endTime).reduce((a, b) => a.isAfter(b) ? a : b);

  Duration get duration => endTime.difference(startTime);

  List<String> get activitySequence {
    final sortedEvents = List<ProcessEvent>.from(events)
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
    return sortedEvents.map((e) => e.activityName).toList();
  }
}
