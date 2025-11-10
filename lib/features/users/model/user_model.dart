class Profile {
  final String id;
  final String name;
  final bool onboardingComplete;

  Profile({
    required this.id,
    required this.name,
    required this.onboardingComplete,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] ?? '',
      onboardingComplete: json['onboarding'] as bool? ?? false,
    );
  }
}