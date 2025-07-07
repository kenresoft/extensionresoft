// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// High-performance validation controller for managing form field validation states
/// with minimal rebuilds and efficient change detection.
class ValidationController extends ChangeNotifier {
  final _fields = <String, ValidationFieldState>{};
  final _dirtyFields = <String>{};
  bool _isDisposed = false;

  // ===========================
  // PUBLIC API
  // ===========================

  /// Registers a field with optional validator
  /// Returns a unique field key that should be stored by the field
  String registerField(String? fieldKey, String? Function(String?)? validator) {
    _assertNotDisposed();
    final key = fieldKey ?? _generateFieldKey();
    _fields[key] = ValidationFieldState(
      key: key,
      validator: validator,
      isValid: true,
      errorMessage: null,
    );
    return key;
  }

  /// Unregisters a field when it's no longer needed
  void unregisterField(String fieldKey) {
    if (_isDisposed) return;
    _fields.remove(fieldKey);
    _dirtyFields.remove(fieldKey);
  }

  /// Validates a single field and updates its state
  bool validateField(String fieldKey, String? value) {
    _assertNotDisposed();
    final fieldState = _fields[fieldKey];
    if (fieldState == null) return true;

    return _validateFieldState(fieldKey, fieldState, value);
  }

  /// Validates all registered fields
  bool validate() {
    _assertNotDisposed();
    bool allValid = true;
    bool hasChanges = false;

    _fields.forEach((key, fieldState) {
      if (_validateFieldState(key, fieldState, fieldState.currentValue)) {
        allValid = allValid && true;
      } else {
        allValid = false;
        hasChanges = true;
      }
    });

    if (hasChanges) notifyListeners();
    return allValid;
  }

  /// Updates a field's value without triggering validation
  void updateFieldValue(String fieldKey, String? value) {
    if (_isDisposed || !_fields.containsKey(fieldKey)) return;

    final fieldState = _fields[fieldKey]!;
    if (fieldState.currentValue != value) {
      _fields[fieldKey] = fieldState.copyWith(currentValue: value);
    }
  }

  /// Clears all validation states (marks all fields as valid)
  void clearValidation() {
    _assertNotDisposed();
    bool hasChanges = false;

    _fields.forEach((key, fieldState) {
      if (!fieldState.isValid || fieldState.errorMessage != null) {
        _fields[key] = fieldState.copyWith(isValid: true, errorMessage: null);
        hasChanges = true;
      }
    });

    if (hasChanges) {
      _dirtyFields.clear();
      notifyListeners();
    }
  }

  /// Resets the controller to its initial state
  void reset() {
    _assertNotDisposed();
    _fields.clear();
    _dirtyFields.clear();
    notifyListeners();
  }

  // ===========================
  // GETTERS
  // ===========================

  ValidationFieldState? getFieldState(String fieldKey) => _fields[fieldKey];

  bool isFieldValid(String fieldKey) => _fields[fieldKey]?.isValid ?? true;

  String? getFieldError(String fieldKey) => _fields[fieldKey]?.errorMessage;

  bool get isValid => _fields.values.every((field) => field.isValid);

  bool get isDirty => _dirtyFields.isNotEmpty;

  Map<String, String> get errors => Map.fromEntries(
    _fields.entries
        .where((entry) => !entry.value.isValid)
        .map((entry) => MapEntry(entry.key, entry.value.errorMessage ?? '')),
  );

  List<String> get invalidFields =>
      _fields.entries.where((entry) => !entry.value.isValid).map((entry) => entry.key).toList();

  // ===========================
  // DISPOSAL
  // ===========================

  @override
  void dispose() {
    _isDisposed = true;
    _fields.clear();
    _dirtyFields.clear();
    super.dispose();
  }

  // ===========================
  // PRIVATE METHODS
  // ===========================

  bool _validateFieldState(String key, ValidationFieldState state, String? value) {
    final errorMessage = state.validator?.call(value);
    final isValid = errorMessage == null;

    if (state.isValid != isValid || state.errorMessage != errorMessage) {
      _fields[key] = state.copyWith(isValid: isValid, errorMessage: errorMessage, currentValue: value);
      _dirtyFields.add(key);
      notifyListeners();
    }

    return isValid;
  }

  String _generateFieldKey() => 'field_${DateTime.now().microsecondsSinceEpoch}_${_fields.length}';

  void _assertNotDisposed() {
    if (_isDisposed) {
      throw StateError('ValidationController has been disposed');
    }
  }
}

/// Immutable state container for a validated field
@immutable
class ValidationFieldState {
  final String key;
  final String? Function(String?)? validator;
  final bool isValid;
  final String? errorMessage;
  final String? currentValue;

  const ValidationFieldState({
    required this.key,
    this.validator,
    required this.isValid,
    this.errorMessage,
    this.currentValue,
  });

  ValidationFieldState copyWith({
    String? key,
    String? Function(String?)? validator,
    bool? isValid,
    String? errorMessage,
    String? currentValue,
  }) {
    return ValidationFieldState(
      key: key ?? this.key,
      validator: validator ?? this.validator,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ValidationFieldState &&
            runtimeType == other.runtimeType &&
            key == other.key &&
            isValid == other.isValid &&
            errorMessage == other.errorMessage &&
            currentValue == other.currentValue);
  }

  @override
  int get hashCode => key.hashCode ^ isValid.hashCode ^ errorMessage.hashCode ^ currentValue.hashCode;

  @override
  String toString() {
    return 'ValidationFieldState{key: $key, valid: $isValid, error: $errorMessage, value: $currentValue}';
  }
}

/// Mixin for widgets that integrate with ValidationController
mixin ValidationControllerMixin<T extends StatefulWidget> on State<T> {
  ValidationController? _validationController;
  String? _fieldKey;

  /// The key associated with this field in the [ValidationController].
  String? get fieldKey => _fieldKey;

  /// Initializes validation with controller and optional validator
  void initializeValidation({
    required ValidationController? validationController,
    String? fieldKey,
    String? Function(String?)? validator,
  }) {
    _validationController = validationController;
    if (_validationController != null) {
      _fieldKey = _validationController!.registerField(fieldKey, validator);
    }
  }

  /// Updates the field value in validation controller
  void updateValidationValue(String? value) {
    if (_validationController != null && _fieldKey != null) {
      _validationController!.updateFieldValue(_fieldKey!, value);
    }
  }

  /// Validates the current field
  bool validateCurrentField(String? value) {
    if (_validationController != null && _fieldKey != null) {
      return _validationController!.validateField(_fieldKey!, value);
    }
    return true;
  }

  /// Gets current validation state
  ValidationFieldState? get validationState {
    if (_validationController != null && _fieldKey != null) {
      return _validationController!.getFieldState(_fieldKey!);
    }
    return null;
  }

  /// Cleans up validation registration
  void disposeValidation() {
    if (_validationController != null && _fieldKey != null) {
      _validationController!.unregisterField(_fieldKey!);
    }
  }
}
