import 'package:equatable/equatable.dart';

/// A data class that represents the result of an internet connectivity check.
/// It holds the success or failure status of DNS resolution, socket connection,
/// and HTTP request stages, along with a detailed failure reason, if applicable.
///
/// The class uses the Equatable package to enable value comparison and
/// improve performance when comparing objects.
///
/// Properties:
/// - [dnsSuccess]: Indicates whether the DNS lookup was successful.
/// - [socketSuccess]: Indicates whether a socket connection to the test hosts succeeded.
/// - [httpSuccess]: Indicates whether an HTTP request to validate data transfer succeeded.
/// - [failureReason]: An optional string containing a detailed message explaining the reason for failure (if any).
///
/// Getter:
/// - [isConnected]: A convenience getter that returns `true` if all three checks (DNS, socket, and HTTP) succeeded, otherwise `false`.
///
/// Methods:
/// - [props]: Overrides the props from Equatable to compare the [isConnected] status when two instances are compared.
/// - [stringify]: Enables the string representation of the object for easier logging and debugging.
class InternetConnectionResult extends Equatable {
  final bool dnsSuccess;
  final bool socketSuccess;
  final bool httpSuccess;
  final String? failureReason; // Holds detailed error message

  const InternetConnectionResult({
    required this.dnsSuccess,
    required this.socketSuccess,
    required this.httpSuccess,
    this.failureReason,
  });

  factory InternetConnectionResult.notConnected() {
    return const InternetConnectionResult(
      dnsSuccess: false,
      socketSuccess: false,
      httpSuccess: false,
      failureReason: 'Not connected',
    );
  }

  /// Returns true if DNS, socket, and HTTP checks all succeeded.
  bool get isConnected => dnsSuccess && socketSuccess && httpSuccess;

  /// Overrides props for value comparison, focusing on the [isConnected] status.
  @override
  List<Object?> get props => [isConnected];

  /// Enables automatic string conversion for better debugging and logging output.
  @override
  bool? get stringify => true;
}
