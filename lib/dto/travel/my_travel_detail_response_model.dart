import 'my_travel_detail_data_model.dart';

MyTravelDetailResponseModel myTravelDetailResponseJson(Map<String, dynamic> json) =>
    MyTravelDetailResponseModel.fromJson(json);

class MyTravelDetailResponseModel {
  MyTravelDetailResponseModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final List<MyTravelDetailDataModel> data;

  MyTravelDetailResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    status = json['status'] ?? 0;
    data = (json['data'] as List<dynamic>)
        .map((item) => MyTravelDetailDataModel.fromJson(item))
        .toList();
  }
}
