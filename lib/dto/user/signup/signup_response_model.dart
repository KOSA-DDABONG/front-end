
import '../user_model.dart';

SignupResponseModel signupResponseJson(Map<String, dynamic> json) =>
    SignupResponseModel.fromJson(json);

class SignupResponseModel {
  SignupResponseModel({
    required this.user,
  });

  late final User user;

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user'] = user.toJson();
    return _data;
  }
}
