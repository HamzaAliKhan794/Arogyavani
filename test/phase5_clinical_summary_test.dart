import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/main.dart';
import 'package:arogyavani/core/constants/app_strings.dart';
import 'package:arogyavani/features/clinical_summary/views/ai_scribe_processing_screen.dart';
import 'package:arogyavani/features/clinical_summary/views/clinical_report_screen.dart';
import 'package:arogyavani/features/clinical_summary/widgets/clinical_plan_card.dart';
import 'package:arogyavani/features/clinical_summary/widgets/expandable_transcript_card.dart';
import 'package:arogyavani/features/voice_intake/widgets/mic_record_button.dart';

void main() {
  testWidgets('AI Scribe processing screen renders checklist & progresses (Image 13)', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AiScribeProcessingScreen(),
        ),
      ),
    );

    // Initial Processing View
    expect(find.text('AI Medical Scribe Active'), findsOneWidget);
    expect(find.textContaining('Faster-Whisper is translating'), findsOneWidget);
    expect(find.text('1. Audio Upload Received'), findsOneWidget);
    expect(find.text('2. Faster-Whisper Speech-to-Text'), findsOneWidget);
    expect(find.text('3. Structuring Chief Complaints & Allergies'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // Advance 800ms -> Step 1 completed
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.byIcon(Icons.check_rounded), findsAtLeastNWidgets(1));

    // Advance 900ms -> Step 2 completed
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.byIcon(Icons.check_rounded), findsAtLeastNWidgets(2));

    // Advance 900ms -> Step 3 completed
    await tester.pump(const Duration(milliseconds: 900));
  });

  testWidgets('Clinical report screen renders all clinical SOAP sections (Images 11, 12, 14)', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ClinicalReportScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Header & Token
    expect(find.text('Doctor-Ready Clinical Report'), findsOneWidget);
    expect(find.text('Token #12'), findsOneWidget);

    // 2. Physician Disclaimer Banner
    expect(find.textContaining('Informational AI Summary · Requires Physician Review'), findsOneWidget);

    // 3. Chief Complaints Chips
    expect(find.text('Fever / Febrile illness'), findsOneWidget);
    expect(find.text('Generalized body pain (Myalgia)'), findsOneWidget);

    // 4. History of Present Illness (HPI)
    expect(find.text('History of Present Illness (HPI):'), findsOneWidget);
    expect(find.textContaining('Hamzali Khan, a 20-year-old'), findsOneWidget);
    expect(find.textContaining('[Spoken Identity: Hamzali Khan'), findsOneWidget);

    // 5. A & P Clinical Plan Card
    expect(find.byType(ClinicalPlanCard), findsOneWidget);
    expect(find.text('Provisional Assessment:'), findsOneWidget);
    expect(find.text('Recommended Clinical Actions:'), findsOneWidget);

    // 6. Expandable Transcript
    expect(find.byType(ExpandableTranscriptCard), findsOneWidget);
    expect(find.text('Original Spoken Transcript'), findsOneWidget);
    expect(find.textContaining('Hamzali Khan'), findsWidgets);

    // 7. Sticky Footer Action
    expect(find.text('Done & Return to Dashboard'), findsOneWidget);
  });

  testWidgets('Transcript card collapses and expands on tap', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ClinicalReportScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('My name is Hamzali Khan'), findsOneWidget);

    // Tap to collapse
    await tester.tap(find.text('Original Spoken Transcript'));
    await tester.pumpAndSettle();
    expect(find.textContaining('My name is Hamzali Khan'), findsNothing);

    // Tap again to re-expand
    await tester.tap(find.text('Original Spoken Transcript'));
    await tester.pumpAndSettle();
    expect(find.textContaining('My name is Hamzali Khan'), findsOneWidget);
  });

  testWidgets('Complete end-to-end clinical journey from Voice Intake to Report and Return', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: ArogyavaniApp(),
      ),
    );

    // Bypass splash
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    // Select Patient role
    await tester.tap(find.text(AppStrings.imPatient));
    await tester.pumpAndSettle();

    // Select Sign In
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pumpAndSettle();

    // Get Verification Code
    await tester.tap(find.text(AppStrings.getVerificationCode));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Auto-fill test OTP and continue
    await tester.tap(find.text('918957'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // On Dashboard: tap Start Clinical Intake
    expect(find.text(AppStrings.startClinicalIntake), findsOneWidget);
    await tester.tap(find.text(AppStrings.startClinicalIntake));
    await tester.pumpAndSettle();

    // Voice intake sheet open: start recording
    expect(find.text('Clinical Voice Intake'), findsOneWidget);
    await tester.tap(find.byType(MicRecordButton));
    await tester.pump(const Duration(seconds: 2));

    // Stop recording -> Captured state
    await tester.tap(find.byType(MicRecordButton));
    await tester.pumpAndSettle();
    expect(find.text('Generate Doctor-Ready Report'), findsOneWidget);

    // Submit -> AI Scribe Processing Screen
    await tester.tap(find.text('Generate Doctor-Ready Report'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('AI Medical Scribe Active'), findsOneWidget);

    // Let pipeline complete (2.5s)
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Doctor-Ready Clinical Report reached!
    expect(find.text('Doctor-Ready Clinical Report'), findsOneWidget);
    expect(find.text('Token #12'), findsOneWidget);

    // Tap Done & Return to Dashboard
    await tester.tap(find.text('Done & Return to Dashboard'));
    await tester.pumpAndSettle();

    // Back on Dashboard with updated workflow
    expect(find.text(AppStrings.talkToArogyavani), findsOneWidget);
  });
}
