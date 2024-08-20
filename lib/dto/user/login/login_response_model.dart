
import '../user_model.dart';

LoginResponseModel loginResponseJson(Map<String, dynamic> json) =>
    LoginResponseModel.fromJson(json);

class LoginResponseModel {
  LoginResponseModel({
    required this.username,
    required this.nickname,
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.birth,
    required this.createdTime,
    required this.recessAccess,
    required this.accessToken,
  });

  late final String username;
  late final String nickname;
  late final String userId;
  late final String email;
  late final String phoneNumber;
  late final String birth;
  late final String createdTime;
  late final String recessAccess;
  late final String accessToken;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    nickname = json['nickname'];
    userId = json['userId'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    birth = json['birth'];
    createdTime = json['createdTime'];
    recessAccess = json['recessAccess'];
    accessToken = json['jwtToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['nickname'] = nickname;
    _data['userId'] = userId;
    _data['email'] = email;
    _data['phoneNumber'] = phoneNumber;
    _data['birth'] = birth;
    _data['createdTime'] = createdTime;
    _data['recessAccess'] = recessAccess;
    _data['jwtToken'] = accessToken;
    return _data;
  }
}
