// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Enhanced validation result model for form field validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationSeverity severity;

  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    this.severity = ValidationSeverity.error,
  });

  /// Factory constructors for common validation results
  factory ValidationResult.valid() => const ValidationResult(isValid: true);

  factory ValidationResult.error(String message) =>
      ValidationResult(isValid: false, errorMessage: message);

  factory ValidationResult.warning(String message) => ValidationResult(
    isValid: true,
    errorMessage: message,
    severity: ValidationSeverity.warning,
  );

  factory ValidationResult.info(String message) => ValidationResult(
    isValid: true,
    errorMessage: message,
    severity: ValidationSeverity.info,
  );

  /// Helper method to check if this is a specific severity level
  bool isSeverity(ValidationSeverity s) => severity == s;
}

/// Validation severity levels for different types of validation feedback
enum ValidationSeverity { info, warning, error }
