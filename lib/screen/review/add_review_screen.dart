// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
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
//     return Scaffold(
//       appBar: afterLoginHeader(
//         automaticallyImplyLeading: false,
//         context: context,
//       ),
//       extendBodyBehindAppBar: false,
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 300,
//                 width: double.infinity,
//                 color: Colors.grey[300],
//                 child: Center(
//                   child: Text('지도 이미지'),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(5, (index) {
//                   return Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                       child: GestureDetector(
//                         onTap: () => _pickImage(index),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
//                           child: Container(
//                             height: 120,
//                             color: Colors.grey[500],
//                             child: _images[index] == null
//                                 ? Icon(Icons.camera_alt, color: Colors.white70,)
//                                 : kIsWeb
//                                 ? Image.network(_images[index]!.path, fit: BoxFit.cover)
//                                 : Image.file(File(_images[index]!.path), fit: BoxFit.cover),
//                           ),
//                         ),
//                       ),
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
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _cancel,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white, // Background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           side: BorderSide(color: Colors.blue, width: 1.0),
//                         ),
//                       ),
//                       child: Text(
//                         '취소',
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _submit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue, // Background color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           side: BorderSide(color: Colors.blue, width: 1.0),
//                         ),
//                       ),
//                       child: Text(
//                         '등록',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  int _charCount = 0;
  final int _maxCharCount = 300;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _textController.addListener(_updateCharCount);
  }

  @override
  void dispose() {
    _textController.removeListener(_updateCharCount);
    _textController.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _textController.text.length;
      if (_charCount > _maxCharCount) {
        _textController.text = _textController.text.substring(0, _maxCharCount);
        _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _maxCharCount),
        );
      }
    });
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
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[300],
                child: Center(
                  child: Text('지도 이미지'),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () => _pickImage(index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                          child: Container(
                            height: 120,
                            color: Colors.grey[500],
                            child: _images[index] == null
                                ? Icon(Icons.camera_alt, color: Colors.white70,)
                                : kIsWeb
                                ? Image.network(_images[index]!.path, fit: BoxFit.cover)
                                : Image.file(File(_images[index]!.path), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: '여름 휴가로 부산에 놀러 왔습니다. ~~',
                  counterText: '',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$_charCount/$_maxCharCount',
                  style: TextStyle(color: Colors.grey),
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
                      onPressed: _cancel,
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
                      onPressed: _submit,
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