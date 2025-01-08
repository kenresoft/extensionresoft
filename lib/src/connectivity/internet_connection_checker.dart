import 'dart:async';

import 'internet_checker.dart';
import 'internet_result.dart';

/// **InternetConnectionChecker**
///
/// A high-level class to provide easy access to internet connectivity information.
/// It offers streams and methods to check the current internet status.
class InternetConnectionChecker {
  final InternetChecker _internetChecker = InternetChecker.instance;

  /// Stream that emits detailed [InternetResult] on connectivity changes.
  Stream<InternetResult> get onConnectivityChanged =>
      _internetChecker.connectivityStream.distinct();

  /// Stream that emits results based on changes in internet connectivity.
  Stream<InternetResult> get onInternetChanged =>
      _internetChecker.internetStream.distinct();

  /// Stream that emits combined results from both connectivity and internet checks.
  Stream<InternetResult> get onInternetConnectivityChanged =>
      _internetChecker.internetConnectivityStream.distinct();

  /// Stream that emits a boolean indicating whether internet is connected.
  Stream<bool> get onIsInternetConnected {
    return _internetChecker.internetConnectivityStream
        .map((event) => event.hasInternetAccess)
        .distinct();
  }

  /// Checks whether the device currently has internet access.
  Future<bool> get isInternetConnected async {
    final InternetResult(:hasInternetAccess) =
        await _internetChecker.internetResult;
    return hasInternetAccess;
  }
}
