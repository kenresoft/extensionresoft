import 'package:extensionresoft/extensionresoft.dart';

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
