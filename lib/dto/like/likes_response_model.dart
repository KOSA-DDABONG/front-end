import 'package:front/dto/like/likes_model.dart';

LikesResponseModel likesResponseJson(Map<String, dynamic> json) =>
    LikesResponseModel.fromJson(json);

class LikesResponseModel {
  LikesResponseModel({
    required this.message,
    required this.status,
    required this.likesModel,
  });

  late final String message;
  late final int status;
  late final LikesModel likesModel;

  LikesResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    likesModel = LikesModel.fromJson(json['member']);
  }

  //JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['member'] = [likesModel.toJson()];
    return _data;
  }
}
