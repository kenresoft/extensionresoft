import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_type.dart';
import 'internet_checker.dart';
import 'internet_result.dart';

final class InternetConnectionChecker extends InternetChecker {
  InternetConnectionChecker();

  final Connectivity _connectivity = Connectivity();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  InternetResult _internetResult = InternetResult.noInternetAccess();

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

  /// Start listening for connectivity changes
  Stream<InternetResult> get onInternetConnectivityChanged {
    return _connectivity.onConnectivityChanged.asyncMap((List<ConnectivityResult> result) async {
      final updatedResult = await _updateConnectionStatus(result);
      return updatedResult;
    });
  }

  /// Stream for combined connectivity and internet status
  Stream<bool> get onConnectedToInternet {
    super.startInternetListening();
    return super.onInternetChanged.asyncMap((InternetResult event) {
      /*final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.last == ConnectivityResult.none ? false : event.hasInternetAccess;*/
      return event.hasInternetAccess;
    });
  }

/*  Stream<bool> get onConnectedToInternet {
    // Stream for connectivity status (Wi-Fi, mobile, ethernet, etc.)
    final Stream<List<ConnectivityResult>> connectivityStream = _connectivity.onConnectivityChanged;

    // Stream for internet status (actual connection to the internet)
    final Stream<InternetResult> internetStream = super.onInternetChanged;

    // Combine the streams
    return Rx.combineLatest2(
      connectivityStream,
      internetStream,
      (List<ConnectivityResult> connectivityResult, InternetResult internetResult) {
        // Determine if device has both network connectivity and internet access
        final noConnectivity = connectivityResult.last == ConnectivityResult.none;

        final hasInternet = internetResult.hasInternetAccess;

        // Return true if the device has both connectivity and internet access
        if (noConnectivity) {
          return false;
        } else {
          return !noConnectivity && hasInternet;
        }
      },
    );
  }*/

  Future<bool> hasInternetAccess() async {
    final internetResult = await super.internetResult(useCaching: false);
    return internetResult.hasInternetAccess;
  }

  List<ConnectionType> get connectionStatus {
    return _connectionStatus.map(
      (e) {
        return e.toConnectionType();
      },
    ).toList();
  }
}
