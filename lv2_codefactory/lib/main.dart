import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/component/custom_text_form_field.dart';

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              errorText: '에러가 있습니다.',
            ),
          ],
        ),
      ),
    );
  }
}
