import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/views/splash_screen.dart';
import '../../features/auth/views/role_selection_screen.dart';
import '../../features/auth/views/doctor_portal_screen.dart';
import '../../features/auth/views/patient_portal_screen.dart';
import '../../features/auth/views/phone_auth_screen.dart';
import '../../features/auth/views/otp_verification_screen.dart';
import '../../features/dashboard/views/patient_dashboard_screen.dart';
import '../../features/doctor/views/doctor_dashboard_screen.dart';
import '../../features/clinical_summary/views/ai_scribe_processing_screen.dart';
import '../../features/clinical_summary/views/clinical_report_screen.dart';
import '../../features/records/views/medical_records_dashboard_screen.dart';
import '../../features/records/views/opd_visits_screen.dart';
import '../../features/records/views/lab_reports_screen.dart';
import '../../features/records/views/prescriptions_screen.dart';
import '../../features/records/views/medical_document_upload_screen.dart';
import '../../features/records/views/document_preview_screen.dart';
import '../../features/records/views/doctor_qr_screen.dart';
import '../../features/records/views/share_configuration_screen.dart';
import '../../features/records/views/share_access_status_screen.dart';
import '../../features/records/views/doctor_qr_scanner_screen.dart';
import '../../features/profile/views/patient_profile_screen.dart';
import '../../features/profile/views/edit_personal_info_screen.dart';
import '../../features/profile/views/patient_account_settings_screen.dart';
import '../../features/profile/views/notification_preferences_screen.dart';
import '../../features/profile/views/language_preferences_screen.dart';
import '../../features/profile/views/privacy_consent_screen.dart';
import '../../features/profile/views/help_support_screen.dart';
import '../../features/profile/views/doctor_profile_screen.dart';
import '../../features/profile/views/doctor_account_settings_screen.dart';
import '../../features/profile/views/doctor_consultation_preferences_screen.dart';
import '../../features/profile/views/doctor_notifications_screen.dart';
import '../../features/profile/views/doctor_help_support_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String roleSelection = '/role-selection';
  static const String doctorPortal = '/doctor-portal';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String patientPortal = '/patient-portal';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String patientDashboard = '/patient-dashboard';
  static const String aiScribe = '/ai-scribe';
  static const String clinicalReport = '/clinical-report';
  static const String medicalRecords = '/records';
  static const String opdVisitsHistory = '/records/opd-visits';
  static const String labReports = '/records/lab-reports';
  static const String prescriptionRecords = '/records/prescriptions';
  static const String medicalDocumentUpload = '/records/upload';
  static const String documentPreview = '/records/preview';
  static const String doctorQr = '/records/doctor-qr';
  static const String shareConfiguration = '/records/configure-share';
  static const String shareAccessStatus = '/records/access-status';
  static const String doctorQrScanner = '/doctor/scan-qr';
  static const String patientProfile = '/patient/profile';
  static const String patientEditProfile = '/patient/edit-profile';
  static const String patientSettings = '/patient/settings';
  static const String notificationPreferences = '/settings/notifications';
  static const String languagePreferences = '/settings/language';
  static const String privacyConsent = '/settings/privacy';
  static const String helpSupport = '/settings/help';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorSettings = '/doctor/settings';
  static const String doctorConsultationPreferences = '/doctor/consultation-preferences';
  static const String doctorNotifications = '/doctor/notifications';
  static const String doctorHelp = '/doctor/help';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorPortal,
        builder: (context, state) => const DoctorPortalScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorDashboard,
        builder: (context, state) => const DoctorDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientPortal,
        builder: (context, state) => const PatientPortalScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (context, state) {
          final isSignUp = state.uri.queryParameters['mode'] == 'signup';
          return PhoneAuthScreen(isSignUp: isSignUp);
        },
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientDashboard,
        builder: (context, state) => const PatientDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.aiScribe,
        builder: (context, state) => const AiScribeProcessingScreen(),
      ),
      GoRoute(
        path: AppRoutes.clinicalReport,
        builder: (context, state) => const ClinicalReportScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalRecords,
        builder: (context, state) => const MedicalRecordsDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.opdVisitsHistory,
        builder: (context, state) => const OpdVisitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.labReports,
        builder: (context, state) => const LabReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.prescriptionRecords,
        builder: (context, state) => const PrescriptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.medicalDocumentUpload,
        builder: (context, state) => const MedicalDocumentUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.documentPreview,
        builder: (context, state) => const DocumentPreviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorQr,
        builder: (context, state) => const DoctorQrScreen(),
      ),
      GoRoute(
        path: AppRoutes.shareConfiguration,
        builder: (context, state) => const ShareConfigurationScreen(),
      ),
      GoRoute(
        path: AppRoutes.shareAccessStatus,
        builder: (context, state) => const ShareAccessStatusScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorQrScanner,
        builder: (context, state) => const DoctorQrScannerScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientProfile,
        builder: (context, state) => const PatientProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientEditProfile,
        builder: (context, state) => const EditPersonalInfoScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientSettings,
        builder: (context, state) => const PatientAccountSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notificationPreferences,
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.languagePreferences,
        builder: (context, state) => const LanguagePreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyConsent,
        builder: (context, state) => const PrivacyConsentScreen(),
      ),
      GoRoute(
        path: AppRoutes.helpSupport,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorProfile,
        builder: (context, state) => const DoctorProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorSettings,
        builder: (context, state) => const DoctorAccountSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorConsultationPreferences,
        builder: (context, state) => const DoctorConsultationPreferencesScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorNotifications,
        builder: (context, state) => const DoctorNotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorHelp,
        builder: (context, state) => const DoctorHelpSupportScreen(),
      ),
    ],
  );
});
