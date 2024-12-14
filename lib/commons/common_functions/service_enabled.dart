import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart';

Future<bool> serviceEnabled() async {
  Location location = new Location();
  PermissionStatus _permissionGranted;
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return await location.serviceEnabled();
}

Future<bool> enableService() async {
  PermissionStatus _permissionGranted;
  Location location = new Location();
  _permissionGranted = await location.hasPermission();
  print(_permissionGranted);
  if (_permissionGranted == PermissionStatus.denied) {
    AppSettings.openAppSettings(type: AppSettingsType.location);
    return false;
  } else {
    return await location.requestService();
  }
}
