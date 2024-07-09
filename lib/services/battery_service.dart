import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryService {
  BatteryService._();

  static final instance = BatteryService._();
  final Battery _battery = Battery();

  void initialize(BuildContext context) {
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      int batteryLevel = await _battery.batteryLevel;
      if (state == BatteryState.charging && batteryLevel >= 90) {
        _showBatteryToast(context);
      }
    });
  }

  void _showBatteryToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Battery level reached 90%')),
    );
  }
}
