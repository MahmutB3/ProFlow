class ProcessEvent {
  final String caseId;
  final String activityName;
  final DateTime startTime;
  final DateTime endTime;

  ProcessEvent({
    required this.caseId,
    required this.activityName,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}
