import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _controller.stream;


  ConnectivityService() {
    _init();
  }

  void _init() {
    _connectivity.onConnectivityChanged.listen((result) {
      final isOnline = !result.contains(ConnectivityResult.none);
      _controller.add(isOnline);
    });
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void dispose() {
    _controller.close();
  }
}
