// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:extensionresoft/src/connectivity/connection_type.dart';

/// A data class that encapsulates the result of an internet connectivity check.
///
/// The `InternetResult` class tracks the success or failure of three key stages:
/// - DNS resolution
/// - Socket connection
/// - HTTP request validation
///
/// Additionally, it provides a reason for failure if any stage fails.
///
/// Properties:
/// - [dnsSuccess]: Boolean indicating if DNS lookup was successful.
/// - [socketSuccess]: Boolean indicating if socket connection to the test hosts succeeded.
/// - [httpSuccess]: Boolean indicating if an HTTP request to validate data transfer succeeded.
/// - [failureReason]: An optional string providing a detailed failure reason if the checks failed.
class InternetResult {
  /// Whether the DNS lookup was successful.
  final bool dnsSuccess;

  /// Whether a socket connection to the test hosts succeeded.
  final bool socketSuccess;

  /// Whether an HTTP request to validate data transfer succeeded.
  final bool httpSuccess;

  /// Optional string containing the reason for failure, if any.
  final String? failureReason;

  final ConnectionType? connectionType;

  /// Constructor to initialize all fields of the class.
  const InternetResult({
    this.dnsSuccess = false,
    this.socketSuccess = false,
    this.httpSuccess = false,
    this.failureReason,
    this.connectionType,
  });

  /// Factory constructor for a scenario where no internet access is available.
  ///
  /// This provides a default [InternetResult] instance where all checks failed
  /// and the [failureReason] is set to 'Not connected'.
  factory InternetResult.noInternetAccess() {
    return const InternetResult(
      dnsSuccess: false,
      socketSuccess: false,
      httpSuccess: false,
      failureReason: 'Not connected',
      connectionType: ConnectionType.none,
    );
  }

  /// Convenience getter that returns `true` if all three checks succeeded.
  ///
  /// The device is considered to have internet access if DNS, socket, and HTTP checks
  /// all report success. This getter simplifies checking overall internet connectivity.
  bool get hasInternetAccess => dnsSuccess && socketSuccess && httpSuccess;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternetResult &&
          runtimeType == other.runtimeType &&
          dnsSuccess == other.dnsSuccess &&
          socketSuccess == other.socketSuccess &&
          httpSuccess == other.httpSuccess &&
          failureReason == other.failureReason &&
          connectionType == other.connectionType;

  @override
  int get hashCode =>
      dnsSuccess.hashCode ^
      socketSuccess.hashCode ^
      httpSuccess.hashCode ^
      failureReason.hashCode ^
      connectionType.hashCode;

  @override
  String toString() =>
      'InternetResult(dnsSuccess: $dnsSuccess, socketSuccess: $socketSuccess, httpSuccess: $httpSuccess, failureReason: $failureReason, connectionType: $connectionType)';
}

/*  Future<InternetResult> getResult([List<ConnectivityResult>? connectivityResult]) async {
    InternetResult result;
    if (connectivityResult != null && connectivityResult.last == ConnectivityResult.none) {
      result = InternetResult.noInternetAccess();
    } else {
      final dnsResult = _performDNSCheck();
      final socketResult = _performSocketCheck();
      final httpResult = _performHttpRequest();

      final allResults = await Future.wait([dnsResult, socketResult, httpResult]);
      final defaultResult = InternetResult(dnsSuccess: false, socketSuccess: false, httpSuccess: false);
      result = allResults.fold(defaultResult, (previousValue, element) => element);
    }
    return result;
  }*/
