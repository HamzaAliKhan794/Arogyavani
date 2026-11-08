import 'user_role.dart';

class AuthState {
  final UserRole? role;
  final String? phoneNumber;
  final String? devTestOtp;
  final bool isAuthenticated;
  final String userName;
  final bool isLoading;
  final String? errorMessage;
  final int workflowStep; // 1: Symptoms, 2: Reports, 3: Summary, 4: Doctor

  const AuthState({
    this.role = UserRole.patient,
    this.phoneNumber,
    this.devTestOtp = '918957',
    this.isAuthenticated = false,
    this.userName = 'HAMZA',
    this.isLoading = false,
    this.errorMessage,
    this.workflowStep = 1,
  });

  AuthState copyWith({
    UserRole? role,
    String? phoneNumber,
    String? devTestOtp,
    bool? isAuthenticated,
    String? userName,
    bool? isLoading,
    String? errorMessage,
    int? workflowStep,
  }) {
    return AuthState(
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      devTestOtp: devTestOtp ?? this.devTestOtp,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      workflowStep: workflowStep ?? this.workflowStep,
    );
  }
}
