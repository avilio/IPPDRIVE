
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart' as connect;
/*
class Connectivity {
  final _connectivity = new connect.Connectivity();
  StreamSubscription<connect.ConnectivityResult> _connectivitySubscription;

  String get connectStatus => _connectionStatus;

  String _connectionStatus = 'Unknown';

  Future<Null> initConnectivity() async {
    String connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    _connectionStatus = connectionStatus;
  }

*/
/* @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() => _connectionStatus = result.toString());
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }*//*


}
*/
