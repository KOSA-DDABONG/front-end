import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'board_register_postDTO_model.dart';

class BoardRegisterRequestModel {
  BoardRegisterRequestModel({
    required this.postDto,
    required this.files,
  });

  final PostDTOModel postDto;
  final List<XFile?> files;

  Future<FormData> toFormData() async {
    final List<MultipartFile> sendImages = [];
    final postDtoJson = jsonEncode(postDto.toJson());
    final _formData;

    for (var file in files) {
      if (file != null) {
        Uint8List fileBytes = await file.readAsBytes();
        sendImages.add(MultipartFile.fromBytes(
          fileBytes,
          filename: file.name,
          contentType: MediaType('image', file.mimeType!.split('/')[1]),
        ));
      }
    }

    _formData = FormData.fromMap({
      'postDTO': postDtoJson,
      'files': sendImages
    });

    return _formData;
  }
}
