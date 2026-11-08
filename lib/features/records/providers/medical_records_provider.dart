import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_record_model.dart';

/// Draft document being prepared for upload
@immutable
class UploadDraft {
  final String title;
  final DocumentCategory category;
  final String doctorOrLab;
  final String hospitalOrClinic;
  final DateTime documentDate;
  final String fileName;
  final String fileType;
  final String fileSize;
  final List<String> tags;
  final String? notes;
  final bool isUploading;

  const UploadDraft({
    this.title = '',
    this.category = DocumentCategory.labReport,
    this.doctorOrLab = '',
    this.hospitalOrClinic = '',
    required this.documentDate,
    this.fileName = '',
    this.fileType = 'PDF',
    this.fileSize = '1.2 MB',
    this.tags = const [],
    this.notes,
    this.isUploading = false,
  });

  UploadDraft copyWith({
    String? title,
    DocumentCategory? category,
    String? doctorOrLab,
    String? hospitalOrClinic,
    DateTime? documentDate,
    String? fileName,
    String? fileType,
    String? fileSize,
    List<String>? tags,
    String? notes,
    bool? isUploading,
  }) {
    return UploadDraft(
      title: title ?? this.title,
      category: category ?? this.category,
      doctorOrLab: doctorOrLab ?? this.doctorOrLab,
      hospitalOrClinic: hospitalOrClinic ?? this.hospitalOrClinic,
      documentDate: documentDate ?? this.documentDate,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

/// Medical Records Master State
@immutable
class MedicalRecordsState {
  final List<OpdVisit> opdVisits;
  final List<LabReport> labReports;
  final List<PrescriptionRecord> prescriptions;
  final List<MedicalDocument> uploadedDocuments;
  final DoctorShareSession activeShareSession;
  final UploadDraft uploadDraft;
  final String selectedCategory; // "All", "Visits", "Labs", "Prescriptions", "Uploads"
  final String searchQuery;

  const MedicalRecordsState({
    required this.opdVisits,
    required this.labReports,
    required this.prescriptions,
    required this.uploadedDocuments,
    required this.activeShareSession,
    required this.uploadDraft,
    this.selectedCategory = 'All',
    this.searchQuery = '',
  });

  MedicalRecordsState copyWith({
    List<OpdVisit>? opdVisits,
    List<LabReport>? labReports,
    List<PrescriptionRecord>? prescriptions,
    List<MedicalDocument>? uploadedDocuments,
    DoctorShareSession? activeShareSession,
    UploadDraft? uploadDraft,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return MedicalRecordsState(
      opdVisits: opdVisits ?? this.opdVisits,
      labReports: labReports ?? this.labReports,
      prescriptions: prescriptions ?? this.prescriptions,
      uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      activeShareSession: activeShareSession ?? this.activeShareSession,
      uploadDraft: uploadDraft ?? this.uploadDraft,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MedicalRecordsNotifier extends Notifier<MedicalRecordsState> {
  Timer? _countdownTimer;

  @override
  MedicalRecordsState build() {
    ref.onDispose(() {
      _countdownTimer?.cancel();
    });
    _startTimer();
    return MedicalRecordsState(
      opdVisits: _initialVisits,
      labReports: _initialLabs,
      prescriptions: _initialPrescriptions,
      uploadedDocuments: _initialDocuments,
      activeShareSession: _createDefaultShareSession(),
      uploadDraft: UploadDraft(documentDate: DateTime.now()),
    );
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.activeShareSession.status == ShareSessionStatus.active ||
          state.activeShareSession.status == ShareSessionStatus.accessed) {
        if (state.activeShareSession.isExpired) {
          state = state.copyWith(
            activeShareSession: state.activeShareSession.copyWith(
              status: ShareSessionStatus.expired,
            ),
          );
        } else {
          // Trigger rebuild to update countdown display
          state = state.copyWith(
            activeShareSession: state.activeShareSession.copyWith(),
          );
        }
      }
    });
  }

  // --- Filtering & Searching ---
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // --- Document Upload Draft Operations ---
  void setDraftTitle(String title) {
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(title: title));
  }

  void setDraftCategory(DocumentCategory category) {
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(category: category));
  }

  void setDraftDoctor(String doctorOrLab) {
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(doctorOrLab: doctorOrLab));
  }

  void setDraftHospital(String hospital) {
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(hospitalOrClinic: hospital));
  }

