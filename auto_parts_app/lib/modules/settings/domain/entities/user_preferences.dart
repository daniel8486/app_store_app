class UserPreferences {
  final String userId;

  // Notification settings
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;

  // Privacy settings
  final bool showProfile;
  final bool showPurchaseHistory;
  final bool allowNewsletters;

  // App settings
  final bool darkMode;
  final String language; // 'pt_BR', 'en', etc
  final String theme; // 'light', 'dark', 'auto'

  // Data settings
  final DateTime lastUpdated;

  const UserPreferences({
    required this.userId,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.showProfile = true,
    this.showPurchaseHistory = false,
    this.allowNewsletters = true,
    this.darkMode = false,
    this.language = 'pt_BR',
    this.theme = 'auto',
    required this.lastUpdated,
  });

  UserPreferences copyWith({
    String? userId,
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? showProfile,
    bool? showPurchaseHistory,
    bool? allowNewsletters,
    bool? darkMode,
    String? language,
    String? theme,
    DateTime? lastUpdated,
  }) {
    return UserPreferences(
      userId: userId ?? this.userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      showProfile: showProfile ?? this.showProfile,
      showPurchaseHistory: showPurchaseHistory ?? this.showPurchaseHistory,
      allowNewsletters: allowNewsletters ?? this.allowNewsletters,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
