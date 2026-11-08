import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_state.dart';

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    return DashboardState(
      greeting: _calculateGreeting(),
    );
  }

  static String _calculateGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  void setActiveTab(int tab) {
    state = state.copyWith(activeTab: tab);
  }

  void setWorkflowStep(int step) {
    state = state.copyWith(currentWorkflowStep: step);
  }

  void toggleExploreExpanded() {
    state = state.copyWith(isExploreExpanded: !state.isExploreExpanded);
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);
