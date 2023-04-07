/*1.요청을 보낼때, 2.응답을 보낼때, 3.에러가 났을때 */
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lv2_codefactory/common/const/data.dart';
import 'package:lv2_codefactory/common/secure_storage/secure_storage.dart';

//ref는 또라른 provider를 불러오는 함수,
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
  /*1. 요청을 보낼때
  요청이 보내질때마다 만약에 요청의 Header에 accessToken: true라는 값이 있다면 실제 토큰을 가져와서 
  (storage에서) authorization:bearer $token으로 헤더를 변경한다.*/

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ][${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    if (options.headers['refreshToken'] == 'true') {
      //헤더 삭제
      options.headers.remove('refreshToken');
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      //실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
//인터셉트 : 요청을 중간에 가로채는 순간에 실행이 되는것이고  요청을 가로채고 handler가 결정한다.
    return super.onRequest(options, handler);
  }

  //2.응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES][${response.requestOptions.method}] ${response.requestOptions.uri}');
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    print('[ERR][${err.requestOptions.method}] ${err.requestOptions.uri}');
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken이 없으면 에러를 던진다.
    if (refreshToken == null) {
      handler.reject(err);
      return;
    }
    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';
/*새로 고침 토큰이 있는 경우 코드는 오류 상태 코드가 401인지, 요청 경로가 /auth/token이 아닌지 확인합니다. 두 조건이 모두 충족되면 Dio의 
새 인스턴스를 생성하고 헤더의 새로 고침 토큰을 사용하여 새 액세스 토큰을 얻기 위해 서버에 새 요청을 보냅니다. */
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;
        //토큰변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });
        //새 액세스 토큰이 추출되어 원래 요청의 'authorization' 헤더를 업데이트하는 데 사용되며 요청은 'dio' 인스턴스를 사용하여 재전송됩니다
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
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
