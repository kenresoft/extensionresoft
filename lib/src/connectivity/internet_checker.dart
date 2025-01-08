import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:extensionresoft/src/connectivity/connection_type.dart';
import 'package:rxdart/rxdart.dart';

import 'internet_result.dart';

/// **InternetChecker**
///
/// A class to check internet connectivity using various methods like DNS lookup,
/// socket connection, and HTTP request. It provides streams for real-time
/// monitoring of internet status.
class InternetChecker {
  static final InternetChecker _instance = InternetChecker._(Connectivity());

  /// Singleton instance of the InternetChecker.
  static InternetChecker get instance => _instance;

  final Connectivity _connectivity;

  late final Stream<InternetResult> _streamA;
  late final Stream<InternetResult> _streamB;
  late final Stream<InternetResult> _combinedStream;

  /// Stream that emits results of periodic internet checks.
  Stream<InternetResult> get internetStream => _streamA;

  /// Stream that emits results based on connectivity changes.
  /// (e.g., wifi to mobile data transition)
  Stream<InternetResult> get connectivityStream => _streamB;

  /// Stream that combines results from periodic checks and connectivity changes.
  Stream<InternetResult> get internetConnectivityStream => _combinedStream;

  /// Future that provides the current internet connectivity status.
  Future<InternetResult> get internetResult async =>
      _getInternetResult(await _connectivity.checkConnectivity());

  InternetChecker._(this._connectivity) {
    final mainStream = Stream.periodic(const Duration(seconds: 3), (x) => x);

    _streamA = mainStream.asyncMap((_) async {
      return await _getInternetResult(await _connectivity.checkConnectivity());
    });

    _streamB = _connectivity.onConnectivityChanged
        .asyncMap((connectivityResult) async {
      return await _getInternetResult(connectivityResult);
    });

    _combinedStream = Rx.merge([_streamA, _streamB]);
  }

  Future<InternetResult> _getInternetResult(
      List<ConnectivityResult>? connectivityResult) async {
    if (connectivityResult != null &&
        connectivityResult.last == ConnectivityResult.none) {
      return InternetResult.noInternetAccess();
    }

    final results = await Future.wait([
      _performDNSCheck(),
      _performSocketCheck(),
      _performHttpRequest(),
    ]);

    return InternetResult(
      dnsSuccess: results.any((result) => result.dnsSuccess),
      socketSuccess: results.any((result) => result.socketSuccess),
      httpSuccess: results.any((result) => result.httpSuccess),
      failureReason: results
          .map((result) => result.failureReason)
          .where((reason) => reason != null)
          .join('; '),
      connectionType: connectivityResult?.last.toConnectionType(),
    );
  }

  Future<InternetResult> _performDNSCheck() async {
    final List<String> testHosts = [
      'google.com',
      'cloudflare.com',
      'facebook.com',
      'amazon.com'
    ];
    final result = await Future.wait(testHosts.map((host) async {
      try {
        final lookupResult = await InternetAddress.lookup(host);
        return lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
      } catch (e) {
        return false;
      }
    }));

    return InternetResult(
      dnsSuccess: result.any((success) => success),
      failureReason: result.any((success) => !success)
          ? 'DNS lookup failed for one or more hosts.'
          : null,
    );
  }

  Future<InternetResult> _performSocketCheck() async {
    final List<String> testHosts = [
      'google.com',
      'cloudflare.com',
      'facebook.com',
      'amazon.com'
    ];
    final results = await Future.wait(testHosts.map((host) async {
      try {
        final socket = await Socket.connect(host, 443,
            timeout: const Duration(seconds: 3));
        socket.destroy();
        return true; // Socket connection successful
      } catch (e) {
        return false; // Socket connection failed
      }
    }));

    // Check if any connection succeeded
    final socketSuccess = results.any((result) => result);

    return InternetResult(
      socketSuccess: socketSuccess,
      failureReason:
          socketSuccess ? null : 'Socket connection failed to all hosts.',
    );
  }

  Future<InternetResult> _performHttpRequest() async {
    final HttpClient httpClient = HttpClient();
    try {
      final HttpClientRequest request =
          await httpClient.getUrl(Uri.parse('https://www.google.com'));
      final HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        return InternetResult(httpSuccess: true);
      }
    } catch (e) {
      return InternetResult(
          httpSuccess: false, failureReason: "HTTP request failed: $e");
    } finally {
      httpClient.close();
    }
    return InternetResult(httpSuccess: false);
  }
}
