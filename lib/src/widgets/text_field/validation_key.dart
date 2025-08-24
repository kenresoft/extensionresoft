import 'package:flutter/foundation.dart';

/// A specialized notifier for tracking validation field keys in forms.
///
/// This class provides a clean abstraction around [ValueNotifier<String>]
/// specifically for managing validation field keys. It's typically used with
/// [CustomTextField] to access the auto-generated validation keys.
///
/// ## Usage
///
/// ```dart
/// // Create a key notifier
/// final firstNameKey = ValidationKey();
///
/// // Use with CustomTextField
/// CustomTextField(
///   validationKey: firstNameKey,
///   // ... other parameters
/// );
///
/// // Access the key value later
/// print('Field key: ${firstNameKey.value}');
///
/// // Remember to dispose when done
/// firstNameKey.dispose();
/// ```
///
/// ## Lifecycle Management
///
/// Always call [dispose] when the key is no longer needed to prevent memory leaks.
/// Typically this is done in the [State.dispose] method of your widget.
class ValidationKey {
  final ValueNotifier<String> _notifier;

  /// Debug information for development purposes.
  /// Helps in identifying the source or purpose of the ValidationKey.
  final String? debugLabel;

  /// Creates a [ValidationKey] instance.
  ///
  /// The internal key value is initialized as an empty string and will be
  /// populated automatically when used with [CustomTextField].
  ///
  /// An optional [debugLabel] can be provided for easier identification
  /// during debugging.
  ValidationKey({this.debugLabel}) : _notifier = ValueNotifier('');

  /// The current validation field key value.
  ///
  /// This will be empty until assigned by the validation system (typically
  /// by a [CustomTextField]). Once set, this contains the unique identifier
  /// used by the [ValidationController] for this field.
  String get value => _notifier.value;

  /// Updates the current validation field key value.
  ///
  /// This is typically called internally by [CustomTextField] and shouldn't
  /// need to be set manually. Notifies all listeners when changed.
  set value(String newValue) => _notifier.value = newValue;

  /// Register a closure to be called when the key value changes.
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  /// Remove a previously registered closure from the list of closures that are
  /// notified when the key value changes.
  void removeListener(VoidCallback listener) => _notifier.removeListener(listener);

  /// Discards any resources used by the object.
  ///
  /// After this is called, the object is not in a usable state and should be
  /// discarded.
  ///
  /// Always call this when the [ValidationKey] is no longer needed to prevent
  /// memory leaks.
  void dispose() => _notifier.dispose();

  @override
  String toString() {
    return 'ValidationKey(${debugLabel != null ? 'label: $debugLabel, ' : ''}value: "${_notifier.value}")';
  }
}
