import '../const/data.dart';

class DataUtils {
  //g.dart에는 url부분이 명시 되어있지 않으므로 static 으로 재빌딩을 시켜야 한다. g.dart에 포함 시킬 수 있도록
  static pathToUrl(String value) {
    return 'http://$ip$value';
  }
}
