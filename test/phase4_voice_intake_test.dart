import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/features/voice_intake/views/clinical_voice_intake_sheet.dart';
import 'package:arogyavani/features/voice_intake/providers/voice_intake_provider.dart';
import 'package:arogyavani/features/voice_intake/widgets/audio_waveform_visualizer.dart';
import 'package:arogyavani/features/voice_intake/widgets/mic_record_button.dart';

void main() {
  Widget createIntakeSheetWidget(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        home: Scaffold(
          body: ClinicalVoiceIntakeSheet(),
        ),
      ),
    );
  }

  testWidgets('Voice intake sheet renders all initial components (Image 8)', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(createIntakeSheetWidget(container));
    await tester.pumpAndSettle();

    // 1. Heading & Subtitles
    expect(find.text('Clinical Voice Intake'), findsOneWidget);
    expect(find.text('Speak naturally in Hindi, English, or Regional'), findsOneWidget);
    expect(find.text('SOAP AI'), findsOneWidget);

    // 2. Initial Timer & Instruction
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Tap microphone below to start speaking'), findsOneWidget);

    // 3. Waveform & Mic Button
    expect(find.byType(AudioWaveformVisualizer), findsOneWidget);
    expect(find.byType(MicRecordButton), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });

  testWidgets('Recording flow: Initial -> Recording -> Captured -> Re-record (Images 8, 9, 10)', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(createIntakeSheetWidget(container));
    await tester.pumpAndSettle();

    // 1. Tap mic to start recording
    await tester.tap(find.byType(MicRecordButton));
    await tester.pump(const Duration(milliseconds: 300));

    expect(container.read(voiceIntakeProvider).status.isRecording, isTrue);
    expect(find.textContaining('Listening...'), findsOneWidget);
    expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

    // Advance 2 seconds
    await tester.pump(const Duration(seconds: 2));

    // 2. Tap to stop recording -> Captured state (Image 9 & 10)
    await tester.tap(find.byType(MicRecordButton));
    await tester.pumpAndSettle();

    expect(container.read(voiceIntakeProvider).status.isCaptured, isTrue);
    expect(find.text('Recording captured. Preview or submit.'), findsOneWidget);
    expect(find.text('Re-record'), findsOneWidget);
    expect(find.text('Play Recording'), findsOneWidget);
    expect(find.text('Generate Doctor-Ready Report'), findsOneWidget);

    // 3. Test Playback preview
    await tester.tap(find.text('Play Recording'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Pause Preview'), findsOneWidget);

    await tester.tap(find.text('Pause Preview'));
    await tester.pumpAndSettle();
    expect(find.text('Play Recording'), findsOneWidget);

    // 4. Test Re-record
    await tester.tap(find.text('Re-record'));
    await tester.pumpAndSettle();

    expect(container.read(voiceIntakeProvider).status.isInitial, isTrue);
    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('Tap microphone below to start speaking'), findsOneWidget);
  });

  testWidgets('Error state renders coral alert banner (Image 8)', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(createIntakeSheetWidget(container));
    await tester.pumpAndSettle();

    // Trigger simulated error
    container.read(voiceIntakeProvider.notifier).triggerError(
      message: 'Could not start recording. Please try again.',
    );
    await tester.pumpAndSettle();

    expect(find.text('Could not start recording. Please try again.'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });
}
