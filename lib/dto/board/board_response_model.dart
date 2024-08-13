import 'board_model.dart';

BoardResponseModel boardResponseJson(Map<String, dynamic> json) =>
    BoardResponseModel.fromJson(json);

class BoardResponseModel {
  BoardResponseModel({
    required this.accessToken,
    required this.board,
  });

  late final String accessToken;
  late final Board board;

  BoardResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['jwtToken'];
    board = Board.fromJson(json['user'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jwtToken'] = accessToken;
    _data['user'] = board.toJson();
    return _data;
  }
}
