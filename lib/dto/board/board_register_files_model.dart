import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FilesModel {
  FilesModel({
    required this.image,
  });

  final XFile image;

  Future<http.MultipartFile> toMultipartFile() async {
    final bytes = await image.readAsBytes();
    final filename = image.name;

    return http.MultipartFile.fromBytes(
      'files',
      bytes,
      filename: filename,
    );
  }
}