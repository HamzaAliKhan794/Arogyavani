import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arogyavani/core/theme/app_theme.dart';
import 'package:arogyavani/core/widgets/global_state_views.dart';
import 'package:arogyavani/features/profile/views/patient_profile_screen.dart';
import 'package:arogyavani/features/profile/views/edit_personal_info_screen.dart';
import 'package:arogyavani/features/profile/views/patient_account_settings_screen.dart';
import 'package:arogyavani/features/profile/views/notification_preferences_screen.dart';
import 'package:arogyavani/features/profile/views/language_preferences_screen.dart';
import 'package:arogyavani/features/profile/views/privacy_consent_screen.dart';
import 'package:arogyavani/features/profile/views/help_support_screen.dart';
import 'package:arogyavani/features/profile/views/doctor_profile_screen.dart';
import 'package:arogyavani/features/profile/views/doctor_account_settings_screen.dart';
import 'package:arogyavani/features/profile/views/doctor_consultation_preferences_screen.dart';
import 'package:arogyavani/features/profile/views/doctor_notifications_screen.dart';
import 'package:arogyavani/features/profile/views/doctor_help_support_screen.dart';

Widget _createTestWidget(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: child,
    ),
  );
}

void main() {
  group('Phase 7: Patient Profile & Settings Tests', () {
    testWidgets('1. PatientProfileScreen renders identity, ABHA card, vitals and navigation items', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const PatientProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('My Health Profile'), findsOneWidget);
      expect(find.text('HAMZALI KHAN'), findsOneWidget);
      expect(find.text('ABHA Ready'), findsOneWidget);
      expect(find.textContaining('91-8842-1920-4921'), findsOneWidget);
      expect(find.text('Blood Group'), findsOneWidget);
      expect(find.text('Height'), findsOneWidget);
      expect(find.text('Weight'), findsOneWidget);
      expect(find.text('Edit Personal Information'), findsOneWidget);
      expect(find.text('Account Settings & ABHA'), findsOneWidget);
      expect(find.text('Sign Out of Arogyavani'), findsOneWidget);
    });

    testWidgets('2. EditPersonalInfoScreen renders form fields and validates save', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const EditPersonalInfoScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Edit Personal Information'), findsOneWidget);
      expect(find.text('Full Name (as per Aadhaar / ABHA)'), findsOneWidget);
      expect(find.text('Save Profile Changes'), findsOneWidget);

      await tester.tap(find.text('Save Profile Changes'));
      await tester.pumpAndSettle();

      expect(find.text('Personal profile information updated successfully!'), findsOneWidget);
    });

    testWidgets('3. PatientAccountSettingsScreen renders mobile number, ABHA and security controls', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const PatientAccountSettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Account Settings'), findsOneWidget);
      expect(find.text('+91 9955739705'), findsOneWidget);
      expect(find.text('Biometric / Screen Lock'), findsOneWidget);
      expect(find.text('Two-Factor Vault Protection'), findsOneWidget);
    });

    testWidgets('4. NotificationPreferencesScreen renders notification categories and toggles', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const NotificationPreferencesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Notification Preferences'), findsOneWidget);
      expect(find.text('OPD Queue Turn Alerts'), findsOneWidget);
      expect(find.text('Pill & Medication Reminders'), findsOneWidget);
      expect(find.text('Lab Report Ready Notifications'), findsOneWidget);
    });

    testWidgets('5. LanguagePreferencesScreen renders UI and voice language options', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const LanguagePreferencesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Language Preferences'), findsOneWidget);
      expect(find.text('App Display Language'), findsOneWidget);
      expect(find.text('English'), findsWidgets);
      expect(find.text('Hindi'), findsWidgets);
      expect(find.text('Clinical Voice Intake Language'), findsOneWidget);
    });

    testWidgets('6. PrivacyConsentScreen renders ABDM consent, data download, and revocations', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const PrivacyConsentScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Privacy & Consent'), findsOneWidget);
      expect(find.text('ABDM Health Information Exchange (HIE)'), findsOneWidget);
      expect(find.text('AI Clinical Voice Scribe Processing'), findsOneWidget);
      expect(find.text('Download My Health Archive (JSON / FHIR)'), findsOneWidget);
    });

    testWidgets('7. HelpSupportScreen renders national helplines, FAQs, and ticket form', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const HelpSupportScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('24/7 National Emergency Helplines'), findsOneWidget);
      expect(find.text('1075'), findsOneWidget);
      expect(find.text('108'), findsOneWidget);
      expect(find.text('Frequently Asked Questions'), findsOneWidget);
      expect(find.text('Submit Support Request'), findsOneWidget);
    });
  });

  group('Phase 7: Doctor Profile & Preferences Tests', () {
    testWidgets('8. DoctorProfileScreen renders physician credentials, hospital schedule, and room', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const DoctorProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Clinical Profile'), findsOneWidget);
      expect(find.text('Dr. Rajesh Sharma, MD'), findsOneWidget);
      expect(find.textContaining('MCI-88421-DEL'), findsOneWidget);
      expect(find.text('Room 4'), findsOneWidget);
      expect(find.textContaining('Digital Prescription Certificate: Active'), findsOneWidget);
    });

    testWidgets('9. DoctorAccountSettingsScreen renders hospital affiliation and clinic controls', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const DoctorAccountSettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Account Settings'), findsOneWidget);
      expect(find.text('Current OPD Clinic Affiliation'), findsOneWidget);
      expect(find.text('Request Desk Change'), findsOneWidget);
    });

    testWidgets('10. DoctorConsultationPreferencesScreen renders slot pacing and SOAP toggles', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const DoctorConsultationPreferencesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Consultation Preferences'), findsOneWidget);
      expect(find.text('Consultation Slot Pacing'), findsOneWidget);
      expect(find.text('15 Minutes Per Patient'), findsOneWidget);
      expect(find.text('Clinical AI SOAP Display'), findsOneWidget);
      expect(find.text('Auto-Expand SOAP Summary'), findsOneWidget);
    });

    testWidgets('11. DoctorNotificationsScreen renders critical lab alerts and emergency triage', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const DoctorNotificationsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Notification Settings'), findsOneWidget);
      expect(find.text('Critical Abnormal Lab Alerts (STAT)'), findsOneWidget);
      expect(find.text('Emergency Triaging Alert'), findsOneWidget);
    });

    testWidgets('12. DoctorHelpSupportScreen renders optical scanner troubleshooting and physician hotline', (tester) async {
      tester.view.physicalSize = const Size(800, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_createTestWidget(const DoctorHelpSupportScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Doctor Clinical Guide'), findsOneWidget);
      expect(find.text('How do I scan the patient\'s clinical QR pass?'), findsOneWidget);
      expect(find.textContaining('+91 800-DOCTOR-AG'), findsOneWidget);
    });
  });

  group('Phase 7: Global State Views & Confirmation Dialogs', () {
    testWidgets('13. ArogyavaniEmptyState and ArogyavaniErrorView render properly with action buttons', (tester) async {
      bool retryClicked = false;
      await tester.pumpWidget(_createTestWidget(
        Scaffold(
          body: ArogyavaniErrorView(
            message: 'Unable to reach clinical vault.',
            onRetry: () => retryClicked = true,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Unable to reach clinical vault.'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();
      expect(retryClicked, isTrue);
    });

    testWidgets('14. LogoutConfirmationDialog renders confirmation actions', (tester) async {
      await tester.pumpWidget(_createTestWidget(
        Scaffold(
          body: LogoutConfirmationDialog(onConfirmLogout: () {}),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Sign Out'), findsWidgets);
    });
  });
}
