import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/const/data.dart';
import 'package:lv2_codefactory/common/layout/default_layout.dart';
import 'package:lv2_codefactory/common/view/root_table.dart';
import 'package:lv2_codefactory/user/view/login_screen.dart';

import '../const/colors.dart';

// splashScreen 처음 생성될때 토큰을 가지고 있는지 확인
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //deleteToken();
    // initstate에는 await함수를 쓰지 못 하므로 checktoken의 클래스를 생성하여 분리하여 넣어준다.
    checkToken();
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    // storage.raad <- 미리 저장해둔 키 값을 불러올 수 있음.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    // 페이지 이동할 때 쌓인 페이지 다 지우고 이동하고 싶을 때! (pushAndRemoveUntill)
    /*정리
    리프레시토큰을 넣으면 storage에 있는 토큰을 가져와서 리프레시 토큰을 기반으로 access토큰을 발급을 받음*/
    final dio = Dio();

    try {
      final resp = await dio.post(
        //dio 패키지 options을 이용해서 token정보를 입력한다.
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      //재실행 할때마다 accesstoken이 갱신됩니다.
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
          (route) => false);
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          //만약에 토큰이 두개다 없을 때 로그인페이지로 넘어가고,
          builder: (_) => LoginScreen(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroudColor: PRIMARY_COLOR,
      //sizebox - MediaQuery를 먹여서 넓이를 최대 범위로 둔다.
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
