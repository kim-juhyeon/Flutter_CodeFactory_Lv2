//서버에 있는 코드를 따로 불러오는 이유 : 서버에서 가져오는 파일 곧 변수들은
//불러온는 코드에서 잘 못 입력을 해도 오류가 발생하지 않기 때문에 따로 서버에서 불러온 변수값들을 저장한다. 휴먼실수를 줄이기 위해서 진행함
import '../../common/const/data.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });
//RestuarnatMpdel 을 factory화 하는 이유: 변수 값을 작업하기 편하기 위해 진행을한다.
// RestuarnatMpdel 을 fromejson으로 변환 그리고 json은 map형태로 요청, json map코드는 string,dynamic은 국룰
  factory RestaurantModel.fromeJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      thumbUrl: 'http://$ip${json['thumbUrl']}',
      tags: List<String>.from(json['tags']),
      //priceRange에는 expensive,medium,cheap 값이 enum에 들어가 있는데 item에 priceRange에 똑같은 값을 찾는다.
      priceRange: RestaurantPriceRange.values.firstWhere(
        (e) => e.name == json['priceRange'],
      ),
      ratings: json['ratings'],
      ratingsCount: json['ratingsCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'],
    );
  }
}
