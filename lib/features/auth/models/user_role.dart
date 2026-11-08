enum UserRole {
  patient,
  doctor;

  String get displayName {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.doctor:
        return 'Doctor';
    }
  }
}
