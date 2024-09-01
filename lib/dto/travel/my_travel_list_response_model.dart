import 'my_travel_list_data_model.dart';

MyTravelListResponseModel myTravelListResponseJson(Map<String, dynamic> json) =>
    MyTravelListResponseModel.fromJson(json);

class MyTravelListResponseModel {
  MyTravelListResponseModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final List<MyTravelListDataModel> data;

  MyTravelListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = List<MyTravelListDataModel>.from(
        json['data'].map((item) => MyTravelListDataModel.fromJson(item))
    );
  }
}
