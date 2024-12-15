import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_type.dart';
import 'internet_checker_legacy.dart';
import 'internet_result.dart';

/// A class that extends [InternetChecker] to provide connectivity checking functionality.
/// It combines connectivity information and internet availability to give a more reliable status.
final class InternetConnectionChecker extends InternetChecker {
  /// Constructor for [InternetConnectionChecker].
  InternetConnectionChecker();

  final Connectivity _connectivity = Connectivity();

  /// The list holds the current connection status, defaulted to [ConnectivityResult.none].
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  /// Holds the most recent internet result, defaulting to no internet access.
  InternetResult _internetResult = InternetResult.noInternetAccess();

  /// Updates the connection status based on the [ConnectivityResult].
  /// It checks whether the device is connected and if so, checks internet access.
  ///
  /// - If the device has no connectivity, it returns no internet access.
  /// - If connected, it checks the internet access using [InternetChecker].
  Future<InternetResult> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    final isNotConnected = result.last == ConnectivityResult.none;
    if (isNotConnected) {
      _internetResult = InternetResult.noInternetAccess();
    } else {
      _internetResult = await super.internetResult();
    }
    return _internetResult;
  }

  /// A stream that listens for connectivity changes and checks internet access.
  ///
  /// It returns an [InternetResult] stream reflecting the internet availability
  /// based on connectivity changes.
  Stream<InternetResult> get onInternetConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((List<ConnectivityResult> result) async {
      return await _updateConnectionStatus(result);
    });
  }

  /// A stream that emits boolean values based on internet availability.
  ///
  /// - `true`: Internet access is available.
  /// - `false`: No internet access.
  Stream<bool> get onConnectedToInternet {
    super.startInternetListening();
    return super.onInternetChanged.asyncMap((InternetResult event) => event.hasInternetAccess);
  }

  /// Checks whether the device currently has internet access.
  ///
  /// This performs a real-time check without using cached results.
  Future<bool> hasInternetAccess() async {
    final internetResult = await super.internetResult(useCaching: false);
    return internetResult.hasInternetAccess;
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
