// Copyright 2024 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/types.dart';

final _logger = Logger();

/// A service for managing shared preferences with optional caching and logging.
///
/// This service provides methods to store and retrieve preferences of
/// different types (bool, int, double, String, List<String>) and integrates
/// cache management for performance optimization. The service also supports
/// optional logging and delayed writes for batch operations.
///
/// Example:
///
/// ```dart
/// await SharedPreferencesService.init();
/// SharedPreferencesService.setBool('darkMode', true);
/// bool? isDarkMode = SharedPreferencesService.getBool('darkMode');
/// ```
class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  late SharedPreferencesAsync _preferences;
  late Map<String, Object?> _cache;

  /// Options that define cache behavior, including an allowlist for valid keys.
  late SharedPreferencesWithCacheOptions _cacheOptions;

  /// Indicates whether caching is enabled.
  late bool _enableCaching;

  /// Indicates whether logging is enabled.
  late bool _enableLogging;

  SharedPreferencesService._internal();

  /// Initializes the shared preferences service with optional configurations.
  ///
  /// - [preferencesOptions]: Options to configure the shared preferences behavior.
  /// - [cacheOptions]: Options to define cache behavior, including the allowlist.
  /// - [cache]: A pre-populated cache (optional).
  /// - [enableCaching]: Determines if caching is enabled (default is `true`).
  /// - [useLegacy]: Uses legacy storage if set to `true` (default is `false`).
  /// - [enableLogging]: Enables logging for errors (default is `true`).
  static Future<void> init({
    SharedPreferencesOptions? preferencesOptions,
    SharedPreferencesWithCacheOptions? cacheOptions,
    Map<String, Object?>? cache,
    bool enableCaching = true,
    bool useLegacy = false,
    bool enableLogging = true,
  }) async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();

      // Initialize with options if provided, else use default options
      _instance!._preferences = SharedPreferencesAsync(
        options: preferencesOptions ?? const SharedPreferencesOptions(),
      );

      _instance!._enableCaching = enableCaching;
      _instance!._enableLogging = enableLogging;

      if (_instance!._enableCaching) {
        if (cacheOptions == null) {
          throw ArgumentError('Cache options must be provided if caching is enabled.');
        }
        _instance!._cacheOptions = cacheOptions;
      }

      if (_instance!._enableCaching) {
        // Load the cache from the preferences or use provided cache
        _instance!._cache = cache ?? await _instance!._preferences.getAll(allowList: _instance!._cacheOptions.allowList);
      }
    }
  }

  static Future<Map<String, Object?>> getAll({Set<String>? allowList}) {
    return _instance!._preferences.getAll(allowList: allowList);
  }

  static Future<Set<String>> getKeys({Set<String>? allowList}) {
    return _instance!._preferences.getKeys(allowList: allowList);
  }

  /// Updates cache with the latest values from the platform.
  ///
  /// Should be called before reading values if they may have been updated
  /// by other sources, such as another isolate or native code.
  static Future<void> reloadCache() async {
    _instance!._cache.clear();
    _instance!._cache.addAll(await _instance!._preferences.getAll(allowList: _instance!._cacheOptions.allowList));
  }

  /// Returns `true` if the cache contains the given [key].
  ///
  /// Throws an [ArgumentError] if [key] is not allowed based on the filter.
  static bool containsKey(String key) {
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    if (_instance!._enableCaching) {
      return _instance!._cache.containsKey(key);
    } else {
      throw 'Cache is not enabled. Use `containsKeyAsync` for non-cache access.';
    }
  }

  static Future<bool> containsKeyAsync(String key) async {
    if (_instance!._enableCaching) {
      return containsKey(key);
    } else {
      final keys = await getKeys();
      return keys.contains(key);
    }
  }

  /// Returns all keys in the cache.
  static Set<String> get keys => _instance!._cache.keys.toSet();

  // Fetches a value of the specified type [T] from the cache or preferences.
  //
  // - [key]: The preference key.
  //
  // Returns the value if found or `null` if the key is missing.
  //
  // Throws [ArgumentError] if the key is not allowed.

  /// Synchronous get (cache-enabled)
  ///
  /// Fetches a value from the cache.
  ///
  /// Returns the value if found or `null` if the key is missing.
  ///
  /// Throws [ArgumentError] if the key is not allowed.
  static T? get<T>(String key) {
    _ensureInitialized();
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }

    try {
      if (_instance!._enableCaching) {
        return _instance!._cache[key] as T?;
      } else {
        throw StateError('Cache is not enabled. Use `getAsync` for non-cache access.');
      }
    } catch (e) {
      if (_instance!._enableLogging) {
        _logger.e('Error retrieving key $key: ${e.toString()}');
      }
      return null;
    }
  }

  /// Asynchronous get (cache-disabled)
  ///
  /// Fetches a value from SharedPreferences asynchronously.
  ///
  /// Returns the value if found or `null` if the key is missing.
  ///
  /// Uses a type handler to map the correct get method based on type.
  static Future<T?> getAsync<T>(String key) async {
    _ensureInitialized();
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }

    try {
      // Use a type handler to fetch the correct type from SharedPreferences
      if (T == String) {
        return await _instance!._preferences.getString(key) as T?;
      } else if (T == bool) {
        return await _instance!._preferences.getBool(key) as T?;
      } else if (T == int) {
        return await _instance!._preferences.getInt(key) as T?;
      } else if (T == double) {
        return await _instance!._preferences.getDouble(key) as T?;
      } else if (T == List<String>) {
        return await _instance!._preferences.getStringList(key) as T?;
      } else {
        throw UnsupportedError('Unsupported type $T for SharedPreferences.');
      }
    } catch (e) {
      if (_instance!._enableLogging) {
        _logger.e('Error retrieving key $key: ${e.toString()}');
      }
      return null;
    }
  }

  /// Sets a value of any type [T] in both the cache and preferences.
  ///
  /// - [key]: The preference key.
  /// - [value]: The value to set.
  /// - [delayedWrite]: If `true`, the value will be cached but not written immediately (for batch operations).
  ///
  /// Throws [ArgumentError] if the key is not allowed.
