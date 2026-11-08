import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voice_intake_state.dart';

class VoiceIntakeNotifier extends Notifier<VoiceIntakeState> {
  Timer? _recordingTimer;
  Timer? _playbackTimer;
  final Random _random = Random();

  @override
  VoiceIntakeState build() {
    ref.onDispose(() {
      _recordingTimer?.cancel();
      _playbackTimer?.cancel();
    });

    return const VoiceIntakeState();
  }

  void startRecording() {
    _playbackTimer?.cancel();
    _recordingTimer?.cancel();

    state = state.copyWith(
      status: IntakeRecordingStatus.recording,
      elapsedDuration: Duration.zero,
      playbackPosition: Duration.zero,
      amplitudes: [],
      errorMessage: null,
    );

    _recordingTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final newDuration = state.elapsedDuration + const Duration(milliseconds: 200);

      // Generate dynamic speech rhythm amplitude (between 0.15 and 0.95)
      final newAmp = 0.2 + (_random.nextDouble() * 0.75);
      final updatedAmplitudes = List<double>.from(state.amplitudes)..add(newAmp);
      if (updatedAmplitudes.length > 30) {
        updatedAmplitudes.removeAt(0);
      }

      state = state.copyWith(
        elapsedDuration: newDuration,
        amplitudes: updatedAmplitudes,
      );
    });
  }

  void stopRecording() {
    _recordingTimer?.cancel();

    // Ensure at least 6 seconds captured if stopped quickly to match screenshot #9/#10
    final duration = state.elapsedDuration.inSeconds < 6
        ? const Duration(seconds: 7)
        : state.elapsedDuration;

    state = state.copyWith(
      status: IntakeRecordingStatus.captured,
      elapsedDuration: duration,
      capturedAudioSample: 'intake_patient_hamza_001.m4a',
    );
  }

  void togglePlayback() {
    if (state.status.isPlaying) {
      _playbackTimer?.cancel();
      state = state.copyWith(status: IntakeRecordingStatus.captured);
    } else if (state.status.isCaptured) {
      state = state.copyWith(
        status: IntakeRecordingStatus.playing,
        playbackPosition: Duration.zero,
      );

      _playbackTimer?.cancel();
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        final newPos = state.playbackPosition + const Duration(milliseconds: 150);
        if (newPos >= state.elapsedDuration) {
          timer.cancel();
          state = state.copyWith(
            status: IntakeRecordingStatus.captured,
            playbackPosition: Duration.zero,
          );
        } else {
          state = state.copyWith(playbackPosition: newPos);
        }
      });
    }
  }

  void reRecord() {
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    state = const VoiceIntakeState();
  }

  void triggerError({String? message}) {
    _recordingTimer?.cancel();
    _playbackTimer?.cancel();
    state = state.copyWith(
      status: IntakeRecordingStatus.error,
      errorMessage: message ?? 'Could not start recording. Please try again.',
    );
  }
}

final voiceIntakeProvider = NotifierProvider<VoiceIntakeNotifier, VoiceIntakeState>(
  VoiceIntakeNotifier.new,
);
