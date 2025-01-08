import 'package:equatable/equatable.dart';
import 'package:extensionresoft/src/connectivity/connection_type.dart';

/// A data class that encapsulates the result of an internet connectivity check.
///
/// The `InternetResult` class tracks the success or failure of three key stages:
/// - DNS resolution
/// - Socket connection
/// - HTTP request validation
///
/// Additionally, it provides a reason for failure if any stage fails.
/// The class extends [Equatable], allowing for value-based comparison
/// and better performance when checking for equality between instances.
///
/// Properties:
/// - [dnsSuccess]: Boolean indicating if DNS lookup was successful.
/// - [socketSuccess]: Boolean indicating if socket connection to the test hosts succeeded.
/// - [httpSuccess]: Boolean indicating if an HTTP request to validate data transfer succeeded.
/// - [failureReason]: An optional string providing a detailed failure reason if the checks failed.
///
/// Getter:
/// - [hasInternetAccess]: A computed property that returns `true` if all three checks (DNS, socket, and HTTP) succeeded.
///
/// Methods:
/// - [props]: Overrides the properties from `Equatable` to facilitate object comparison based on the connectivity status.
/// - [stringify]: Enables automatic string conversion, making it easier to log and debug instances of this class.
class InternetResult extends Equatable {
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

  /// Overrides the equality comparison properties from [Equatable].
  ///
  /// The comparison is primarily focused on the [hasInternetAccess] property, but
  /// can also include other properties if needed.
  @override
  List<Object?> get props => [hasInternetAccess];

  /// Enables automatic string representation of the class for easier debugging and logging.
  ///
  /// When logging instances of this class, `stringify` ensures that the output includes
  /// the string version of the object, making the data more human-readable in logs.
  @override
  bool? get stringify => true;
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
