import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import '../../component/map/get_map.dart';
import '../../component/header/header.dart';

//해결해야할 일
//지도 api 불러와서 띄우기(웹)

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
  List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);
  List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);
  Position? _currentPosition;
  int _charCount = 0;
  final int _maxCharCount = 100;
  final int _maxHashtags = 5;
  bool _showHashtagLimitError = false;
  bool _showDuplicateHashtagError = false;
  bool _showNoHashtagError = false;



  //Test
  final List<LatLng> _day1Coordinates = [
    LatLng(37.42796133580664, -122.085749655962),
    LatLng(37.42896133580664, -122.086749655962),
    LatLng(37.42996133580664, -122.087749655962),
  ];

  final List<LatLng> _day2Coordinates = [
    LatLng(37.43096133580664, -122.088749655962),
    LatLng(37.43196133580664, -122.089749655962),
    LatLng(37.43296133580664, -122.090749655962),
    LatLng(37.43396133580664, -122.091749655962),
  ];
  //


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
    if(tag.isEmpty) {
      setState(() {
        _showNoHashtagError = true;
        _showHashtagLimitError = false;
        _showDuplicateHashtagError = false;
      });
    }
    else {
      if (tag.isNotEmpty && !_hashtags.contains(tag)) {
        if (_hashtags.length < _maxHashtags) {
          setState(() {
            _hashtags.add(tag);
            _showHashtagLimitError = false;
            _showDuplicateHashtagError = false;
            _showNoHashtagError = false;
          });
          _hashtagController.clear();
        } else {
          setState(() {
            _showHashtagLimitError = true;
            _showDuplicateHashtagError = false;
            _showNoHashtagError = false;
          });
        }
      } else {
        setState(() {
          _showHashtagLimitError = false;
          _showDuplicateHashtagError = true;
          _showNoHashtagError = false;
        });
      }
    }
  }

  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
  }

  void _submit() {
    // Submit logic
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AfterLoginHeader(
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
              Text(
                '여행 후기 작성',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Text(
                '일정 지도',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue, // 테두리 색상
                    width: 2.0, // 테두리 두께
                  ),
                ),
                // child: GetMap(),
                child: GetMap(day1Coordinates: _day1Coordinates, day2Coordinates: _day2Coordinates),
              ),
              SizedBox(height: 20),
              Text(
                '사진 업로드',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: GestureDetector(
                        onTap: () => _pickImage(index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
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
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              Text(
                '후기 작성',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'ex) 여름 휴가를 목적으로 부산에 놀러 왔습니다.',
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
              Text(
                '해시태그 입력',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hashtagController,
                      decoration: InputDecoration(
                        hintText: '띄어쓰기 없이 입력하세요. ex) 힐링',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addHashtag,
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_showNoHashtagError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '입력된 해시태그가 없습니다.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_showHashtagLimitError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '달 수 있는 해시태그의 개수는 최대 $_maxHashtags개 입니다.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_showDuplicateHashtagError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '이미 존재하는 해시태그입니다.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: _hashtags.map((tag) {
                  return Chip(
                    label: Text(
                      '#$tag',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onDeleted: () => _removeHashtag(tag),
                    backgroundColor: Colors.grey[200],
                    deleteIconColor: Colors.grey[600],
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    shape: StadiumBorder(),
                    elevation: 4, // 그림자 설정
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context!,
                          MaterialPageRoute(builder: (context) => AllReviewScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
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
                        backgroundColor: Colors.blue,
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
  Set<Marker> _buildMarkers() {
    return {
      Marker(
        markerId: MarkerId('current location'),
        position: LatLng(31.5555, 111.3333),
        infoWindow: InfoWindow(title: '현재 위치'),
      )
    };
  }
}