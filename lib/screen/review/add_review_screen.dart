import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import '../../component/header.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<XFile?> _images = List<XFile?>.filled(5, null, growable: false);
  final ImagePicker _picker = ImagePicker();
  final List<String> _hashtags = ['부산', '해변', '해운대', '도심 속 바다', '휴양', '뜨거움'];
  List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);  // 웹 플랫폼용 이미지 URL
  List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);    // 모바일/데스크톱 플랫폼용 이미지 파일

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
      backgroundColor: Color(0xffe4f4ff),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.5665, 126.9780), // 서울의 위도와 경도
                    zoom: 14.0,
                  ),
                  markers: {
                    Marker(markerId: MarkerId('spot1'), position: LatLng(37.5665, 126.9780)),
                    // Add more markers here
                  },
                ),
                // child: KakaoMap(
                //   onMapCreated: onMapCreated,
                //   initialCameraPosition: _kInitialPosition
                // ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _pickImage(index),
                    child: Container(
                      width: 60,
                      height: 60,
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
              Wrap(
                spacing: 10,
                children: _hashtags.map((tag) {
                  return Chip(
                    label: Text(tag),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _cancel,
                    child: Text('취소'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('등록'),
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
