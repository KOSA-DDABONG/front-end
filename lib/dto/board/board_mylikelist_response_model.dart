import 'board_model.dart';

MyLikesListResponseModel myLikesListResponseJson(Map<String, dynamic> json) =>
    MyLikesListResponseModel.fromJson(json);

class MyLikesListResponseModel {
  MyLikesListResponseModel({
    required this.message,
    required this.status,
    this.myLikesList,
  });

  late final String message;
  late final int status;
  List<AllBoardList>? myLikesList;

  MyLikesListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    myLikesList = (json['top3'] as List<dynamic>?)?.map((item) => AllBoardList.fromJson(item)).toList(); // top3에서 리스트 추출
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['top3'] = myLikesList?.map((board) => board.toJson()).toList(); // 리스트를 data1에 포함
    return _data;
  }
}
