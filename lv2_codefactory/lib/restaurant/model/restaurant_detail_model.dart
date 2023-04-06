import 'package:json_annotation/json_annotation.dart';
import 'package:lv2_codefactory/common/utils/data_utils.dart';
import 'package:lv2_codefactory/restaurant/model/restaurant_model.dart';

part 'restaurant_detail_model.g.dart';

//exteds를 이용하여 자식클래스가 상속 받을 수 있게한다. 상속을 통해서 값들을 가져올 수 있음
// 부모클래스가 바뀌면 자동으로 바뀔 수 있게,
@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
//product 값들이 리스트로 감싸져 있어서 외부에서 다시 클래스를 지정하고 다 맵핑을 진행하였다.
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);
}
