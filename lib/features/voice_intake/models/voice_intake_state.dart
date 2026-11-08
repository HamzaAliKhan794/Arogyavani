enum IntakeRecordingStatus {
  initial,
  recording,
  captured,
  playing,
  error;

  bool get isInitial => this == IntakeRecordingStatus.initial;
  bool get isRecording => this == IntakeRecordingStatus.recording;
  bool get isCaptured => this == IntakeRecordingStatus.captured;
  bool get isPlaying => this == IntakeRecordingStatus.playing;
  bool get isError => this == IntakeRecordingStatus.error;
}

class VoiceIntakeState {
  final IntakeRecordingStatus status;
  final Duration elapsedDuration;
  final Duration playbackPosition;
  final List<double> amplitudes;
  final String? errorMessage;
  final String? capturedAudioSample;

  const VoiceIntakeState({
    this.status = IntakeRecordingStatus.initial,
    this.elapsedDuration = Duration.zero,
    this.playbackPosition = Duration.zero,
    this.amplitudes = const [],
    this.errorMessage,
    this.capturedAudioSample,
  });

  String get formattedTimer {
    final minutes = elapsedDuration.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsedDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  VoiceIntakeState copyWith({
    IntakeRecordingStatus? status,
    Duration? elapsedDuration,
    Duration? playbackPosition,
    List<double>? amplitudes,
    String? errorMessage,
    String? capturedAudioSample,
  }) {
    return VoiceIntakeState(
      status: status ?? this.status,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      playbackPosition: playbackPosition ?? this.playbackPosition,
      amplitudes: amplitudes ?? this.amplitudes,
      errorMessage: errorMessage,
      capturedAudioSample: capturedAudioSample ?? this.capturedAudioSample,
    );
  }
}
