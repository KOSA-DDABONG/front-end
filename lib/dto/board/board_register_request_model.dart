// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
//
// class BoardRegisterRequestModel {
//   BoardRegisterRequestModel({
//     required this.content,
//     required this.hashtags,
//     this.images,
//   });
//
//   late final String content;
//   late final List<String> hashtags;
//   late final List<XFile?>? images; // List to hold image files (optional)
//
//   // Constructor to create the object from JSON (optional)
//   BoardRegisterRequestModel.fromJson(Map<String, dynamic> json) {
//     content = json['content'];
//     hashtags = List<String>.from(json['hashtags']);
//     // Note: Images are not included in JSON to FormData conversion
//   }
//
//   // Method to convert the object to a JSON map (for non-multipart use cases)
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['content'] = content;
//     _data['hashtags'] = hashtags;
//     return _data;
//   }
//
//   // Method to convert the object to FormData (for multipart/form-data requests)
//   FormData toFormData() {
//     final _formData = FormData.fromMap({
//       'content': content,
//       'hashtags': hashtags,
//     });
//
//     // Attach images to the FormData
//     if (images != null && images!.isNotEmpty) {
//       for (int i = 0; i < images!.length; i++) {
//         final XFile? image = images![i];
//         if (image != null) {
//           _formData.files.add(
//             MapEntry(
//               'images', // Field name for images
//               MultipartFile.fromFileSync(image.path, filename: image.name),
//             ),
//           );
//         }
//       }
//     }
//
//     return _formData;
//   }
// }

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // 웹에서 파일을 다룰 때 필요

class BoardRegisterRequestModel {
  BoardRegisterRequestModel({
    required this.content,
    required this.hashtags,
    required this.images, // XFile 또는 File 리스트
  });

  final String content;
  final List<String> hashtags;
  final List<dynamic> images; // 동적으로 XFile 또는 File을 처리

  // FormData로 변환
  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'content': content,
      'hashtags': hashtags,
    };

    final List<MultipartFile> files = [];

    if (kIsWeb) {
      // 웹에서 파일을 처리
      for (var image in images) {
        final bytes = image is XFile ? await image.readAsBytes() : (image as File).readAsBytesSync();
        files.add(MultipartFile.fromBytes(bytes, filename: 'image'));
      }
    }
    else {
    // 모바일에서 파일을 처리
      for (var image in images) {
        final file = image as File;
        files.add(MultipartFile.fromFileSync(file.path, filename: 'image'));
      }
    }

    return FormData.fromMap({
    ...data,
    'files': files,
    });
  }
}
