import 'package:connectivity_plus/connectivity_plus.dart';

import '../../extensionresoft.dart';

extension InternetConnectionResultExtension on InternetResult {
  // Helper method to check if two connection results are different.
  bool isDifferent(InternetResult other) {
    return dnsSuccess != other.dnsSuccess || socketSuccess != other.socketSuccess || httpSuccess != other.httpSuccess;
  }
}

/// Connection status check result.
enum ConnectionType {
  /// Bluetooth: Device connected via bluetooth
  bluetooth,

  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Ethernet: Device connected to ethernet network
  ethernet,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none,

  /// VPN: Device connected to a VPN
  ///
  /// Note for iOS and macOS:
  /// There is no separate network interface type for [vpn].
  /// It returns [other] on any device (also simulator).
  vpn,

  /// Other: Device is connected to an unknown network
  other
}

extension ConnectivityResultMapper on ConnectivityResult {
  /// Extension to map `ConnectivityResult` to `ConnectionStatus`
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
}