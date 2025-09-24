class AppLaunchState {
  const AppLaunchState({
    required this.showOnboarding,
    required this.isLoggedIn,
  });

  final bool showOnboarding;
  final bool isLoggedIn;

  bool get shouldShowLogin => !showOnboarding && !isLoggedIn;
}
