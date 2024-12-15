import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';

import 'connection_type.dart';
import 'internet_result.dart';

/// A singleton class responsible for checking reliable internet connectivity.
/// It verifies connection reliability by performing a three-stage process:
/// 1. DNS lookup.
/// 2. Socket connection.
/// 3. HTTP request.
///
/// The class provides detailed feedback using an `InternetConnectionResult` object.
base class InternetChecker {
  // Private constructor to ensure the singleton pattern.
  InternetChecker();

  // Stores the last successful connection result with its timestamp.
  InternetResult? _lastResult;
  DateTime? _lastChecked;

  // StreamController to broadcast connection changes.
  final StreamController<InternetResult> _internetStreamController = StreamController<InternetResult>.broadcast();

  // Timer for periodic connection checking.
  Timer? _timer;

  // Field to track whether the connection checker is currently listening.
  bool isInternetListening = false;

  /// Periodically checks for a reliable internet connection and broadcasts the result.
  /// - [interval]: Duration between consecutive checks.
  /// - [timeout]: The maximum time to wait for a connection.
  /// - [cacheDuration]: Duration to cache the result before performing a new check.
  /// - [maxRetries]: The number of retries before giving up.
  void startInternetListening({
    Duration interval = const Duration(seconds: 5),
    Duration timeout = const Duration(seconds: 5),
    Duration cacheDuration = const Duration(seconds: 10),
    int maxRetries = 3,
  }) {
    if (isInternetListening) return; // Prevent multiple listeners from starting

    isInternetListening = true; // Set the flag to true when listening starts
    _timer?.cancel(); // Cancel any existing timer if already running

    ///
    ///
    ///
    ///
    ///

    Future<InternetResult> getResult(List<ConnectivityResult> connectivityResult) async {
      InternetResult result;
      if (connectivityResult.last == ConnectivityResult.none) {
        result = InternetResult.noInternetAccess();
      } else {
        result = await internetResult(
          timeout: timeout,
          cacheDuration: cacheDuration,
          maxRetries: maxRetries,
          useCaching: false, // Disable caching to ensure fresh checks each time
        );
      }
      return result;
    }

    // Main stream emitting events at regular intervals
    final Stream<int> mainStream = Stream.periodic(interval, (x) => x);
    final Stream<List<ConnectivityResult>> innerStream = Connectivity().onConnectivityChanged;

    final Stream<InternetResult> streamA = mainStream.asyncExpand((_) async* {
      // Tick received from mainStream
      print("Tick from mainStream");

      // DNS Lookup Phase
      final dnsResult = await performDNSCheck();
      yield dnsResult;

      // Socket Connection Phase (only if DNS is successful)
      if (dnsResult.dnsSuccess) {
        final socketResult = await performSocketCheck();
        yield socketResult;

        // HTTP Request Phase (only if socket is successful)
        if (socketResult.socketSuccess) {
          final httpResult = await performHttpRequest();
          yield httpResult;
        }
      }
    });

    Stream<InternetResult> streamB = innerStream.asyncMap((List<ConnectivityResult> result) async {
      return await getResult(result);
    });

    final cStream = Rx.merge([
      streamA,
      streamB,
    ]);

    cStream.listen((event) {
      print(event.hasInternetAccess);

      // If connection state changes, broadcast the new result
      if (_lastResult == null || _lastResult!.isDifferent(event)) {
        print('${DateTime.now()}: Connection result changed: $event');
        _lastResult = event;
        _internetStreamController.add(event);
      } else {
        print('${DateTime.now()}: Connection result unchanged');
      }
    });

    ///
    ///
    ///
    ///

    /*_timer = Timer.periodic(interval, (_) async {
      InternetResult result;
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.last == ConnectivityResult.none) {
        result = InternetResult.noInternetAccess();
      } else {
        result = await internetResult(
          timeout: timeout,
          cacheDuration: cacheDuration,
          maxRetries: maxRetries,
          useCaching: false, // Disable caching to ensure fresh checks each time
        );
      }

      // If connection state changes, broadcast the new result
      if (_lastResult == null || _lastResult!.isDifferent(result)) {
        print('${DateTime.now()}: Connection result changed: $result');
        _lastResult = result;
        _internetStreamController.add(result);
      } else {
        print('${DateTime.now()}: Connection result unchanged');
      }
    });*/
  }

  /// Stops the periodic connection check.
  void stopInternetListening() {
    if (!isInternetListening) return; // Avoid stopping if not listening

    _timer?.cancel();
    isInternetListening = false; // Set the flag to false when listening stops
  }

  /// Returns a stream that listeners can subscribe to, to get notified about connection changes.
  Stream<InternetResult> get onInternetChanged => _internetStreamController.stream;

  /// Clean up resources.
  void dispose() {
    _timer?.cancel();
    _internetStreamController.close();
    isInternetListening = false;
  }

  /// Checks for a reliable internet connection by performing multiple stages of verification:
  /// 1. DNS lookup on a list of test hosts (e.g., Google, Cloudflare) to validate DNS resolution.
  /// 2. Socket connection to ensure the device can establish a connection on port 443 (HTTPS).
  /// 3. HTTP request to validate data transfer and confirm full internet connectivity.
  ///
  /// Implements retries with exponential backoff to handle transient network failures.
  /// Uses caching if a result falls within the specified [cacheDuration] and the provided `useCaching` flag is enabled.
  ///
  /// Parameters:
  /// - [timeout]: The maximum duration to wait for each network operation (DNS, socket, HTTP).
  /// - [cacheDuration]: Optional duration for caching results.
  /// - [maxHostsToTest]: The maximum number of hosts to test.
  /// - [maxRetries]: The number of retries to perform in case of failure.
  /// - [useCaching]: Flag to enable or disable caching for this specific call.
  ///
  /// Returns:
  /// - An `InternetConnectionResult` object that indicates whether the DNS, socket, and HTTP stages succeeded.
  /// - In case of failure, the object includes a `failureReason` with a descriptive error message.
  Future<InternetResult> internetResult({
    Duration timeout = const Duration(seconds: 5),
    Duration cacheDuration = const Duration(seconds: 10),
    int maxHostsToTest = 2,
    int maxRetries = 3, // Retry mechanism with exponential backoff
    bool useCaching = true, // Allow setting caching flag within the method
  }) async {
    // Check if caching is enabled and the cached result is still valid (use provided useCaching flag)
    if (useCaching && _lastResult != null && _lastChecked != null) {
      final Duration timeSinceLastCheck = DateTime.now().difference(_lastChecked!);
      if (timeSinceLastCheck <= cacheDuration) {
        return _lastResult!;
      }
    }

    final List<String> testHosts = ['google.com', 'cloudflare.com', 'facebook.com', 'amazon.com'];
    bool dnsSuccess = false;
    bool socketSuccess = false;
    bool httpSuccess = false;

    final Random random = Random();
    final List<String> selectedHosts = List.from(testHosts)..shuffle(random);

    InternetResult result;

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // DNS Lookup Step
        final List<InternetAddress?> validDnsAddresses = [];
        for (int i = 0; i < min(maxHostsToTest, selectedHosts.length); i++) {
          final host = selectedHosts[i];
          try {
            final lookupResult = await InternetAddress.lookup(host);
            if (lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty) {
              dnsSuccess = true;
              validDnsAddresses.add(lookupResult[0]);
            }
          } on SocketException catch (e) {
            if (attempt == maxRetries) {
              return InternetResult(
                dnsSuccess: false,
                socketSuccess: false,
                httpSuccess: false,
                failureReason: 'DNS lookup failed for $host: $e',
              );
            }
          }
        }

        if (!dnsSuccess && attempt == maxRetries) {
          return InternetResult(
            dnsSuccess: false,
            socketSuccess: false,
            httpSuccess: false,
            failureReason: 'DNS lookup failed after $maxRetries attempts',
          );
        }

        // Socket Connection Step
        for (final address in validDnsAddresses) {
          try {
            final socket = await Socket.connect(address!, 443, timeout: timeout);
            socket.destroy();
            socketSuccess = true;
            break; // Stop trying if one host works
          } on SocketException catch (e) {
            if (attempt == maxRetries) {
              return InternetResult(
                dnsSuccess: true,
                socketSuccess: false,
                httpSuccess: false,
                failureReason: 'SocketException: $e',
              );
            }
          } on TimeoutException catch (e) {
            if (attempt == maxRetries) {
              return InternetResult(
                dnsSuccess: true,
                socketSuccess: false,
                httpSuccess: false,
                failureReason: 'TimeoutException: $e',
              );
            }
          }
        }

        if (!socketSuccess && attempt == maxRetries) {
          return InternetResult(
            dnsSuccess: true,
            socketSuccess: false,
            httpSuccess: false,
            failureReason: 'Socket connection failed after $maxRetries attempts',
          );
        }

        // HTTP Request Step
        final HttpClient httpClient = HttpClient();
        httpClient.connectionTimeout = timeout;
        try {
          final HttpClientRequest request = await httpClient.getUrl(Uri.parse('https://www.google.com'));
          final HttpClientResponse response = await request.close();
          if (response.statusCode == 200) {
            httpSuccess = true;
          }
        } on SocketException catch (e) {
          if (attempt == maxRetries) {
            return InternetResult(
              dnsSuccess: true,
              socketSuccess: true,
              httpSuccess: false,
              failureReason: 'SocketException during HTTP request: $e',
            );
          }
        } on TimeoutException catch (e) {
          if (attempt == maxRetries) {
            return InternetResult(
              dnsSuccess: true,
              socketSuccess: true,
              httpSuccess: false,
              failureReason: 'TimeoutException during HTTP request: $e',
            );
          }
        } on HttpException catch (e) {
          if (attempt == maxRetries) {
            return InternetResult(
              dnsSuccess: true,
              socketSuccess: true,
              httpSuccess: false,
              failureReason: 'HttpException during HTTP request: $e',
            );
          }
        } catch (e) {
          if (attempt == maxRetries) {
            return InternetResult(
              dnsSuccess: true,
              socketSuccess: true,
              httpSuccess: false,
              failureReason: 'Unexpected error during HTTP request: $e',
            );
          }
        } finally {
          httpClient.close();
        }

        if (httpSuccess) {
          break;
        }
      } catch (e) {
        if (attempt == maxRetries) {
          return InternetResult(
            dnsSuccess: false,
            socketSuccess: false,
            httpSuccess: false,
            failureReason: 'Unexpected error during the process: $e',
          );
        }
      }

      // Wait before retrying with exponential backoff
      final backoffDuration = Duration(milliseconds: pow(2, attempt).toInt() * 100);
      await Future.delayed(backoffDuration);
    }

    // Cache the result and timestamp if caching is enabled
    result = InternetResult(
      dnsSuccess: dnsSuccess,
      socketSuccess: socketSuccess,
      httpSuccess: httpSuccess,
      failureReason: null,
    );

    if (useCaching) {
      _lastResult = result;
      _lastChecked = DateTime.now();
    }

    // Return the result for first-time or non-cached calls
    return result;
  }

  // DNS Lookup Phase (uses part of your internetResult code)
  Future<InternetResult> performDNSCheck() async {
    final List<String> testHosts = ['google.com', 'cloudflare.com'];
    for (String host in testHosts) {
      try {
        final lookupResult = await InternetAddress.lookup(host);
        if (lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty) {
          return InternetResult(dnsSuccess: true, socketSuccess: false, httpSuccess: false);
        }
      } catch (e) {
        // Return failure on DNS lookup error
        return InternetResult(
          dnsSuccess: false,
          socketSuccess: false,
          httpSuccess: false,
          failureReason: "DNS lookup failed for $host: $e",
        );
      }
    }
    return InternetResult(dnsSuccess: false, socketSuccess: false, httpSuccess: false);
  }

  // Socket Connection Phase
  Future<InternetResult> performSocketCheck() async {
    try {
      final socket = await Socket.connect('google.com', 443, timeout: Duration(seconds: 5));
      socket.destroy();
      return InternetResult(dnsSuccess: true, socketSuccess: true, httpSuccess: false);
    } catch (e) {
      return InternetResult(
        dnsSuccess: true,
        socketSuccess: false,
        httpSuccess: false,
        failureReason: "Socket connection failed: $e",
      );
    }
  }

  // HTTP Request Phase
  Future<InternetResult> performHttpRequest() async {
    final HttpClient httpClient = HttpClient();
    try {
      final HttpClientRequest request = await httpClient.getUrl(Uri.parse('https://www.google.com'));
      final HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        return InternetResult(dnsSuccess: true, socketSuccess: true, httpSuccess: true);
      }
    } catch (e) {
      return InternetResult(
        dnsSuccess: true,
        socketSuccess: true,
        httpSuccess: false,
        failureReason: "HTTP request failed: $e",
      );
    } finally {
      httpClient.close();
    }
    return InternetResult(
      dnsSuccess: true,
      socketSuccess: true,
      httpSuccess: false,
      failureReason: "HTTP request failed",
    );
  }
}
