import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> get isOnline;
}

/// connectivity_plus reports whether a network *interface* is active
/// (wifi/cellular), not whether it actually reaches the internet — a device
/// on wifi with no internet still reports "connected". That's an accepted
/// trade-off: it's cheap and synchronous-ish, and the repository has a
/// second safety net (falling back to cache on an actual network failure),
/// so a false "online" reading here just means one extra failed request.
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityServiceImpl(this._connectivity);

  @override
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
