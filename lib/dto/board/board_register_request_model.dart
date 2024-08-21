import 'package:dio/dio.dart';

import 'board_register_files_model.dart';
import 'board_register_postDTO_model.dart';

class BoardRegisterRequestModel {
  BoardRegisterRequestModel({
    required this.postDto,
    required this.files
  });

  final PostDTOModel postDto;
  final List<FilesModel> files;

  // FormData로 변환하는 메서드
  FormData toFormData() {
    final _formData = FormData.fromMap({
      'postDto': postDto,
      'files': files,
    });
    return _formData;
  }
}