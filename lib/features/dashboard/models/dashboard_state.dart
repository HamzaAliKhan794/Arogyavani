class DashboardState {
  final int activeTab; // 0: Home, 1: OPD Queue, 2: Records, 3: Account
  final int currentWorkflowStep; // 1: Symptoms, 2: Reports, 3: Summary, 4: Doctor
  final bool isExploreExpanded;
  final String greeting;
  final String userName;
  final String tokenNumber;
  final bool isAbhaConnected;

  const DashboardState({
    this.activeTab = 0,
    this.currentWorkflowStep = 1,
    this.isExploreExpanded = true,
    this.greeting = 'Good afternoon',
    this.userName = 'HAMZA',
    this.tokenNumber = 'Token #12',
    this.isAbhaConnected = true,
  });

  DashboardState copyWith({
    int? activeTab,
    int? currentWorkflowStep,
    bool? isExploreExpanded,
    String? greeting,
    String? userName,
    String? tokenNumber,
    bool? isAbhaConnected,
  }) {
    return DashboardState(
      activeTab: activeTab ?? this.activeTab,
      currentWorkflowStep: currentWorkflowStep ?? this.currentWorkflowStep,
      isExploreExpanded: isExploreExpanded ?? this.isExploreExpanded,
      greeting: greeting ?? this.greeting,
      userName: userName ?? this.userName,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      isAbhaConnected: isAbhaConnected ?? this.isAbhaConnected,
    );
  }
}