  void setDraftDate(DateTime date) {
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(documentDate: date));
  }

  void addDraftTag(String tag) {
    if (!state.uploadDraft.tags.contains(tag)) {
      final updated = [...state.uploadDraft.tags, tag];
      state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(tags: updated));
    }
  }

  void removeDraftTag(String tag) {
    final updated = state.uploadDraft.tags.where((t) => t != tag).toList();
    state = state.copyWith(uploadDraft: state.uploadDraft.copyWith(tags: updated));
  }

  void pickSimulatedFile({
    required String fileName,
    required String fileType,
    required String fileSize,
    String? defaultTitle,
    DocumentCategory? defaultCategory,
  }) {
    state = state.copyWith(
      uploadDraft: state.uploadDraft.copyWith(
        fileName: fileName,
        fileType: fileType,
        fileSize: fileSize,
        title: defaultTitle ?? state.uploadDraft.title,
        category: defaultCategory ?? state.uploadDraft.category,
      ),
    );
  }

  /// Finalize saving draft to document records
  void saveDraftToRecords() {
    final draft = state.uploadDraft;
    final newDoc = MedicalDocument(
      id: 'DOC-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: draft.title.isNotEmpty ? draft.title : (draft.fileName.isNotEmpty ? draft.fileName : 'Uploaded Health Record'),
      category: draft.category,
      doctorOrLab: draft.doctorOrLab.isNotEmpty ? draft.doctorOrLab : 'Self Uploaded',
      hospitalOrClinic: draft.hospitalOrClinic.isNotEmpty ? draft.hospitalOrClinic : 'Arogyavani Vault',
      documentDate: draft.documentDate,
      uploadDate: DateTime.now(),
      fileSize: draft.fileSize,
      fileType: draft.fileType,
      tags: draft.tags.isNotEmpty ? draft.tags : ['#UploadedRecord'],
      notes: draft.notes,
    );

    state = state.copyWith(
      uploadedDocuments: [newDoc, ...state.uploadedDocuments],
      uploadDraft: UploadDraft(documentDate: DateTime.now()),
    );
  }

  // --- Doctor QR Sharing Operations ---
  void configureShareOptions({
    bool? shareSoapSummary,
    bool? shareChiefComplaints,
    bool? shareRecentVisits,
    bool? shareLabReports,
    bool? sharePrescriptions,
    bool? shareUploadedDocuments,
    Duration? duration,
  }) {
    final cur = state.activeShareSession;
    final total = duration ?? cur.totalDuration;
    final expires = DateTime.now().add(total);

    state = state.copyWith(
      activeShareSession: cur.copyWith(
        shareSoapSummary: shareSoapSummary ?? cur.shareSoapSummary,
        shareChiefComplaints: shareChiefComplaints ?? cur.shareChiefComplaints,
        shareRecentVisits: shareRecentVisits ?? cur.shareRecentVisits,
        shareLabReports: shareLabReports ?? cur.shareLabReports,
        sharePrescriptions: sharePrescriptions ?? cur.sharePrescriptions,
        shareUploadedDocuments: shareUploadedDocuments ?? cur.shareUploadedDocuments,
        totalDuration: total,
        expiresAt: expires,
        status: ShareSessionStatus.active,
      ),
    );
  }

  void extendSessionTime([Duration extension = const Duration(minutes: 15)]) {
    final cur = state.activeShareSession;
    final newExpiry = cur.expiresAt.add(extension);
    state = state.copyWith(
      activeShareSession: cur.copyWith(
        expiresAt: newExpiry,
        status: ShareSessionStatus.active,
      ),
    );
  }

  void revokeSession() {
    state = state.copyWith(
      activeShareSession: state.activeShareSession.copyWith(
        status: ShareSessionStatus.revoked,
      ),
    );
  }

  void resetShareSession() {
    state = state.copyWith(
      activeShareSession: _createDefaultShareSession(),
    );
  }

  /// Simulate a doctor scanning the QR code and accessing the report
  void simulateDoctorAccess({
    String doctorName = 'Dr. Rajesh Sharma, MD',
    String room = 'OPD Consultation Room 4',
  }) {
    final cur = state.activeShareSession;
    final newLog = AccessLogEntry(
      doctorName: doctorName,
      departmentOrRoom: room,
      accessedAt: DateTime.now(),
      action: 'Unlocked SOAP Intake Summary, Vitals & Recent Records',
    );

    state = state.copyWith(
      activeShareSession: cur.copyWith(
        status: ShareSessionStatus.accessed,
        accessLogs: [newLog, ...cur.accessLogs],
      ),
    );
  }

  // --- Initial Mock Data Factories ---
  static DoctorShareSession _createDefaultShareSession() {
    return DoctorShareSession(
      sessionId: 'SES-9955-4892',
      tokenNumber: 'Token #12',
      patientName: 'HAMZALI KHAN',
      accessPin: 'AV-4892',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      status: ShareSessionStatus.active,
      totalDuration: const Duration(minutes: 15),
      shareSoapSummary: true,
      shareChiefComplaints: true,
      shareRecentVisits: true,
      shareLabReports: true,
      sharePrescriptions: true,
      shareUploadedDocuments: false,
      accessLogs: [
        AccessLogEntry(
          doctorName: 'Dr. Rajesh Sharma, MD',
          departmentOrRoom: 'OPD Consultation Room 4',
          accessedAt: DateTime.now().subtract(const Duration(minutes: 2)),
          action: 'Scanned QR Code · Verified Patient Identity',
        ),
      ],
    );
  }

  static final List<OpdVisit> _initialVisits = [
    OpdVisit(
      id: 'OPD-1021',
      tokenNumber: 'Token #12',
      doctorName: 'Dr. Rajesh Sharma',
      specialty: 'MD, General Medicine',
      clinicOrHospital: 'Arogyavani OPD Care · Room 4',
      visitDate: DateTime.now(),
      visitTime: '10:30 AM',
      status: OpdVisitStatus.inConsultation,
      chiefComplaints: ['Fever / Febrile illness', 'Generalized body pain (Myalgia)'],
      diagnosis: 'Acute Viral Syndrome with Myalgia (Provisional)',
      prescriptionsCount: 3,
      labReportsCount: 2,
      soapSummaryAvailable: true,
    ),
    OpdVisit(
      id: 'OPD-1018',
      tokenNumber: 'Token #04',
      doctorName: 'Dr. Priya Nair',
      specialty: 'MD, DM Cardiology',
      clinicOrHospital: 'Fortis Escorts Heart Center',
      visitDate: DateTime.now().subtract(const Duration(days: 7)),
      visitTime: '04:15 PM',
      status: OpdVisitStatus.completed,
      chiefComplaints: ['Mild palpitation', 'Occasional dizziness'],
      diagnosis: 'Stage 1 Essential Hypertension (Controlled)',
      prescriptionsCount: 2,
      labReportsCount: 1,
      soapSummaryAvailable: true,
    ),
    OpdVisit(
      id: 'OPD-0982',
      tokenNumber: 'Token #89',
      doctorName: 'Dr. Arvind Swamy',
      specialty: 'MD Pulmonology',
      clinicOrHospital: 'Apollo Health City Clinic',
      visitDate: DateTime.now().subtract(const Duration(days: 35)),
      visitTime: '11:45 AM',
      status: OpdVisitStatus.completed,
      chiefComplaints: ['Persistent dry cough', 'Throat irritation'],
      diagnosis: 'Acute Bronchitis (Resolved)',
      prescriptionsCount: 2,
      labReportsCount: 1,
      soapSummaryAvailable: false,
    ),
  ];

  static final List<LabReport> _initialLabs = [
    LabReport(
      id: 'LAB-5541',
      testName: 'Complete Blood Count (CBC)',
      testCategory: 'Hematology',
      labName: 'Dr. Lal PathLabs · Central Diagnostic Hub',
      testDate: DateTime.now().subtract(const Duration(days: 1)),
      status: LabReportStatus.normal,
      resultSummary: 'All hematological parameters within normal clinical range. No leukocytosis.',
      doctorReferred: 'Dr. Rajesh Sharma',
      parameters: const [
        LabParameter(name: 'Hemoglobin', value: '13.5', unit: 'g/dL', referenceRange: '13.0 - 17.0', isAbnormal: false),
        LabParameter(name: 'Total Leucocyte Count (TLC)', value: '7,200', unit: '/mcL', referenceRange: '4,000 - 11,000', isAbnormal: false),
        LabParameter(name: 'Platelet Count', value: '245,000', unit: '/mcL', referenceRange: '150,000 - 450,000', isAbnormal: false),
        LabParameter(name: 'ESR (1st Hour)', value: '12', unit: 'mm/hr', referenceRange: '0 - 15', isAbnormal: false),
      ],
    ),
    LabReport(
      id: 'LAB-5489',
      testName: 'Lipid Profile Comprehensive',
      testCategory: 'Biochemistry',
      labName: 'Thyrocare Technologies',
      testDate: DateTime.now().subtract(const Duration(days: 8)),
      status: LabReportStatus.attentionNeeded,
      resultSummary: 'Mild hypercholesterolemia. Elevated Total Cholesterol and LDL fraction.',
      doctorReferred: 'Dr. Priya Nair',
      parameters: const [
        LabParameter(name: 'Total Cholesterol', value: '228', unit: 'mg/dL', referenceRange: '< 200', isAbnormal: true),
        LabParameter(name: 'LDL Cholesterol', value: '146', unit: 'mg/dL', referenceRange: '< 100', isAbnormal: true),
        LabParameter(name: 'HDL Cholesterol', value: '44', unit: 'mg/dL', referenceRange: '> 40', isAbnormal: false),
        LabParameter(name: 'Serum Triglycerides', value: '190', unit: 'mg/dL', referenceRange: '< 150', isAbnormal: true),
      ],
    ),
    LabReport(
      id: 'LAB-5321',
      testName: 'HbA1c & Fasting Plasma Glucose',
      testCategory: 'Diabetes Care',
      labName: 'Metropolis Healthcare',
      testDate: DateTime.now().subtract(const Duration(days: 20)),
      status: LabReportStatus.normal,
      resultSummary: 'Normoglycemic control. Average estimated blood glucose within target bounds.',
      doctorReferred: 'Dr. Rajesh Sharma',
      parameters: const [
        LabParameter(name: 'HbA1c (Glycated Hemoglobin)', value: '5.6', unit: '%', referenceRange: '< 5.7', isAbnormal: false),
        LabParameter(name: 'Fasting Plasma Glucose', value: '94', unit: 'mg/dL', referenceRange: '70 - 99', isAbnormal: false),
      ],
    ),
    LabReport(
      id: 'LAB-5198',
      testName: 'Chest X-Ray (PA View Digital)',
      testCategory: 'Radiology',
      labName: 'Apollo Imaging & Radiodiagnostics',
      testDate: DateTime.now().subtract(const Duration(days: 35)),
      status: LabReportStatus.normal,
      resultSummary: 'Clear bilateral lung fields. Cardiothoracic ratio within normal limits. Both CP angles clear.',
      doctorReferred: 'Dr. Arvind Swamy',
      parameters: const [
        LabParameter(name: 'Lung Parenchyma', value: 'Clear', unit: '-', referenceRange: 'Clear', isAbnormal: false),
        LabParameter(name: 'Cardiothoracic Ratio', value: '< 0.50', unit: '-', referenceRange: '< 0.50', isAbnormal: false),
        LabParameter(name: 'Costophrenic Angles', value: 'Sharp', unit: '-', referenceRange: 'Sharp', isAbnormal: false),
      ],
    ),
  ];

  static final List<PrescriptionRecord> _initialPrescriptions = [
    PrescriptionRecord(
      id: 'RX-9081',
      doctorName: 'Dr. Rajesh Sharma',
      specialty: 'MD, General Medicine',
      clinicName: 'Arogyavani OPD Care · Room 4',
      prescribedDate: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 7)),
      diagnosis: 'Acute Viral Syndrome with Myalgia',
      doctorRegistrationNo: 'MCI-88421-DEL',
      isDigitallySigned: true,
      medications: const [
        MedicationItem(
          name: 'Paracetamol 650mg Tablet',
          dosage: '1 tablet (650mg)',
          frequency: '1-0-1 (After Meals)',
          duration: '5 days',
          instructions: 'Take SOS for high fever exceeding 100°F and generalized body ache.',
        ),
        MedicationItem(
          name: 'Pantoprazole 40mg Tablet',
          dosage: '1 tablet (40mg)',
          frequency: '1-0-0 (Empty Stomach)',
          duration: '5 days',
          instructions: 'Take 30 minutes before breakfast with a glass of water.',
        ),
        MedicationItem(
          name: 'Cetirizine 10mg Tablet',
          dosage: '1 tablet (10mg)',
          frequency: '0-0-1 (Bedtime)',
          duration: '3 days',
          instructions: 'Take at night if throat irritation or nasal congestion persists.',
        ),
      ],
    ),
    PrescriptionRecord(
      id: 'RX-8842',
      doctorName: 'Dr. Priya Nair',
      specialty: 'MD, DM Cardiology',
      clinicName: 'Fortis Escorts Heart Center',
      prescribedDate: DateTime.now().subtract(const Duration(days: 7)),
      validUntil: DateTime.now().add(const Duration(days: 23)),
      diagnosis: 'Stage 1 Essential Hypertension & Dyslipidemia',
      doctorRegistrationNo: 'MCI-64219-MAH',
      isDigitallySigned: true,
      medications: const [
        MedicationItem(
          name: 'Telmisartan 40mg Tablet',
          dosage: '1 tablet (40mg)',
          frequency: '1-0-0 (Morning)',
          duration: '30 days',
          instructions: 'Maintain daily morning intake. Track weekly blood pressure logs.',
        ),
        MedicationItem(
          name: 'Atorvastatin 10mg Tablet',
          dosage: '1 tablet (10mg)',
          frequency: '0-0-1 (Night)',
          duration: '30 days',
          instructions: 'Take after dinner. Repeat lipid profile after 4 weeks.',
        ),
      ],
    ),
  ];

  static final List<MedicalDocument> _initialDocuments = [
    MedicalDocument(
      id: 'DOC-901',
      title: 'Blood Test Report - Lal PathLabs',
      category: DocumentCategory.labReport,
      doctorOrLab: 'Dr. Lal PathLabs',
      hospitalOrClinic: 'Indiranagar Diagnostics',
      documentDate: DateTime.now().subtract(const Duration(days: 1)),
      uploadDate: DateTime.now().subtract(const Duration(hours: 18)),
      fileSize: '1.4 MB',
      fileType: 'PDF',
      tags: const ['#BloodTest', '#CBC', '#Hematology'],
      notes: 'CBC routine screening for ongoing fever and body ache.',
    ),
    MedicalDocument(
      id: 'DOC-877',
      title: 'Chest X-Ray Digital Scan',
      category: DocumentCategory.scanOrXray,
      doctorOrLab: 'Apollo Radiodiagnostics',
      hospitalOrClinic: 'Apollo Health City',
      documentDate: DateTime.now().subtract(const Duration(days: 35)),
      uploadDate: DateTime.now().subtract(const Duration(days: 34)),
      fileSize: '3.2 MB',
      fileType: 'JPG',
      tags: const ['#ChestScan', '#XRay', '#Lungs'],
      notes: 'High-resolution digital radiography PA view.',
    ),
    MedicalDocument(
      id: 'DOC-842',
      title: 'Discharge Summary - City Hospital',
      category: DocumentCategory.dischargeSummary,
      doctorOrLab: 'Dr. Arvind Swamy',
      hospitalOrClinic: 'City Hospital Inpatient Unit',
      documentDate: DateTime.now().subtract(const Duration(days: 90)),
      uploadDate: DateTime.now().subtract(const Duration(days: 88)),
      fileSize: '2.1 MB',
      fileType: 'PDF',
      tags: const ['#Discharge', '#HospitalSummary', '#Inpatient'],
      notes: 'Full discharge record including discharge medications.',
    ),
  ];
}

final medicalRecordsProvider = NotifierProvider<MedicalRecordsNotifier, MedicalRecordsState>(() {
  return MedicalRecordsNotifier();
});
