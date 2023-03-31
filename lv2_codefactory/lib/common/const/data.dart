import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
//로그인 눌렀을 경우 토큰이 불러오는데 토큰을 securestorage 패키지에 담는다.
final storage = FlutterSecureStorage();
