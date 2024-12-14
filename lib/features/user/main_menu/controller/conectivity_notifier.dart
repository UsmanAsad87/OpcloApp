import 'dart:async'; // For StreamSubscription
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityNotifier extends StateNotifier<bool> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityNotifier() : super(true) {
    // Initialize and listen to connectivity changes
    _subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    state = result != ConnectivityResult.none;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});
