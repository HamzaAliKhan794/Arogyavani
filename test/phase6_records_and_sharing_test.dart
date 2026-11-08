import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arogyavani/features/records/views/medical_records_dashboard_screen.dart';
import 'package:arogyavani/features/records/views/opd_visits_screen.dart';
import 'package:arogyavani/features/records/views/lab_reports_screen.dart';
import 'package:arogyavani/features/records/views/prescriptions_screen.dart';
import 'package:arogyavani/features/records/views/medical_document_upload_screen.dart';
import 'package:arogyavani/features/records/views/document_preview_screen.dart';
import 'package:arogyavani/features/records/views/doctor_qr_screen.dart';
import 'package:arogyavani/features/records/views/share_configuration_screen.dart';
import 'package:arogyavani/features/records/views/share_access_status_screen.dart';
import 'package:arogyavani/features/records/views/doctor_qr_scanner_screen.dart';
import 'package:arogyavani/features/records/widgets/qr_code_display.dart';
import 'package:arogyavani/features/records/widgets/camera_scan_viewfinder.dart';

void main() {
  testWidgets('1. Medical records dashboard renders overview, categories, and records', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MedicalRecordsDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Header
    expect(find.text('Medical Records'), findsOneWidget);
    expect(find.textContaining('Arogyavani Health Vault'), findsOneWidget);

    // Verify Quick Action Buttons
    expect(find.text('Upload Document'), findsOneWidget);
    expect(find.text('Doctor QR'), findsOneWidget);

    // Verify Category Tabs
    expect(find.text('All'), findsOneWidget);
    expect(find.text('OPD Visits'), findsOneWidget);
    expect(find.text('Lab Reports'), findsOneWidget);
    expect(find.text('Prescriptions'), findsOneWidget);
    expect(find.text('Uploaded Docs'), findsOneWidget);

    // Verify Content presence
    expect(find.text('Dr. Rajesh Sharma'), findsWidgets);
    expect(find.text('Complete Blood Count (CBC)'), findsOneWidget);

    // Filter to Prescriptions category tab
    await tester.tap(find.text('Prescriptions'));
    await tester.pumpAndSettle();
    expect(find.text('Digital Prescriptions'), findsOneWidget);
  });

  testWidgets('2. OPD visits history screen renders visits with status filter', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OpdVisitsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('OPD Visits History'), findsOneWidget);
    expect(find.text('Dr. Rajesh Sharma'), findsOneWidget);
    expect(find.text('Dr. Priya Nair'), findsOneWidget);
    expect(find.text('Dr. Arvind Swamy'), findsOneWidget);

    // Tap "Completed" filter chip specifically
    await tester.tap(find.widgetWithText(FilterChip, 'Completed'));
    await tester.pumpAndSettle();

    // In consultation visit should not be in Completed list
    expect(find.text('Dr. Priya Nair'), findsOneWidget);
    expect(find.text('Dr. Arvind Swamy'), findsOneWidget);
  });

  testWidgets('3. Lab reports screen renders tests and normal/abnormal parameter tags', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LabReportsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lab & Diagnostic Reports'), findsOneWidget);
    expect(find.text('Complete Blood Count (CBC)'), findsOneWidget);
    expect(find.text('Lipid Profile Comprehensive'), findsOneWidget);
    expect(find.text('Normal'), findsWidgets);
    expect(find.text('Attention Needed'), findsWidgets);
  });

  testWidgets('4. Prescription records screen renders digital prescriptions', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: PrescriptionsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prescription Records'), findsOneWidget);
    expect(find.text('Dr. Rajesh Sharma'), findsOneWidget);
    expect(find.text('Verified Rx'), findsWidgets);
    expect(find.text('Paracetamol 650mg Tablet'), findsOneWidget);
    expect(find.text('Set Reminder'), findsWidgets);
  });

  testWidgets('5. Medical document upload screen provides source options & samples', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MedicalDocumentUploadScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Upload Medical Document'), findsOneWidget);
    expect(find.text('Browse Files (PDF / Document)'), findsOneWidget);
    expect(find.text('Scan Document with Camera'), findsOneWidget);
    expect(find.text('Select from Photo Gallery'), findsOneWidget);
    expect(find.text('Test with Sample Clinical Documents'), findsOneWidget);
  });

  testWidgets('6. Document preview screen allows categorization & metadata saving', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DocumentPreviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Document Preview & Category'), findsOneWidget);
    expect(find.text('Select Document Category:'), findsOneWidget);
    expect(find.text('Lab Report'), findsWidgets);
    expect(find.text('Prescription'), findsWidgets);
    expect(find.text('Save to Health Records'), findsOneWidget);
  });

  testWidgets('7. Doctor QR screen renders QR code display, PIN and countdown timer', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DoctorQrScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doctor Access Pass'), findsOneWidget);
    expect(find.byType(QrCodeDisplay), findsOneWidget);
    expect(find.textContaining('Doctor Access PIN:'), findsOneWidget);
    expect(find.text('AV-4892'), findsOneWidget);
    expect(find.text('Customize Data'), findsOneWidget);
    expect(find.text('Access Logs'), findsOneWidget);
  });

  testWidgets('8. Share configuration screen allows toggling permissions & duration', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ShareConfigurationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Configure Doctor Access'), findsOneWidget);
    expect(find.text('AI Clinical Voice SOAP Summary'), findsOneWidget);
    expect(find.text('Chief Complaints & Known Allergies'), findsOneWidget);
    expect(find.text('15 Minutes'), findsOneWidget);
    expect(find.text('1 Hour'), findsOneWidget);
    expect(find.text('Update & Generate Secure QR Pass'), findsOneWidget);
  });

  testWidgets('9. Share access status screen displays real-time countdown & audit trail', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ShareAccessStatusScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Access Status & Audit Log'), findsOneWidget);
    expect(find.text('Session Status'), findsOneWidget);
    expect(find.text('+15 Mins'), findsOneWidget);
    expect(find.text('Revoke Now'), findsOneWidget);
    expect(find.text('Access Audit Trail:'), findsOneWidget);
  });

  testWidgets('10. Doctor QR scanner screen renders camera viewfinder & decrypts records', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DoctorQrScannerScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Doctor Optical Scanner'), findsOneWidget);
    expect(find.byType(CameraScanViewfinder), findsOneWidget);
    expect(find.text('Enter 6-Digit PIN'), findsOneWidget);
    expect(find.text('Simulate Scan: HAMZALI KHAN (Token #12)'), findsOneWidget);

    // Tap Simulated Doctor Scan
    await tester.tap(find.text('Simulate Scan: HAMZALI KHAN (Token #12)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Decrypted Patient Modal appears
    expect(find.text('HAMZALI KHAN'), findsOneWidget);
    expect(find.text('Token #12'), findsOneWidget);
    expect(find.textContaining('Decrypted Health Record'), findsOneWidget);
    expect(find.text('Open Full Doctor-Ready Clinical Report'), findsOneWidget);
  });
}
