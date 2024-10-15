import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final Connectivity connectivity;
  ConnectionCheckerImpl({required this.connectivity});

  @override
  // Future<bool> get isConnected async => true;

  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await (connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    } else {
      return false;
    }
  }
}
