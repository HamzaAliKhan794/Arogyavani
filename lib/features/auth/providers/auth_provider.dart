import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_role.dart';

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void selectRole(UserRole role) {
    state = state.copyWith(role: role, errorMessage: null);
  }

  Future<bool> sendOtp(String phone) async {
    if (phone.trim().length < 10) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid 10-digit mobile number.',
      );
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));
    state = state.copyWith(
      isLoading: false,
      phoneNumber: phone.trim(),
      devTestOtp: '918957',
      errorMessage: null,
    );
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    if (otp.trim().length != 6) {
      state = state.copyWith(
        errorMessage: 'Please enter the 6-digit verification code.',
      );
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    if (otp.trim() == state.devTestOtp || otp.trim() == '123456') {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid code. Click the development code above to auto-fill.',
      );
      return false;
    }
  }

  void setWorkflowStep(int step) {
    state = state.copyWith(workflowStep: step);
  }

  void signOut() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
