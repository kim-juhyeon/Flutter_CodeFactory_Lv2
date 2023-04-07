import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_codefactory/common/const/colors.dart';
import 'package:lv2_codefactory/common/const/data.dart';
import 'package:lv2_codefactory/common/layout/default_layout.dart';
import 'package:lv2_codefactory/common/secure_storage/secure_storage.dart';
import 'package:lv2_codefactory/common/view/root_table.dart';

import '../../common/component/custom_text_form_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    return DefaultLayout(
      /*DefaultLayout 파일의 widget child를 받아온다.
      SafeArea - top,bottom 등 정할 수 있음 
      singleChildScrollView 밑에 있는 child를 스크롤 가능하게 해준다.*/
      child: SingleChildScrollView(
        //ui 꿀팁 keyboardDismissBehavior를 설정하여 입력창에 입력후 스크롤 할때 키보드가 자동으로 내려가게 된다.
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요.',
                  //onchanged - 텍스트필드에 값이 들어 올때마다 값을 불러오는 것
                  onChanged: (String value) {
                    //callback으로 value 값을 username에 계속 저장한다.
                    username = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    //ID :비밀번호
                    final rawString = '$username:$password';
                    print(rawString);

                    //일반 string 값을 base64로 변환 ID,PW값을 바로 쓰지 못하므로
                    //정리 : id,pw -> 인코드 -> dio 인코드 출력
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      /*dio 패키지 options을 이용해서 token정보를 입력한다.
                      정리 : id,pw -> 인코드 -> dio 인코드 출력*/
                      'http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );
                    //resp.data = 토큰바디값을 refreshToken에 담고 이것을 securestorage에 담는다.
                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];
                    
                    // 글로벌 함수 
                    final storage = ref.read(secureStorageProvider);

                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: refreshToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: PRIMARY_COLOR),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
