// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// // import 'dart:ui' as ui;
// import 'dart:ui_web' as ui;
//
// import 'package:web/src/dom/html.dart';
//
// Widget getMap() {
//   String htmlId = "7";
//
//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//     final myLatlng = LatLng(31.5555, 111.3333);
//
//     final mapOptions = MapOptions()
//       ..zoom = 15
//       ..center = LatLng(31.5555, 111.3333);
//
//     final elem = DivElement()
//       ..id = htmlId
//       ..style.width = "100%"
//       ..style.height = "100%"
//       ..style.border = 'none';
//
//     final map = GMap(elem as HTMLElement?, mapOptions);
//
//     Marker(MarkerOptions()
//       ..position = myLatlng
//       ..map = map
//       ..title = 'Hello World!'
//     );
//
//     return elem;
//   });
//
//   return HtmlElementView(viewType: htmlId);
// }

//2
// import 'dart:html';
// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'package:geolocator/geolocator.dart';
// // import 'dart:ui' as ui;
// import 'dart:ui_web' as ui;
//
// import 'package:web/src/dom/html.dart';
//
// class getMap extends StatefulWidget {
//   @override
//   _getMapState createState() => _getMapState();
// }
//
// class _getMapState extends State<getMap> {
//   Position? _currentPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     print('hellohello0: initState()');
//     _getCurrentLocation();
//     print('hellohello1: initState()');
//   }
//
//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     print('hellohello2: _getCurrentLocation()');
//     // 위치 서비스가 활성화되어 있는지 확인
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     print('hellohello3: _getCurrentLocation()');
//     print(serviceEnabled);
//     if (!serviceEnabled) {
//       print('hellohello4: _getCurrentLocation()');
//       await Geolocator.openLocationSettings();
//       print('hellohello5: _getCurrentLocation()');
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     print('hellohello6: _getCurrentLocation()');
//     print(permission);
//     if (permission == LocationPermission.denied) {
//       print('hellohello7: _getCurrentLocation()');
//       permission = await Geolocator.requestPermission();
//       print('hellohello8: _getCurrentLocation()');
//       if (permission == LocationPermission.denied) {
//         print('hellohello9: _getCurrentLocation()');
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       print('hellohello10: _getCurrentLocation()');
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     print('hellohello11: _getCurrentLocation()');
//
//     setState(() {
//       _currentPosition = position;
//       print('hellohello12: _getCurrentLocation()');
//     });
//   }
//
//   Widget _getMap() {
//     String htmlId = "map-container";
//     print('hellohello13: _getMap()');
//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//       final myLatlng = LatLng(
//           _currentPosition?.latitude ?? 31.5555, _currentPosition?.longitude ?? 111.3333);
//       print('hellohello14: _getMap()');
//       final mapOptions = MapOptions()
//         ..zoom = 15
//         ..center = myLatlng;
//       print('hellohello15: _getMap()');
//       final elem = DivElement()
//         ..id = htmlId
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';
//       print('hellohello16: _getMap()');
//       final map = GMap(elem as HTMLElement?, mapOptions);
//       print('hellohello17: _getMap()');
//       Marker(MarkerOptions()
//         ..position = myLatlng
//         ..map = map
//         ..title = 'Current Location');
//       print('hellohello18: _getMap()');
//       return elem;
//     });
//     print('hellohello19: _getMap()');
//     return HtmlElementView(viewType: htmlId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentPosition == null
//           ? Center(child: CircularProgressIndicator())
//           : _getMap(),
//     );
//   }
// }


//3
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:google_maps/google_maps.dart';
import 'package:geolocator/geolocator.dart';
// import 'dart:ui' as ui;
import 'dart:ui_web' as ui;

import 'package:web/src/dom/html.dart';

class getMap extends StatefulWidget {
  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<getMap> {
  Position? _currentPosition;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
      _isMapReady = true;  // 위치가 준비되면 지도를 로드할 준비 완료
    });
  }

  Widget _getMap() {
    String htmlId = "map-container";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      if (_currentPosition == null) {
        return DivElement(); // 위치가 없으면 빈 div 반환
      }

      final myLatlng = LatLng(
          _currentPosition?.latitude ?? 31.5555, _currentPosition?.longitude ?? 111.3333);

      final mapOptions = MapOptions()
        ..zoom = 15
        ..center = myLatlng;

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem as HTMLElement?, mapOptions);

      Marker(MarkerOptions()
        ..position = myLatlng
        ..map = map
        ..title = 'Current Location');

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isMapReady
          ? Center(child: CircularProgressIndicator())
          : _getMap(),
    );
  }
}
