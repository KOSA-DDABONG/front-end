import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../component/header.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _hashtagController = TextEditingController();
  final List<XFile?> _images = List<XFile?>.filled(5, null, growable: false);
  final ImagePicker _picker = ImagePicker();
  final List<String> _hashtags = [];
  List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);  // 웹 플랫폼용 이미지 URL
  List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);    // 모바일/데스크톱 플랫폼용 이미지 파일
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인합니다.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스를 활성화하도록 요청합니다.
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한이 거부된 경우 처리합니다.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부된 경우 처리합니다.
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = position;
    });
  }

  void _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images[index] = image;
        if (kIsWeb) {
          _imageUrls[index] = image.path;
        } else {
          _imageFiles[index] = File(image.path);
        }
      });
    } else {
      print('이미지 선택이 취소되었습니다.');
    }
  }

  void _addHashtag() {
    final String tag = _hashtagController.text.trim();
    if (tag.isNotEmpty && !_hashtags.contains(tag)) {
      setState(() {
        _hashtags.add(tag);
      });
      _hashtagController.clear();
    }
  }

  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
  }

  void _submit() {
    // 등록 버튼 눌렀을 때의 처리 로직을 여기에 작성하세요.
  }

  void _cancel() {
    // 취소 버튼 눌렀을 때의 처리 로직을 여기에 작성하세요.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200.0),
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                child: SizedBox(
                )
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      // width: 60,
                      // height: 60,
                      color: Colors.grey[300],
                      child: _images[index] == null
                          ? Icon(Icons.camera_alt)
                          : kIsWeb
                          ? Image.network(_images[index]!.path, fit: BoxFit.cover)
                          : Image.file(File(_images[index]!.path), fit: BoxFit.cover),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: '여름 휴가로 부산에 놀러 왔습니다. ~~',
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hashtagController,
                      decoration: InputDecoration(
                        hintText: '해시태그를 입력하세요',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addHashtag,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: _hashtags.map((tag) {
                  return Chip(
                    label: Text('#$tag'),
                    onDeleted: () => _removeHashtag(tag),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                      child: Text(
                        '등록',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
//
// import '../../component/header.dart';
//
// class AddReviewScreen extends StatefulWidget {
//   const AddReviewScreen({Key? key}) : super(key: key);
//
//   @override
//   _AddReviewScreenState createState() => _AddReviewScreenState();
// }
//
// class _AddReviewScreenState extends State<AddReviewScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final TextEditingController _hashtagController = TextEditingController();
//   final List<XFile?> _images = List<XFile?>.filled(5, null, growable: false);
//   final ImagePicker _picker = ImagePicker();
//   final List<String> _hashtags = [];
//   List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);  // 웹 플랫폼용 이미지 URL
//   List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);    // 모바일/데스크톱 플랫폼용 이미지 파일
//   Position? _currentPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   void _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // 위치 서비스가 활성화되어 있는지 확인합니다.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // 위치 서비스를 활성화하도록 요청합니다.
//       await Geolocator.openLocationSettings();
//       return;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // 권한이 거부된 경우 처리합니다.
//         return;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // 권한이 영구적으로 거부된 경우 처리합니다.
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _currentPosition = position;
//     });
//   }
//
//   void _pickImage(int index) async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       setState(() {
//         _images[index] = image;
//         if (kIsWeb) {
//           _imageUrls[index] = image.path;
//         } else {
//           _imageFiles[index] = File(image.path);
//         }
//       });
//     } else {
//       print('이미지 선택이 취소되었습니다.');
//     }
//   }
//
//   void _addHashtag() {
//     final String tag = _hashtagController.text.trim();
//     if (tag.isNotEmpty && !_hashtags.contains(tag)) {
//       setState(() {
//         _hashtags.add(tag);
//       });
//       _hashtagController.clear();
//     }
//   }
//
//   void _removeHashtag(String tag) {
//     setState(() {
//       _hashtags.remove(tag);
//     });
//   }
//
//   void _submit() {
//     // 등록 버튼 눌렀을 때의 처리 로직을 여기에 작성하세요.
//   }
//
//   void _cancel() {
//     // 취소 버튼 눌렀을 때의 처리 로직을 여기에 작성하세요.
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     GoogleMapController? _controller;
//     return Scaffold(
//       appBar: afterLoginHeader(
//         automaticallyImplyLeading: false,
//         context: context,
//       ),
//       extendBodyBehindAppBar: true,
//       backgroundColor: Color(0xffe4f4ff),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Container(
//                 height: 300,
//                 width: 300,
//                 child: kIsWeb ? _buildGoogleMapWeb() : _buildGoogleMap(),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(5, (index) {
//                   return GestureDetector(
//                     onTap: () => _pickImage(index),
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       color: Colors.grey[300],
//                       child: _images[index] == null
//                           ? Icon(Icons.camera_alt)
//                           : kIsWeb
//                           ? Image.network(_images[index]!.path, fit: BoxFit.cover)
//                           : Image.file(File(_images[index]!.path), fit: BoxFit.cover),
//                     ),
//                   );
//                 }),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 controller: _textController,
//                 decoration: InputDecoration(
//                   hintText: '여름 휴가로 부산에 놀러 왔습니다. ~~',
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _hashtagController,
//                       decoration: InputDecoration(
//                         hintText: '해시태그를 입력하세요',
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.add),
//                     onPressed: _addHashtag,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Wrap(
//                 spacing: 10,
//                 children: _hashtags.map((tag) {
//                   return Chip(
//                     label: Text('#$tag'),
//                     onDeleted: () => _removeHashtag(tag),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _cancel,
//                     child: Text('취소'),
//                   ),
//                   ElevatedButton(
//                     onPressed: _submit,
//                     child: Text('등록'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGoogleMapWeb() {
//     return HtmlElementView(viewType: 'google-maps');
//   }
//
//   Widget _buildGoogleMap() {
//     GoogleMapController? _controller;
//     return GoogleMap(
//       onMapCreated: (controller) {
//         _controller = controller;
//       },
//       initialCameraPosition: CameraPosition(
//           target: LatLng(31.5555, 111.3333),
//           zoom: 15.0
//       ),
//       myLocationEnabled: true,
//       markers: _buildMarkers(),
//     );
//   }
//
//   Set<Marker> _buildMarkers() {
//     return {
//       Marker(
//           markerId: MarkerId('current_location'),
//           position: LatLng(31.5555, 111.3333),
//           infoWindow: InfoWindow(title: '현재 위치')
//       )
//     };
//   }
// }



// _currentPosition == null
// ? Center(child: CircularProgressIndicator())
//     : NaverMap(
// options: NaverMapViewOptions(
// initialCameraPosition: NCameraPosition(
// target: NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
// zoom: 14,
// ),
// mapType: NMapType.basic,
// activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
// ),
// onMapReady: (myMapController) {
// debugPrint("네이버 맵 로딩됨!");
// },
// onMapTapped: (point, latLng) {
// debugPrint("${latLng.latitude}, ${latLng.longitude}");
// },
// ),