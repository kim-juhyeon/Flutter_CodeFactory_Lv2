import 'package:delivery_app/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../const/data.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);
  dio.interceptors.add(
    CustomInterceptor(storage: storage),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

// 1) 요청 보낼때
// 요청이 보내질때마다
// 만약에 요청의 Header에 accessToken : true라는 값이 있다면.
// 실제 토큰을 가져와서 (storage에서) authorization : barer $token으로 헤더 변경합니다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
//헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: REFRESH_TOKEN);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

// 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

// 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
// 401에러가 났을때 (status code)
// 토큰을 재발급 받는 시도를 하고 토큰이 재발듭되면
// 다시 새로운 토큰으로 요청을한다.
    print('[REQ] [${err.requestOptions.method}] ${err.requestOptions.uri}');
// refreshToken이 없으면 당연히 에러를 던집니다.
    final refreshToken = await storage.read(key: REFRESH_TOKEN);
//에러를 던질때는 handler.reject를 사용합니다.
    if (refreshToken == null) {
      return handler.reject(err);
    }
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';
    if (isStatus401 && !isPathRefresh) {
      try {
        final dio = Dio();
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        final accessToken = resp.data['accessToken'];

//토큰 변경하기
        final options = err.requestOptions;
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN, value: accessToken);
//요청 재전송
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } on DioError catch (e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
