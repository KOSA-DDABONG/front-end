import 'package:front/service/dio_client.dart';
import 'package:front/service/result.dart';
import 'package:front/service/session_service.dart';

import '../config.dart';
import '../dto/travel/my_travel_detail_response_model.dart';
import '../key/key.dart';

class TravelService {

  //여행 일정 상세 정보 조회
  static Future<Result<MyTravelDetailResponseModel>> getDetailOfTravelDetails(int travelId) async {
    final url = Uri.https(API_URL, Config.getDetailOfTravelInfoAPI+travelId.toString()).toString();
    // final url = Uri.http(Config.apiUrl, Config.getDetailOfTravelInfoAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
        'GET',
        url,
        headers: headers,
      );

      final jsonData = response.data;
      print("[상세 일정 조회] : $jsonData");
      return Result.success(
          myTravelDetailResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      print("[상세 일정 조회 에러] : $e");
      return Result.failure("[getDetailOfTravelDetails] An Error Occurred: $e");
    }
  }
}