import 'package:connectivity_plus/connectivity_plus.dart';

import 'internet_result.dart';

/// Extension to add comparison functionality for `InternetResult`.
///
/// Provides a helper method `isDifferent` to compare two `InternetResult`
/// objects and determine if they differ in terms of DNS, Socket, or HTTP success.
extension InternetConnectionResultExtension on InternetResult {
  /// Compares the current `InternetResult` with another `InternetResult`
  /// to determine if they are different.
  ///
  /// Returns `true` if there is a difference in any of the following:
  /// - DNS success status (`dnsSuccess`)
  /// - Socket connection success (`socketSuccess`)
  /// - HTTP success (`httpSuccess`)
  ///
  /// Returns `false` if all three statuses are the same.
  bool isDifferent(InternetResult other) {
    return dnsSuccess != other.dnsSuccess ||
        socketSuccess != other.socketSuccess ||
        httpSuccess != other.httpSuccess;
  }
}

/// Enum to represent the type of connection a device is using.
enum ConnectionType {
  /// Device is connected via Bluetooth.
  bluetooth,

  /// Device is connected to a Wi-Fi network.
  wifi,

  /// Device is connected via Ethernet.
  ethernet,

  /// Device is connected to a mobile/cellular network.
  mobile,

  /// Device has no active network connection.
  none,

  /// Device is connected to a VPN (Virtual Private Network).
  ///
  /// - **Note for iOS/macOS**: VPN connections on these platforms may be categorized
  ///   as [other] instead of [vpn].
  vpn,

  /// Device is connected to an unknown or unsupported network type.
  other
}

/// The list holds the current connection status, defaulted to [ConnectivityResult.none].
final List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

/// Extension to map `ConnectivityResult` from the `connectivity_plus` package
/// to a custom `ConnectionType` enum.
///
/// This is useful when you want to convert the `ConnectivityResult` to a more
/// specific connection type for easier handling of different network statuses.
extension ConnectivityResultMapper on ConnectivityResult {
  /// Maps a `ConnectivityResult` to the corresponding `ConnectionType`.
  ///
  /// This method handles the various connection types returned by `ConnectivityResult`
  /// and provides a custom `ConnectionType` for easier use in the application.
  ///
  /// Returns the appropriate [ConnectionType] based on the [ConnectivityResult] value.
  /// If the result is unknown or not mapped, it returns `ConnectionType.other`.
  ConnectionType toConnectionType() {
    switch (this) {
      case ConnectivityResult.bluetooth:
        return ConnectionType.bluetooth;
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.none:
        return ConnectionType.none;
      default:
        return ConnectionType.other; // Fallback for unknown/other connections
    }
  }

  /// Provides a list of [ConnectionType] based on the current connectivity status.
  ///
  /// This method maps [ConnectivityResult] into [ConnectionType] for easy interpretation.
  List<ConnectionType> get connectionStatus {
    return _connectionStatus.map(
      (result) {
        return result.toConnectionType();
      },
    ).toList();
  }
}
