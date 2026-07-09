// import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
// import 'package:rct/constants/linkapi.dart';

// class PinLocationScreen extends StatefulWidget {
//   final Function(PickResult) onPlacePicked;

//   PinLocationScreen({Key? key, required this.onPlacePicked}) : super(key: key);

//   static const kInitialPosition = LatLng(-33.8567844, 151.213108);

//   final GoogleMapsFlutterPlatform mapsImplementation =
//       GoogleMapsFlutterPlatform.instance;

//   @override
//   _PinLocationScreenState createState() => _PinLocationScreenState();
// }

// class _PinLocationScreenState extends State<PinLocationScreen> {
//   PickResult? selectedPlace;
//   bool _mapsInitialized = false;
//   final String _mapsRenderer = "latest";

//   void initRenderer() {
//     if (_mapsInitialized) return;
//     if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
//       switch (_mapsRenderer) {
//         case "legacy":
//           (widget.mapsImplementation as GoogleMapsFlutterAndroid)
//               .initializeWithRenderer(AndroidMapRenderer.legacy);
//           break;
//         case "latest":
//           (widget.mapsImplementation as GoogleMapsFlutterAndroid)
//               .initializeWithRenderer(AndroidMapRenderer.latest);
//           break;
//       }
//     }
//     setState(() {
//       _mapsInitialized = true;
//     });
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   initRenderer();
//   // }

//   Widget build(BuildContext context) {
//     Function(PickResult) onPlacePicked = widget.onPlacePicked;
//     return PlacePicker(
//       resizeToAvoidBottomInset: false, // only works in page mode, less flickery
//       apiKey: googleMapsAPIKey,
//       hintText: "Find a place ...",
//       searchingText: "Please wait ...",
//       selectText: "Select place",
//       outsideOfPickAreaText: "Place not in area",
//       initialPosition: PinLocationScreen.kInitialPosition,
//       useCurrentLocation: true,
//       selectInitialPosition: true,
//       usePinPointingSearch: true,
//       usePlaceDetailSearch: true,
//       zoomGesturesEnabled: true,
//       zoomControlsEnabled: true,
//       ignoreLocationPermissionErrors: true,
//       onMapCreated: (GoogleMapController controller) {
//         print("Map created");
//       },
//       onPlacePicked: onPlacePicked,
//       onMapTypeChanged: (MapType mapType) {
//         print("Map type changed to ${mapType.toString()}");
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class PinLocationScreen extends StatefulWidget {
  final Function(PickResult) onPlacePicked;

  PinLocationScreen({Key? key, required this.onPlacePicked}) : super(key: key);

  static const kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;

  @override
  _PinLocationScreenState createState() => _PinLocationScreenState();
}

class _PinLocationScreenState extends State<PinLocationScreen> {
  PickResult? selectedPlace;
  bool _mapsInitialized = false;
  final String _mapsRenderer = "latest";

  // void initRenderer() {
  //   if (_mapsInitialized) return;
  //   if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
  //     switch (_mapsRenderer) {
  //       case "legacy":
  //         (widget.mapsImplementation as GoogleMapsFlutterAndroid).initializeWithRenderer(AndroidMapRenderer.legacy);
  //         break;
  //       case "latest":
  //         (widget.mapsImplementation as GoogleMapsFlutterAndroid).initializeWithRenderer(AndroidMapRenderer.latest);
  //         break;
  //     }
  //   }
  //   setState(() {
  //     _mapsInitialized = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Function(PickResult) onPlacePicked = widget.onPlacePicked;

    // Choose the correct API key based on the platform
    // final String apiKey = Platform.isIOS
    //     ? 'AIzaSyBAEgd6sTshM5t8VCb79d7YTINYSAm_kG8' // iOS API key
    //     : 'AIzaSyDYinSZ14Vg2u4XtOTvCN5i4HhIMBjIkIs'; // Android API key

    final String apiKey ="AIzaSyDYinSZ14Vg2u4XtOTvCN5i4HhIMBjIkIs";

    return PlacePicker(
      resizeToAvoidBottomInset: false,
      // only works in page mode, less flickery
      apiKey: apiKey,
      hintText: "Find a place ...",
      searchingText: "Please wait ...",
      selectText: "Select place",
      outsideOfPickAreaText: "Place not in area",
      initialPosition: PinLocationScreen.kInitialPosition,
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePinPointingSearch: true,
      usePlaceDetailSearch: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      ignoreLocationPermissionErrors: true,
      onMapCreated: (GoogleMapController controller) {
        print("Map created");
      },
      onPlacePicked: onPlacePicked,
      onMapTypeChanged: (MapType mapType) {
        print("Map type changed to ${mapType.toString()}");
      },
    );
  }
}
