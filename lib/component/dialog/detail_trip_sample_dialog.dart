// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../key/key.dart';
// import '../map/get_map.dart';
//
// void showSampleDetailTripDialog(BuildContext context, String apiKey, Map<String, dynamic> scheduleInfo) {
//   int selectedDay = 1;
//
//   List<Marker> getMarkersForDay(int day, Map<String, dynamic> scheduleInfo) {
//     List<Marker> markers = [];
//     var dayInfo = scheduleInfo[day];
//
//     if (dayInfo != null) { // null 체크 추가
//       dayInfo.forEach((key, value) {
//         if (key == 'tourist_spots') {
//           for (var spot in value) {
//             print("this is hell");
//             print(spot[0]);
//             print(spot[1]);
//             print(spot[2]);
//             print("this is hell");
//             markers.add(
//               Marker(
//                 markerId: MarkerId(spot[0]),
//                 position: LatLng(spot[1], spot[2]),
//                 infoWindow: InfoWindow(title: spot[0]),
//                 icon: BitmapDescriptor.defaultMarkerWithHue(
//                   day == 1 ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange,
//                 ),
//               ),
//             );
//           }
//         } else {
//           markers.add(
//             Marker(
//               markerId: MarkerId(value[0]),
//               position: LatLng(value[1], value[2]),
//               infoWindow: InfoWindow(title: value[0]),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                 day == 1 ? BitmapDescriptor.hueRed : BitmapDescriptor.hueOrange,
//               ),
//             ),
//           );
//         }
//       });
//     }
//
//     return markers;
//   }
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5.0),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5.0),
//               ),
//               width: MediaQuery.of(context).size.width * 0.8,
//               height: MediaQuery.of(context).size.height * 0.8,
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 3,
//                     child: Container(
//                       margin: const EdgeInsets.all(20.0),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(5),
//                         child: GetMap(
//                           apiKey: GOOGLE_MAP_KEY,
//                           origin: '35.819929,129.478255',
//                           destination: '35.787994,129.407437',
//                           waypoints: '35.76999,129.44696',
//                           markers: getMarkersForDay(selectedDay, scheduleInfo),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // 나머지 UI 구성...
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
