import 'package:shared_preferences/shared_preferences.dart';

/// A service class for managing SharedPreferences in Flutter applications.
///
/// This class provides methods for storing and retrieving various data types
/// in SharedPreferences, such as booleans, strings, integers, doubles, and lists of strings.
///
/// **Note:** This class is deprecated and will be removed in a future stable release.
/// The `preference` legacy is deprecated in the SharedPreferences library.
/// Please update your implementation to use modern alternatives or recommended patterns.

@Deprecated('SharedPreferencesService is deprecated and will be removed in a future stable release. '
    'Please migrate to a modern implementation as the preference legacy is deprecated in SharedPreferences.')
class SharedPreferencesService {
  static late SharedPreferences _preferences;

  /// Initializes the SharedPreferences instance.
  ///
  /// This method must be called before using any other methods in this class.
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Sets a boolean value in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  /// Retrieves a boolean value from SharedPreferences.
  ///
  /// Returns the boolean value associated with the given key, or null if the key is not found.
  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  /// Sets a string value in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  /// Retrieves a string value from SharedPreferences.
  ///
  /// Returns the string value associated with the given key, or null if the key is not found.
  static String? getString(String key) {
    return _preferences.getString(key);
  }

  /// Sets an integer value in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  /// Retrieves an integer value from SharedPreferences.
  ///
  /// Returns the integer value associated with the given key, or null if the key is not found.
  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  /// Sets a double value in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  /// Retrieves a double value from SharedPreferences.
  ///
  /// Returns the double value associated with the given key, or null if the key is not found.
  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  /// Sets a list of strings in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  /// Retrieves a list of strings from SharedPreferences.
  ///
  /// Returns the list of strings associated with the given key, or null if the key is not found.
  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  /// Clears all data in SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> clear() async {
    return await _preferences.clear();
  }

  /// Removes a value associated with the given key from SharedPreferences.
  ///
  /// Returns true if the operation is successful.
  static Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

  /// Checks if the SharedPreferences contains the given key.
  static bool containsKey(String key) {
    return _preferences.containsKey(key);
  }
}
