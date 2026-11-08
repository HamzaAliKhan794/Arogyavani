import 'package:flutter/foundation.dart';

/// Categories of medical documents
enum DocumentCategory {
  labReport('Lab Report'),
  prescription('Prescription'),
  dischargeSummary('Discharge Summary'),
  scanOrXray('Scan / Imaging'),
  other('Other');

  final String label;
  const DocumentCategory(this.label);
}

/// An uploaded medical document (PDF, Scan, Image)
@immutable
class MedicalDocument {
  final String id;
  final String title;
  final DocumentCategory category;
  final String doctorOrLab;
  final String hospitalOrClinic;
  final DateTime documentDate;
  final DateTime uploadDate;
  final String fileSize;
  final String fileType; // PDF, JPG, PNG
  final List<String> tags;
  final String? localMockAsset; // Mock image or preview text
  final String? notes;

  const MedicalDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.doctorOrLab,
    required this.hospitalOrClinic,
    required this.documentDate,
    required this.uploadDate,
    required this.fileSize,
    required this.fileType,
    required this.tags,
    this.localMockAsset,
    this.notes,
  });

  MedicalDocument copyWith({
    String? id,
    String? title,
    DocumentCategory? category,
    String? doctorOrLab,
    String? hospitalOrClinic,
    DateTime? documentDate,
    DateTime? uploadDate,
    String? fileSize,
    String? fileType,
    List<String>? tags,
    String? localMockAsset,
    String? notes,
  }) {
    return MedicalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      doctorOrLab: doctorOrLab ?? this.doctorOrLab,
      hospitalOrClinic: hospitalOrClinic ?? this.hospitalOrClinic,
      documentDate: documentDate ?? this.documentDate,
      uploadDate: uploadDate ?? this.uploadDate,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      tags: tags ?? this.tags,
      localMockAsset: localMockAsset ?? this.localMockAsset,
      notes: notes ?? this.notes,
    );
  }
}

/// Status of an OPD Visit
enum OpdVisitStatus {
  inConsultation('In Consultation'),
  waitingInQueue('Waiting in Queue'),
  completed('Completed');

  final String label;
  const OpdVisitStatus(this.label);
}

/// OPD Visit Record
@immutable
class OpdVisit {
  final String id;
  final String tokenNumber;
  final String doctorName;
  final String specialty;
  final String clinicOrHospital;
  final DateTime visitDate;
  final String visitTime;
  final OpdVisitStatus status;
  final List<String> chiefComplaints;
  final String diagnosis;
  final int prescriptionsCount;
  final int labReportsCount;
  final bool soapSummaryAvailable;

  const OpdVisit({
    required this.id,
    required this.tokenNumber,
    required this.doctorName,
    required this.specialty,
    required this.clinicOrHospital,
    required this.visitDate,
    required this.visitTime,
    required this.status,
    required this.chiefComplaints,
    required this.diagnosis,
    this.prescriptionsCount = 0,
    this.labReportsCount = 0,
    this.soapSummaryAvailable = true,
  });
}

/// Lab Parameter line item
@immutable
class LabParameter {
  final String name;
  final String value;
  final String unit;
  final String referenceRange;
  final bool isAbnormal;

  const LabParameter({
    required this.name,
    required this.value,
    required this.unit,
    required this.referenceRange,
    this.isAbnormal = false,
  });
}

/// Status of a Lab Report
enum LabReportStatus {
  normal('Normal'),
  attentionNeeded('Attention Needed'),
  pending('Pending Analysis');

  final String label;
  const LabReportStatus(this.label);
}

/// Lab Report Record
@immutable
class LabReport {
  final String id;
  final String testName;
  final String testCategory; // Hematology, Biochemistry, Radiology
  final String labName;
  final DateTime testDate;
  final LabReportStatus status;
  final String resultSummary;
  final List<LabParameter> parameters;
  final String? doctorReferred;

  const LabReport({
    required this.id,
    required this.testName,
    required this.testCategory,
    required this.labName,
    required this.testDate,
    required this.status,
    required this.resultSummary,
    required this.parameters,
    this.doctorReferred,
  });
}

