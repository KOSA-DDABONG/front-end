import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../component/header/header.dart';
import '../../component/map/get_map.dart';
import '../../key.dart';

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
  final List<String?> _imageUrls = List<String?>.filled(5, null, growable: false);
  final List<File?> _imageFiles = List<File?>.filled(5, null, growable: false);
  final int _maxHashtags = 5;
  bool _showHashtagLimitError = false;
  bool _showDuplicateHashtagError = false;
  bool _showNoHashtagError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
      body: _addReviewPageUI(),
    );
  }

  //후기 작성 페이지 UI
  Widget _addReviewPageUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 200.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText(),
            const SizedBox(height: 20),
            _subtitleText('일정 지도'),
            const SizedBox(height: 10,),
            _mapUI(),
            const SizedBox(height: 20),
            _subtitleText('사진 업로드'),
            const SizedBox(height: 10,),
            _imageSelectUI(),
            const SizedBox(height: 20),
            _subtitleText('후기 작성'),
            const SizedBox(height: 10,),
            _buildReviewContentField(maxLength: 100),
            const SizedBox(height: 20),
            _subtitleText('해시태그 입력'),
            const SizedBox(height: 10),
            _hashtagField(),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            _hashtagBtnUI(),
            const SizedBox(height: 30),
            _buttonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  //타이틀 텍스트
  Widget _titleText() {
    return const Text(
      '여행 후기 작성',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  //서브 타이틀 텍스트
  Widget _subtitleText(String subtitleText) {
    return Text(
      subtitleText,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  //지도
  Widget _mapUI() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
          width: 2.0,
        ),
      ),
      child: GetMap(
        apiKey: mapApiKey,
        origin: '37.819929,-122.478255',
        destination: '37.787994,-122.407437',
        waypoints: '37.76999,-122.44696|37.76899,-122.44596',
      ),
    );
  }

  //이미지 선택 UI
  Widget _imageSelectUI() {
    return Row(
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
                        ? const Icon(Icons.camera_alt, color: Colors.white70,)
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
    );
  }

  //이미지 선택 기능
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

  //후기 내용 입력란
  Widget _buildReviewContentField({int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: 5,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: 'ex) 여름 휴가를 목적으로 부산에 놀러왔습니다.',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        inputFormatters: [
          if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
        ],
      ),
    );
  }

  //해시태그 입력란
  Widget _hashtagField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _hashtagController,
            decoration: InputDecoration(
              hintText: '띄어쓰기 없이 입력하세요. ex) 힐링',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0), // 선택된 상태에서의 테두리 색상
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0), // 기본 상태에서의 테두리 색상
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addHashtag,
        ),
      ],
    );
  }

  //해시태그 추가
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

  //해시태그 제거
  void _removeHashtag(String tag) {
    setState(() {
      _hashtags.remove(tag);
    });
  }

  //생성된 해시태그
  Widget _hashtagBtnUI() {
    return Wrap(
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
          shape: const StadiumBorder(),
          elevation: 4,
        );
      }).toList(),
    );
  }

  //버튼 영역
  Widget _buttonField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _cancelBtnUI(),
        const SizedBox(width: 20),
        _submitBtnUI(),
      ],
    );
  }

  //취소 버튼
  Widget _cancelBtnUI() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AllReviewScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
        child: const Text(
          '취소',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  //등록 버튼
  Widget _submitBtnUI() {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.blue, width: 1.0),
          ),
        ),
        child: const Text(
          '등록',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}