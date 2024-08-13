import 'package:dio/dio.dart';

class LoginRequestModel {
  LoginRequestModel({
    this.userId,
    this.password,
  });

  late final String? userId;
  late final String? password;

  LoginRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
  }

  //Json 형태(Raw)로 변환하는 메서드
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['password'] = password;
    return _data;
  }

  // FormData로 변환하는 메서드
  FormData toFormData() {
    final _formData = FormData.fromMap({
      'userId': userId,
      'password': password,
    });
    return _formData;
  }
}