/*  static Future<void> set<T>(String key, T value, {bool delayedWrite = false}) async {
    _ensureInitialized();
    if (!_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }
    if (_instance!._enableCaching) {
      _instance!._cache[key] = value;
    }

    if (delayedWrite) return;

    await _writeToPreferences(key, value);
  }*/

  static Future<void> set<T>(String key, T value, {bool delayedWrite = false}) async {
    _ensureInitialized();
    if (_instance!._enableCaching && !_isValidKey(key)) {
      throw ArgumentError('$key is not included in the PreferencesFilter allowlist');
    }

    if (!_typeHandlers.containsKey(T)) {
      throw SharedPreferencesException('Unsupported type $T for preferences');
    }

    if (_instance!._enableCaching) {
      _instance!._cache[key] = value;
    }

    if (!delayedWrite) { // Delay write for batch operations
      await _writeToPreferences(key, value);
    }
  }


  static final Map<Type, Function> _typeHandlers = {
    bool: (key, value) => _instance!._preferences.setBool(key, value as bool),
    int: (key, value) => _instance!._preferences.setInt(key, value as int),
    double: (key, value) => _instance!._preferences.setDouble(key, value as double),
    String: (key, value) => _instance!._preferences.setString(key, value as String),
    List<String>: (key, value) => _instance!._preferences.setStringList(key, value as List<String>),
  };

  /// Internal helper to write values to the preferences asynchronously.
  static Future<void> _writeToPreferences<T>(String key, T value) async {
    final handler = _typeHandlers[T];
    if (handler != null) {
      await handler(key, value);
    } else {
      throw ArgumentError('Unsupported type for preferences');
    }
  }

  /// Removes a value from both the cache and preferences.
  ///
  /// - [key]: The preference key to remove.
  static Future<void> remove(String key) async {
    _ensureInitialized();
    if (_instance!._enableCaching) {
      _instance!._cache.remove(key);
    }
    await _instance!._preferences.remove(key);
  }

  /// Fetches a boolean value.
  static bool? getBool(String key) => get<bool>(key);

  /// Sets a boolean value in preferences.
  static Future<void> setBool(String key, bool value) async {
    await set<bool>(key, value);
  }

  /// Fetches a string value.
  static String? getString(String key) => get<String>(key);

  /// Sets a string value in preferences.
  /// Note: Due to limitations on some platforms,
  /// values cannot start with the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  static Future<void> setString(String key, String value) async {
    await set<String>(key, value);
  }

  /// Fetches a integer value.
  static int? getInt(String key) => get<int>(key);

  /// Sets a integer value in preferences.
  static Future<void> setInt(String key, int value) async {
    await set<int>(key, value);
  }

  /// Fetches a double value.
  static double? getDouble(String key) => get<double>(key);

  /// Sets a double value in preferences.
  static Future<void> setDouble(String key, double value) async {
    await set<double>(key, value);
  }

  /// Fetches a list of strings value.
  static List<String>? getStringList(String key) => get<List<String>>(key);

  /// Sets a list of strings value in preferences.
  static Future<void> setStringList(String key, List<String> value) async {
    await set<List<String>>(key, value);
  }

  /// Clears all preferences and cache
  static Future<void> clear({Set<String>? allowList}) async {
    _ensureInitialized();
    _instance!._cache.clear();
    if (_instance!._enableCaching) {
      await _instance!._preferences.clear(allowList: _instance!._cacheOptions.allowList);
    } else {
      await _instance!._preferences.clear(allowList: allowList);
    }
  }

  /// Ensures the service has been initialized before usage.
  static void _ensureInitialized() {
    if (_instance == null) {
      throw StateError('SharedPreferencesService is not initialized. Call init() before usage.');
    }
  }

  /// Validates if the [key] is part of the allowed keys in the preferences.
  static bool _isValidKey(String key) {
    if (_instance!._enableCaching) {
      return _instance!._cacheOptions.allowList?.contains(key) ?? true;
    }
    return true;
  }
}
