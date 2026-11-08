import 'package:flutter/foundation.dart';

/// Patient Profile Entity
@immutable
class PatientProfile {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String email;
  final String gender;
  final DateTime dateOfBirth;
  final String bloodGroup;
  final String abhaId;
  final String abhaAddress;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String address;
  final List<String> knownAllergies;
  final List<String> chronicConditions;
  final double heightCm;
  final double weightKg;

  const PatientProfile({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.abhaId,
    required this.abhaAddress,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.address,
    required this.knownAllergies,
    required this.chronicConditions,
    this.heightCm = 175.0,
    this.weightKg = 68.0,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  PatientProfile copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    String? bloodGroup,
    String? abhaId,
    String? abhaAddress,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? address,
    List<String>? knownAllergies,
    List<String>? chronicConditions,
    double? heightCm,
    double? weightKg,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      abhaId: abhaId ?? this.abhaId,
      abhaAddress: abhaAddress ?? this.abhaAddress,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      address: address ?? this.address,
      knownAllergies: knownAllergies ?? this.knownAllergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}

/// Doctor Profile Entity
@immutable
class DoctorProfile {
  final String id;
  final String fullName;
  final String registrationNumber;
  final String specialty;
  final String qualifications;
  final String hospitalName;
  final String consultationRoom;
  final String opdTiming;
  final int yearsOfExperience;
  final String mobileNumber;
  final String email;
  final bool isSignatureVerified;

  const DoctorProfile({
    required this.id,
    required this.fullName,
    required this.registrationNumber,
    required this.specialty,
    required this.qualifications,
    required this.hospitalName,
    required this.consultationRoom,
    required this.opdTiming,
    required this.yearsOfExperience,
    required this.mobileNumber,
    required this.email,
    this.isSignatureVerified = true,
  });

  DoctorProfile copyWith({
    String? id,
    String? fullName,
    String? registrationNumber,
    String? specialty,
    String? qualifications,
    String? hospitalName,
    String? consultationRoom,
    String? opdTiming,
    int? yearsOfExperience,
    String? mobileNumber,
    String? email,
    bool? isSignatureVerified,
  }) {
    return DoctorProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      specialty: specialty ?? this.specialty,
      qualifications: qualifications ?? this.qualifications,
      hospitalName: hospitalName ?? this.hospitalName,
      consultationRoom: consultationRoom ?? this.consultationRoom,
      opdTiming: opdTiming ?? this.opdTiming,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      isSignatureVerified: isSignatureVerified ?? this.isSignatureVerified,
    );
  }
}

/// Patient Notification Preferences
@immutable
class NotificationPreferences {
  final bool queueTurnAlerts;
  final bool pillReminders;
  final bool labReportAlerts;
  final bool whatsappAlerts;
  final bool smsAlerts;
  final bool emailDigest;

  const NotificationPreferences({
    this.queueTurnAlerts = true,
    this.pillReminders = true,
    this.labReportAlerts = true,
    this.whatsappAlerts = false,
    this.smsAlerts = true,
    this.emailDigest = false,
  });

  NotificationPreferences copyWith({
    bool? queueTurnAlerts,
    bool? pillReminders,
    bool? labReportAlerts,
    bool? whatsappAlerts,
    bool? smsAlerts,
    bool? emailDigest,
  }) {
    return NotificationPreferences(
      queueTurnAlerts: queueTurnAlerts ?? this.queueTurnAlerts,
      pillReminders: pillReminders ?? this.pillReminders,
      labReportAlerts: labReportAlerts ?? this.labReportAlerts,
      whatsappAlerts: whatsappAlerts ?? this.whatsappAlerts,
      smsAlerts: smsAlerts ?? this.smsAlerts,
      emailDigest: emailDigest ?? this.emailDigest,
    );
  }
}

/// Language & Speech Preferences
@immutable
class LanguagePreferences {
  final String appLanguage; // English, Hindi, Kannada, Telugu, Tamil, Marathi
  final String voiceIntakeLanguage; // Hindi, English, Regional

  const LanguagePreferences({
    this.appLanguage = 'English',
    this.voiceIntakeLanguage = 'Hindi & English (Bilingual)',
  });

  LanguagePreferences copyWith({
    String? appLanguage,
    String? voiceIntakeLanguage,
  }) {
    return LanguagePreferences(
      appLanguage: appLanguage ?? this.appLanguage,
      voiceIntakeLanguage: voiceIntakeLanguage ?? this.voiceIntakeLanguage,
    );
  }
}

/// Privacy & Consent Settings
@immutable
class PrivacyConsentState {
  final bool abhaGatewayConsent;
  final bool aiVoiceProcessingConsent;
  final bool anonymizedResearchConsent;
  final bool autoRevokeDoctorQr;

  const PrivacyConsentState({
    this.abhaGatewayConsent = true,
    this.aiVoiceProcessingConsent = true,
    this.anonymizedResearchConsent = false,
    this.autoRevokeDoctorQr = true,
  });

  PrivacyConsentState copyWith({
    bool? abhaGatewayConsent,
    bool? aiVoiceProcessingConsent,
    bool? anonymizedResearchConsent,
    bool? autoRevokeDoctorQr,
  }) {
    return PrivacyConsentState(
      abhaGatewayConsent: abhaGatewayConsent ?? this.abhaGatewayConsent,
      aiVoiceProcessingConsent: aiVoiceProcessingConsent ?? this.aiVoiceProcessingConsent,
      anonymizedResearchConsent: anonymizedResearchConsent ?? this.anonymizedResearchConsent,
      autoRevokeDoctorQr: autoRevokeDoctorQr ?? this.autoRevokeDoctorQr,
    );
  }
}

/// Doctor Consultation Preferences
@immutable
class DoctorConsultationPreferences {
  final int consultationSlotMinutes; // 10, 15, 20
  final bool autoAdvanceQueue;
  final bool autoExpandSoapSummary;
  final bool playVoiceTranscript;
  final bool notifyEmergencyIntake;

  const DoctorConsultationPreferences({
    this.consultationSlotMinutes = 15,
    this.autoAdvanceQueue = false,
    this.autoExpandSoapSummary = true,
    this.playVoiceTranscript = true,
    this.notifyEmergencyIntake = true,
  });

  DoctorConsultationPreferences copyWith({
    int? consultationSlotMinutes,
    bool? autoAdvanceQueue,
    bool? autoExpandSoapSummary,
    bool? playVoiceTranscript,
    bool? notifyEmergencyIntake,
  }) {
    return DoctorConsultationPreferences(
      consultationSlotMinutes: consultationSlotMinutes ?? this.consultationSlotMinutes,
      autoAdvanceQueue: autoAdvanceQueue ?? this.autoAdvanceQueue,
      autoExpandSoapSummary: autoExpandSoapSummary ?? this.autoExpandSoapSummary,
      playVoiceTranscript: playVoiceTranscript ?? this.playVoiceTranscript,
      notifyEmergencyIntake: notifyEmergencyIntake ?? this.notifyEmergencyIntake,
    );
  }
}
