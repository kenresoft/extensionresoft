import 'package:internet_status/internet_status.dart';

class ConnectivityRepository {
  final InternetConnectionChecker _connectionChecker;

  ConnectivityRepository() : _connectionChecker = InternetConnectionChecker();

  Future<bool> checkConnection() async {
    return _connectionChecker.isInternetConnected;
  }

  Stream<InternetResult> get connectionStream {
    return _connectionChecker.onInternetConnectivityChanged;
  }
}
