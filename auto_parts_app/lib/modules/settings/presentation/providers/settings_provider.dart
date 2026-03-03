import 'package:riverpod/riverpod.dart';
import '../../../settings/domain/entities/user_preferences.dart';

// Mock default preferences
final _defaultPreferences = UserPreferences(
  userId: 'current_user',
  pushNotifications: true,
  emailNotifications: true,
  smsNotifications: false,
  showProfile: true,
  showPurchaseHistory: false,
  allowNewsletters: true,
  darkMode: false,
  language: 'pt_BR',
  theme: 'auto',
  lastUpdated: DateTime.now(),
);

// Get user preferences
final userPreferencesProvider =
    StateNotifierProvider<UserPreferencesNotifier, UserPreferences>(
  (ref) => UserPreferencesNotifier(_defaultPreferences),
);

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier(UserPreferences initialState) : super(initialState);

  void updatePushNotifications(bool value) {
    state = state.copyWith(
      pushNotifications: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateEmailNotifications(bool value) {
    state = state.copyWith(
      emailNotifications: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateSmsNotifications(bool value) {
    state = state.copyWith(
      smsNotifications: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateShowProfile(bool value) {
    state = state.copyWith(
      showProfile: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateShowPurchaseHistory(bool value) {
    state = state.copyWith(
      showPurchaseHistory: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateAllowNewsletters(bool value) {
    state = state.copyWith(
      allowNewsletters: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateDarkMode(bool value) {
    state = state.copyWith(
      darkMode: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateLanguage(String value) {
    state = state.copyWith(
      language: value,
      lastUpdated: DateTime.now(),
    );
  }

  void updateTheme(String value) {
    state = state.copyWith(
      theme: value,
      darkMode: value == 'dark',
      lastUpdated: DateTime.now(),
    );
  }

  void resetToDefaults() {
    state = _defaultPreferences.copyWith(
      lastUpdated: DateTime.now(),
    );
  }
}
