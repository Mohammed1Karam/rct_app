// import 'package:flutter/foundation.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// class LocationPermissionHandler {
//   static final LocationPermissionHandler _instance =
//       LocationPermissionHandler._internal();
//   factory LocationPermissionHandler() => _instance;
//   LocationPermissionHandler._internal();

//   bool _hasPermission = false;

//   Future<bool> requestLocationPermission() async {
//     if (_hasPermission) return true;

//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (kDebugMode) {
//         print('Location services are disabled');
//       }
//       return false;
//     }

//     var permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (kDebugMode) {
//           print('Location permission denied');
//         }
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (kDebugMode) {
//         print(
//             'Location permission permanently denied. Redirecting to app settings.');
//       }
//       await openAppSettings();
//       return false;
//     }

//     _hasPermission = true;
//     return true;
//   }

//   Future<Position?> getCurrentLocation() async {
//     try {
//       final hasPermission = await requestLocationPermission();
//       if (!hasPermission) return null;

//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 5),
//       );

//       if (kDebugMode) {
//         print('Current location: $position');
//       }
//       return position;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Failed to get location: $e');
//       }
//       return null;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rct/shared_pref.dart';

class LocationPermissionHandler {
  static final LocationPermissionHandler _instance =
      LocationPermissionHandler._internal();
  factory LocationPermissionHandler() => _instance;
  LocationPermissionHandler._internal();

  bool _hasPermission = false;

  // Request location permission
  Future<bool> requestLocationPermission() async {
    if (_hasPermission) return true;

    // final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   if (kDebugMode) {
    //     print('Location services are disabled');
    //     AppPreferences.saveData(key: "Locationtest", value: "true");
    //   } else {
    //     AppPreferences.saveData(key: "Locationtest", value: "false");
    //     return false;
    //   }
    // }

    var permission = await Geolocator.checkPermission();
    if (await Permission.location.isDenied) {
      await Permission.location.request();
      if (await Permission.location.isDenied) {
        if (kDebugMode) {
          print('Location permission denied');
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print(
            'Location permission permanently denied. Redirecting to app settings.');
      }
      await openAppSettings();
      return false;
    }

    _hasPermission = true;
    return true;
  }

  // Get current location if permission is granted
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (kDebugMode) {
        print('Current location: $position');
      }
      return position;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get location: $e');
      }
      return null;
    }
  }
}

class LocationCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Check')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await checkLocation(context);
          },
          child: Text('Check Location'),
        ),
      ),
    );
  }

  // Check if location services are enabled and request permission if needed
  Future<void> checkLocation(BuildContext context) async {
    final locationHandler = LocationPermissionHandler();

    // Check if we can get the current location
    final position = await locationHandler.getCurrentLocation();
    if (position == null) {
      // Show a dialog to prompt the user to enable location services or permissions
      _showLocationDialog(context);
    } else {
      // Successfully obtained the location
      print('Location obtained: $position');
    }
  }

  // Show a dialog to prompt the user to enable location services or grant permission
  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text(
            'Please enable location services or grant location permission to proceed.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Optionally, open app settings to enable location
                await openAppSettings();
              },
              child: Text('Open Settings'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
