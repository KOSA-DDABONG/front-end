import 'package:dio/dio.dart';

import 'session_service.dart';

final Dio authClient = Dio();

// 공통 HTTP 옵션 설정 함수
Options _httpOptions(String method, Map<String, String>? headers) {
  return Options(
    method: method,
    headers: headers,
  );
}

//POST 방식으로 JSON 데이터 전송
Future<Response> authPost(String url, Map<String, dynamic> body,
    {Map<String, String>? headers}) {
  return authClient.post(
    url,
    options: _httpOptions('POST', headers),
    data: body,
  );
}

void setupAuthClient() {
  authClient.interceptors.add(TokenInterceptor());
}

class TokenInterceptor extends Interceptor {
  int retryCount = 0;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await SessionService.getAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && retryCount < 3) {
      retryCount++;

      RequestOptions options =
          err.response?.requestOptions ?? RequestOptions(path: "");
      options.headers['Authorization'] =
      'Bearer ${await SessionService.getAccessToken()}';

      try {
        Response response = await authClient.fetch(options);

        String? newAccessToken =
        response.headers.value('Authorization')?.split(' ')[1];

        if (newAccessToken != null) {
          await SessionService.setAccessToken(newAccessToken);
        }

        retryCount = 0;
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    } else if (retryCount >= 3) {
      retryCount = 0;
      return handler.next(DioException(
        requestOptions: err.requestOptions,
        error: "Maximum retry limit reached."));
    }

    return handler.next(err);
  }
}
