import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  ConnectivityService._();

  static final instance = ConnectivityService._();
  final Connectivity _connectivity = Connectivity();

  void initialize(BuildContext context) {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _showConnectivityToast(context, result);
    });
  }

  void _showConnectivityToast(BuildContext context, ConnectivityResult result) {
    String message;
    if (result == ConnectivityResult.mobile) {
      message = 'Connected to Mobile Network';
    } else if (result == ConnectivityResult.wifi) {
      message = 'Connected to WiFi';
    } else {
      message = 'No Internet Connection';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
