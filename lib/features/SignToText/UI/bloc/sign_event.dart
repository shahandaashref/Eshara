abstract class SignEvent {}

class StartRecordingEvent extends SignEvent {}

class StopRecordingEvent extends SignEvent {
  final String videoPath;
  StopRecordingEvent({required this.videoPath});
}

class CancelRecordingEvent extends SignEvent {}

class ResetEvent extends SignEvent {}
