import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';

@immutable
class ProfileState {
  final PatientProfile patientProfile;
  final DoctorProfile doctorProfile;
  final NotificationPreferences notificationPreferences;
  final LanguagePreferences languagePreferences;
  final PrivacyConsentState privacyConsent;
  final DoctorConsultationPreferences doctorPreferences;

  const ProfileState({
    required this.patientProfile,
    required this.doctorProfile,
    required this.notificationPreferences,
    required this.languagePreferences,
    required this.privacyConsent,
    required this.doctorPreferences,
  });

  ProfileState copyWith({
    PatientProfile? patientProfile,
    DoctorProfile? doctorProfile,
    NotificationPreferences? notificationPreferences,
    LanguagePreferences? languagePreferences,
    PrivacyConsentState? privacyConsent,
    DoctorConsultationPreferences? doctorPreferences,
  }) {
    return ProfileState(
      patientProfile: patientProfile ?? this.patientProfile,
      doctorProfile: doctorProfile ?? this.doctorProfile,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
      languagePreferences: languagePreferences ?? this.languagePreferences,
      privacyConsent: privacyConsent ?? this.privacyConsent,
      doctorPreferences: doctorPreferences ?? this.doctorPreferences,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState(
      patientProfile: _defaultPatient,
      doctorProfile: _defaultDoctor,
      notificationPreferences: const NotificationPreferences(),
      languagePreferences: const LanguagePreferences(),
      privacyConsent: const PrivacyConsentState(),
      doctorPreferences: const DoctorConsultationPreferences(),
    );
  }

  // --- Patient Updates ---
  void updatePatientProfile({
    String? fullName,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    double? heightCm,
    double? weightKg,
  }) {
    state = state.copyWith(
      patientProfile: state.patientProfile.copyWith(
        fullName: fullName,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
        bloodGroup: bloodGroup,
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
        address: address,
        heightCm: heightCm,
        weightKg: weightKg,
      ),
    );
  }

  // --- Doctor Updates ---
  void updateDoctorProfile({
    String? fullName,
    String? qualifications,
    String? hospitalName,
    String? consultationRoom,
    String? opdTiming,
    String? mobileNumber,
    String? email,
  }) {
    state = state.copyWith(
      doctorProfile: state.doctorProfile.copyWith(
        fullName: fullName,
        qualifications: qualifications,
        hospitalName: hospitalName,
        consultationRoom: consultationRoom,
        opdTiming: opdTiming,
        mobileNumber: mobileNumber,
        email: email,
      ),
    );
  }

  // --- Notifications ---
  void updateNotificationPreferences({
    bool? queueTurnAlerts,
    bool? pillReminders,
    bool? labReportAlerts,
    bool? whatsappAlerts,
    bool? smsAlerts,
    bool? emailDigest,
  }) {
    state = state.copyWith(
      notificationPreferences: state.notificationPreferences.copyWith(
        queueTurnAlerts: queueTurnAlerts,
        pillReminders: pillReminders,
        labReportAlerts: labReportAlerts,
        whatsappAlerts: whatsappAlerts,
        smsAlerts: smsAlerts,
        emailDigest: emailDigest,
      ),
    );
  }

  // --- Language Preferences ---
  void setAppLanguage(String language) {
    state = state.copyWith(
      languagePreferences: state.languagePreferences.copyWith(appLanguage: language),
    );
  }

  void setVoiceLanguage(String language) {
    state = state.copyWith(
      languagePreferences: state.languagePreferences.copyWith(voiceIntakeLanguage: language),
    );
  }

  // --- Privacy & Consent ---
  void updatePrivacyConsent({
    bool? abhaGatewayConsent,
    bool? aiVoiceProcessingConsent,
    bool? anonymizedResearchConsent,
    bool? autoRevokeDoctorQr,
  }) {
    state = state.copyWith(
      privacyConsent: state.privacyConsent.copyWith(
        abhaGatewayConsent: abhaGatewayConsent,
        aiVoiceProcessingConsent: aiVoiceProcessingConsent,
        anonymizedResearchConsent: anonymizedResearchConsent,
        autoRevokeDoctorQr: autoRevokeDoctorQr,
      ),
    );
  }

  // --- Doctor Preferences ---
  void updateDoctorPreferences({
    int? consultationSlotMinutes,
    bool? autoAdvanceQueue,
    bool? autoExpandSoapSummary,
    bool? playVoiceTranscript,
    bool? notifyEmergencyIntake,
  }) {
    state = state.copyWith(
      doctorPreferences: state.doctorPreferences.copyWith(
        consultationSlotMinutes: consultationSlotMinutes,
        autoAdvanceQueue: autoAdvanceQueue,
        autoExpandSoapSummary: autoExpandSoapSummary,
        playVoiceTranscript: playVoiceTranscript,
        notifyEmergencyIntake: notifyEmergencyIntake,
      ),
    );
  }

  static final PatientProfile _defaultPatient = PatientProfile(
    id: 'PAT-9955-01',
    fullName: 'HAMZALI KHAN',
    mobileNumber: '+91 9955739705',
    email: 'hamzali.khan@example.com',
    gender: 'Male',
    dateOfBirth: DateTime(2004, 8, 15),
    bloodGroup: 'O+',
    abhaId: '91-8842-1920-4921',
    abhaAddress: 'hamza@abdm',
    emergencyContactName: 'Fatima Khan (Mother)',
    emergencyContactPhone: '+91 9845012345',
    address: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru - 560103',
    knownAllergies: const ['Casio allergy', 'Penicillin sensitivity'],
    chronicConditions: const ['None reported'],
    heightCm: 175.0,
    weightKg: 68.0,
  );

  static const DoctorProfile _defaultDoctor = DoctorProfile(
    id: 'DOC-8842-01',
    fullName: 'Dr. Rajesh Sharma, MD',
    registrationNumber: 'MCI-88421-DEL',
    specialty: 'General Medicine & Diabetology',
    qualifications: 'MBBS, MD (Medicine), Fellowship in Clinical Diabetology',
    hospitalName: 'Arogyavani OPD Care · Apollo Health City',
    consultationRoom: 'Room 4, First Floor (OPD Complex)',
    opdTiming: 'Mon - Sat: 09:00 AM - 02:00 PM',
    yearsOfExperience: 14,
    mobileNumber: '+91 9811234567',
    email: 'dr.sharma@arogyavani.in',
    isSignatureVerified: true,
  );
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
