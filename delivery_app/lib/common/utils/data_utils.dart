

import '../const/data.dart';

class DataUtils{
  static String pathToUrl(String value){
    return 'http://$ip$value';
  }
// rating에서 오는 이미지 url은 리스트로 오기 때문에 따로 맵핑을 진행해야 합니다.
  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();

  }
}