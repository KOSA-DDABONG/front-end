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
  List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);
  List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);
  Position? _currentPosition;
  int _charCount = 0;
  final int _maxCharCount = 100;
  final int _maxHashtags = 5;
  bool _showHashtagLimitError = false;
  bool _showDuplicateHashtagError = false;

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
    if (tag.isNotEmpty && !_hashtags.contains(tag)) {
      if (_hashtags.length < _maxHashtags) {
        setState(() {
          _hashtags.add(tag);
          _showHashtagLimitError = false;
          _showDuplicateHashtagError = false;
        });
        _hashtagController.clear();
      } else {
        setState(() {
          _showHashtagLimitError = true;
          _showDuplicateHashtagError = false;
        });
      }
    } else {
      setState(() {
        _showHashtagLimitError = false;
        _showDuplicateHashtagError = true;
      });
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

  void _cancel() {
    // Cancel logic
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
                          borderRadius: BorderRadius.circular(10.0),
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
              SizedBox(height: 10),
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
            ],
          ),
        ),
      ),
    );
  }
}
