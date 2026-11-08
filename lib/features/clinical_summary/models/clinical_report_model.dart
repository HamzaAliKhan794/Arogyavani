class ClinicalReportModel {
  final String tokenNumber;
  final String patientSpokenName;
  final int patientAge;
  final String registeredAccountName;
  final List<String> chiefComplaints;
  final String hpiNarrative;
  final String provisionalAssessment;
  final List<String> recommendedActions;
  final String originalTranscript;
  final String activeMedications;
  final String knownAllergies;
  final DateTime createdAt;

  const ClinicalReportModel({
    required this.tokenNumber,
    required this.patientSpokenName,
    required this.patientAge,
    required this.registeredAccountName,
    required this.chiefComplaints,
    required this.hpiNarrative,
    required this.provisionalAssessment,
    required this.recommendedActions,
    required this.originalTranscript,
    this.activeMedications = 'No active medications reported.',
    this.knownAllergies = 'No known drug or food allergies.',
    required this.createdAt,
  });

  /// Realistic sample reports matching screenshots 11, 12, 14
  factory ClinicalReportModel.sampleHamzali() {
    return ClinicalReportModel(
      tokenNumber: 'Token #12',
      patientSpokenName: 'Hamzali Khan',
      patientAge: 20,
      registeredAccountName: 'rajat',
      chiefComplaints: const [
        'Fever / Febrile illness',
        'Generalized body pain (Myalgia)',
      ],
      hpiNarrative:
          'Hamzali Khan, a 20-year-old, presents with Fever / Febrile illness, Generalized body pain (Myalgia) (onset duration not specified by patient). [Spoken Identity: Hamzali Khan, age 20; Registered Account: rajat] No prior chronic conditions reported. No known drug or food allergies.',
      provisionalAssessment:
          'Clinical presentation with Fever / Febrile illness, Generalized body pain (Myalgia).',
      recommendedActions: const [
        'Clinical examination including vitals (Temperature, BP, Pulse, SpO2).',
        'Provide symptomatic management per physician evaluation.',
      ],
      originalTranscript:
          '"My name is Hamzali Khan, I am 20 years old, I have high fever and body pain and I have Casio allergy."',
      knownAllergies: 'Reported contact sensitivity ("Casio allergy").',
      createdAt: DateTime.now(),
    );
  }

  factory ClinicalReportModel.sampleTavish() {
    return ClinicalReportModel(
      tokenNumber: 'Token #13',
      patientSpokenName: 'Tavish Khan',
      patientAge: 20,
      registeredAccountName: 'rajesh',
      chiefComplaints: const [
        'Headache',
        'Abdominal pain / Stomach ache',
        'Leg pain',
      ],
      hpiNarrative:
          'Tavish Khan, a 20-year-old, presents with Headache, Abdominal pain / Stomach ache, Leg pain lasting for approximately 10 days. [Spoken Identity: Tavish Khan, age 20; Registered Account: rajesh] No prior chronic conditions reported. No active medications reported. No known drug or food allergies.',
      provisionalAssessment:
          'Clinical presentation with Headache, Abdominal pain / Stomach ache, Leg pain.',
      recommendedActions: const [
        'Clinical examination including vitals (Temperature, BP, Pulse, SpO2).',
        'Physical examination of affected extremity (mobility, tenderness, range of motion).',
        'Evaluate headache triggers, hydration, and neurological status.',
        'Provide symptomatic management per physician evaluation.',
      ],
      originalTranscript:
          '"Hello, my name is Tavish Khan. I am 20 years old. I have leg pain, a headache and also stomach pain from last 10 days. That\'s all."',
      createdAt: DateTime.now(),
    );
  }

  factory ClinicalReportModel.sampleCristiano() {
    return ClinicalReportModel(
      tokenNumber: 'Token #14',
      patientSpokenName: 'Cristiano Ronaldo',
      patientAge: 15,
      registeredAccountName: 'ronaldo',
      chiefComplaints: const [
        'Cough / Respiratory',
        'Leg pain',
        'Headache',
      ],
      hpiNarrative:
          'Cristiano Ronaldo, a 15-year-old, presents with Cough, Leg pain, and Headache. [Spoken Identity: Cristiano Ronaldo, age 15; Registered Account: ronaldo] No prior chronic conditions reported. No active medications reported. No known drug or food allergies.',
      provisionalAssessment:
          'Clinical presentation with Cough, Leg pain, Headache.',
      recommendedActions: const [
        'Clinical examination including vitals (Temperature, BP, Pulse, SpO2).',
        'Physical examination of affected extremity (mobility, tenderness, range of motion).',
        'Respiratory examination and chest auscultation.',
        'Provide symptomatic management per physician evaluation.',
      ],
      originalTranscript:
          '"Hello, my name is Cristiano Ronaldo and I am 15 years old and I have coughs, a little pain in my leg and also a head ache."',
      createdAt: DateTime.now(),
    );
  }
}
