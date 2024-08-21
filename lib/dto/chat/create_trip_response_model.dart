CreateTripResponseModel createTripResponseJson(Map<String, dynamic> json) =>
    CreateTripResponseModel.fromJson(json);

class CreateTripResponseModel {
  CreateTripResponseModel({
    required this.response,
  });

  late final String response;

  CreateTripResponseModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
  }
}