/// Individual medication item in a prescription
@immutable
class MedicationItem {
  final String name;
  final String dosage;
  final String frequency; // e.g. "1-0-1 (After Food)"
  final String duration; // e.g. "5 days"
  final String instructions;

  const MedicationItem({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });
}

/// Prescription Record
@immutable
class PrescriptionRecord {
  final String id;
  final String doctorName;
  final String specialty;
  final String clinicName;
  final DateTime prescribedDate;
  final DateTime validUntil;
  final String diagnosis;
  final List<MedicationItem> medications;
  final String doctorRegistrationNo;
  final bool isDigitallySigned;

  const PrescriptionRecord({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.clinicName,
    required this.prescribedDate,
    required this.validUntil,
    required this.diagnosis,
    required this.medications,
    required this.doctorRegistrationNo,
    this.isDigitallySigned = true,
  });
}

/// Audit log entry for doctor scan/access
@immutable
class AccessLogEntry {
  final String doctorName;
  final String departmentOrRoom;
  final DateTime accessedAt;
  final String action; // e.g. "Viewed SOAP Summary & Vitals"

  const AccessLogEntry({
    required this.doctorName,
    required this.departmentOrRoom,
    required this.accessedAt,
    required this.action,
  });
}

/// Share session state
enum ShareSessionStatus {
  active('Active · Awaiting Doctor Scan'),
  accessed('Accessed · Doctor Reviewing'),
  revoked('Revoked · Access Terminated'),
  expired('Expired');

  final String label;
  const ShareSessionStatus(this.label);
}

/// Doctor Sharing Session Configuration & State
@immutable
class DoctorShareSession {
  final String sessionId;
  final String tokenNumber;
  final String patientName;
  final String accessPin; // e.g. "AV-4892"
  final DateTime createdAt;
  final DateTime expiresAt;
  final ShareSessionStatus status;
  final Duration totalDuration;
  final bool shareSoapSummary;
  final bool shareChiefComplaints;
  final bool shareRecentVisits;
  final bool shareLabReports;
  final bool sharePrescriptions;
  final bool shareUploadedDocuments;
  final List<AccessLogEntry> accessLogs;

  const DoctorShareSession({
    required this.sessionId,
    required this.tokenNumber,
    required this.patientName,
    required this.accessPin,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    required this.totalDuration,
    this.shareSoapSummary = true,
    this.shareChiefComplaints = true,
    this.shareRecentVisits = true,
    this.shareLabReports = true,
    this.sharePrescriptions = true,
    this.shareUploadedDocuments = false,
    this.accessLogs = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt) || status == ShareSessionStatus.expired || status == ShareSessionStatus.revoked;

  Duration get remainingTime {
    final diff = expiresAt.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get formattedRemainingTime {
    final r = remainingTime;
    final m = r.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = r.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get qrPayload => 'arogyavani://session/$sessionId?pin=$accessPin&token=$tokenNumber';

  DoctorShareSession copyWith({
    String? sessionId,
    String? tokenNumber,
    String? patientName,
    String? accessPin,
    DateTime? createdAt,
    DateTime? expiresAt,
    ShareSessionStatus? status,
    Duration? totalDuration,
    bool? shareSoapSummary,
    bool? shareChiefComplaints,
    bool? shareRecentVisits,
    bool? shareLabReports,
    bool? sharePrescriptions,
    bool? shareUploadedDocuments,
    List<AccessLogEntry>? accessLogs,
  }) {
    return DoctorShareSession(
      sessionId: sessionId ?? this.sessionId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      patientName: patientName ?? this.patientName,
      accessPin: accessPin ?? this.accessPin,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      totalDuration: totalDuration ?? this.totalDuration,
      shareSoapSummary: shareSoapSummary ?? this.shareSoapSummary,
      shareChiefComplaints: shareChiefComplaints ?? this.shareChiefComplaints,
      shareRecentVisits: shareRecentVisits ?? this.shareRecentVisits,
      shareLabReports: shareLabReports ?? this.shareLabReports,
      sharePrescriptions: sharePrescriptions ?? this.sharePrescriptions,
      shareUploadedDocuments: shareUploadedDocuments ?? this.shareUploadedDocuments,
      accessLogs: accessLogs ?? this.accessLogs,
    );
  }
}
