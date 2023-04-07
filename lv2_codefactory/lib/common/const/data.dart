import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
//로그인 눌렀을 경우 토큰이 불러오는데 토큰을 securestorage 패키지에 담는다.
//final storage = FlutterSecureStorage(); <- provider 진행으로 지움 글로벌함수는 provider에

const emulatorIP = '10.0.2.2:3000';
const simulatorIP = '127.0.0.1:3000';
//platfrom 불러 올때 dart.io 임
/* 에뮬레이터, 시뮬레이터에 따라 IP주소가 달라서 Platform 위젯을 통해 flexible한 로직을 구현*/
final ip = Platform.isIOS ? simulatorIP : emulatorIP;
