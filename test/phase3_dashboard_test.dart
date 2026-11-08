import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/core/constants/app_strings.dart';
import 'package:arogyavani/features/dashboard/views/patient_dashboard_screen.dart';
import 'package:arogyavani/features/dashboard/widgets/dashboard_bottom_dock.dart';
import 'package:arogyavani/features/dashboard/widgets/hero_intake_card.dart';
import 'package:arogyavani/features/dashboard/widgets/quick_access_grid.dart';
import 'package:arogyavani/features/dashboard/widgets/clinical_workflow_tracker.dart';
import 'package:arogyavani/features/dashboard/widgets/explore_services_section.dart';

void main() {
  Widget createDashboardWidget() {
    return const ProviderScope(
      child: MaterialApp(
        home: PatientDashboardScreen(),
      ),
    );
  }

  testWidgets('Patient Dashboard renders all 8 core scope sections', (tester) async {
    await tester.pumpWidget(createDashboardWidget());
    await tester.pumpAndSettle();

    // 1. Header & Branding
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text('OPD'), findsOneWidget);
    expect(find.text('OPD Live'), findsOneWidget);
    expect(find.text('H'), findsOneWidget); // Patient Avatar Initial

    // 2. Personalised Welcome & ABHA
    expect(find.textContaining('HAMZA 👋'), findsOneWidget);
    expect(find.text(AppStrings.aiClinicalIntakeHub), findsOneWidget);
    expect(find.text(AppStrings.abhaReady), findsOneWidget);

    // 3. Hero Intake Card
    expect(find.byType(HeroIntakeCard), findsOneWidget);
    expect(find.text(AppStrings.talkToArogyavani), findsOneWidget);
    expect(find.text(AppStrings.startClinicalIntake), findsOneWidget);
    expect(find.text('AI CLINICAL INTAKE'), findsOneWidget);
    expect(find.text('SOAP Ready'), findsOneWidget);

    // 4. Quick Access Grid
    expect(find.byType(QuickAccessGrid), findsOneWidget);
    expect(find.text(AppStrings.opdVisits), findsOneWidget);
    expect(find.text(AppStrings.labReports), findsOneWidget);
    expect(find.text(AppStrings.rxRecords), findsOneWidget);
    expect(find.text(AppStrings.doctorQr), findsOneWidget);

    // 5. Clinical Workflow Tracker
    expect(find.byType(ClinicalWorkflowTracker), findsOneWidget);
    expect(find.text(AppStrings.stepSymptoms), findsOneWidget);
    expect(find.text(AppStrings.stepReports), findsOneWidget);
    expect(find.text(AppStrings.stepSummary), findsOneWidget);
    expect(find.text(AppStrings.stepDoctor), findsOneWidget);

    // 6. Explore Arogyavani Section
    expect(find.byType(ExploreServicesSection), findsOneWidget);
    expect(find.text('Explore Arogyavani'), findsOneWidget);
    expect(find.text('Find Doctors'), findsOneWidget);
    expect(find.text('Hospitals'), findsOneWidget);
    expect(find.text('Govt Schemes'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Emergency SOS'), findsOneWidget);
    expect(find.text('AI Assistant'), findsOneWidget);

    // 7. Fixed Bottom Navigation Dock with Center Mic
    expect(find.byType(DashboardBottomDock), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('OPD Queue'), findsOneWidget);
    expect(find.text('Records'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
    expect(find.byIcon(Icons.mic_rounded), findsWidgets);
  });

  testWidgets('Quick Access tiles open interactive modal sheets', (tester) async {
    await tester.pumpWidget(createDashboardWidget());
    await tester.pumpAndSettle();

    // Tap OPD Visits
    await tester.tap(find.text(AppStrings.opdVisits));
    await tester.pumpAndSettle();
    expect(find.text('Active OPD Consultation'), findsOneWidget);
    expect(find.text('#12'), findsOneWidget);
    await tester.tap(find.text('Got It'));
    await tester.pumpAndSettle();

    // Tap Doctor QR
    await tester.tap(find.text(AppStrings.doctorQr));
    await tester.pumpAndSettle();
    expect(find.text('Doctor Share QR Code'), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_2_rounded), findsOneWidget);
    await tester.tap(find.text('Close QR Code'));
    await tester.pumpAndSettle();

    // Tap Lab Reports
    await tester.tap(find.text(AppStrings.labReports));
    await tester.pumpAndSettle();
    expect(find.text('Recent Lab Reports'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Tap Rx Records
    await tester.tap(find.text(AppStrings.rxRecords));
    await tester.pumpAndSettle();
    expect(find.text('Prescription Records'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
  });

  testWidgets('ABHA status badge opens details modal', (tester) async {
    await tester.pumpWidget(createDashboardWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.abhaReady));
    await tester.pumpAndSettle();

    expect(find.text('ABHA Health ID'), findsOneWidget);
    expect(find.text('91-8842-1920-4491'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
  });

  testWidgets('Explore section collapses and expands properly', (tester) async {
    await tester.pumpWidget(createDashboardWidget());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Explore Arogyavani'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Find Doctors'), findsOneWidget);

    // Tap accordion header to collapse
    await tester.tap(find.text('Explore Arogyavani'));
    await tester.pumpAndSettle();
    expect(find.text('Find Doctors'), findsNothing);

    // Tap again to re-expand
    await tester.tap(find.text('Explore Arogyavani'));
    await tester.pumpAndSettle();
    expect(find.text('Find Doctors'), findsOneWidget);
  });

  testWidgets('Mic button triggers clinical voice intake bottom sheet', (tester) async {
    await tester.pumpWidget(createDashboardWidget());
    await tester.pumpAndSettle();

    // Tap Start Clinical Intake CTA
    await tester.tap(find.text(AppStrings.startClinicalIntake));
    await tester.pumpAndSettle();

    expect(find.text('Clinical Voice Intake'), findsOneWidget);
    expect(find.text('Speak naturally in Hindi, English, or Regional'), findsOneWidget);
    expect(find.text('SOAP AI'), findsOneWidget);
  });

  testWidgets('Responsive test: Dashboard renders on different mobile screen sizes without overflows', (tester) async {
    final sizes = [
      const Size(360, 640),  // Small Android
      const Size(390, 844),  // iPhone 14 / modern standard
      const Size(412, 915),  // Large Pixel
      const Size(768, 1024), // Tablet / Foldable
    ];

    for (final size in sizes) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createDashboardWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PatientDashboardScreen), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Render overflow on size $size');
    }

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
