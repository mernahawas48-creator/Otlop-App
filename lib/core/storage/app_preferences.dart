import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._();

  static SharedPreferences? _preferences;

  // ==================== KEYS ====================

  static const String _onboardingKey = 'onboarding_completed';

  static const String _profileImageKey = 'profile_image_path';

  static const String _firstNameKey = 'first_name';

  static const String _lastNameKey = 'last_name';

  static const String _emailKey = 'email';

  static const String _addressKey = 'address';

  // ==================== INIT ====================

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _prefs {
    if (_preferences == null) {
      throw Exception(
        'AppPreferences is not initialized. '
        'Call AppPreferences.init() first.',
      );
    }

    return _preferences!;
  }

  // ==================== ONBOARDING ====================

  static bool get hasSeenOnboarding {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // ==================== PROFILE IMAGE ====================

  static String? get profileImagePath {
    return _prefs.getString(_profileImageKey);
  }

  static Future<void> setProfileImagePath(String path) async {
    await _prefs.setString(_profileImageKey, path);
  }

  static Future<void> removeProfileImage() async {
    await _prefs.remove(_profileImageKey);
  }

  // ==================== USER DATA ====================

  static String get firstName {
    return _prefs.getString(_firstNameKey) ?? '';
  }

  static String get lastName {
    return _prefs.getString(_lastNameKey) ?? '';
  }

  static String get email {
    return _prefs.getString(_emailKey) ?? '';
  }

  static String get address {
    return _prefs.getString(_addressKey) ?? '';
  }

  static Future<void> saveUserData({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    await _prefs.setString(_firstNameKey, firstName);

    await _prefs.setString(_lastNameKey, lastName);

    await _prefs.setString(_emailKey, email);
  }

  static Future<void> setAddress(String address) async {
    await _prefs.setString(_addressKey, address);
  }

  // ==================== CLEAR USER DATA ====================

  static Future<void> clearUserData() async {
    await _prefs.remove(_firstNameKey);

    await _prefs.remove(_lastNameKey);

    await _prefs.remove(_emailKey);

    await _prefs.remove(_addressKey);

    await _prefs.remove(_profileImageKey);
  }
}
