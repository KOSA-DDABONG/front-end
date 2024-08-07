import '../user_model.dart';

LoginResponseModel loginResponseJson(Map<String, dynamic> json) =>
    LoginResponseModel.fromJson(json);

class LoginResponseModel {
  LoginResponseModel({
    required this.accessToken,
    // required this.refreshToken,
    required this.user,
  });

  late final String accessToken;
  // late final String refreshToken;
  late final User user;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['jwtToken'];
    // refreshToken = json['refreshToken'];
    user = User.fromJson(json['user'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jwtToken'] = accessToken;
    // _data['refreshToken'] = refreshToken;
    _data['user'] = user.toJson();
    return _data;
  }
}
