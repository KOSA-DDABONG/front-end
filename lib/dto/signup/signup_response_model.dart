import '../user_model.dart';

SignupResponseModel signupResponseJson(Map<String, dynamic> json) =>
    SignupResponseModel.fromJson(json);

class SignupResponseModel {
  SignupResponseModel({
    // required this.accessToken,
    // required this.refreshToken,
    required this.user,
  });

  // late final String accessToken;
  // late final String refreshToken;
  late final User user;

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    // accessToken = json['accessToken'];
    // refreshToken = json['refreshToken'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['accessToken'] = accessToken;
    // _data['refreshToken'] = refreshToken;
    _data['user'] = user.toJson();
    return _data;
  }
}
