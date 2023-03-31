import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/view/splash_screen.dart';

void main() {
  runApp(
    const _App(),
  );
}

/* private 함수로 _app 변수를 받습니다. 
일전에는 void - material app 으로 진행했었는데 이번에는 void runApp으로 바로 main에서 시작*/
class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'NotoSans'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
