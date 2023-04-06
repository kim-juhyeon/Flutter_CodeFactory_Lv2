import 'package:dio/dio.dart' hide Headers;
import 'package:lv2_codefactory/restaurant/model/restaurant_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

/* api를 불러올때 중복값들을 최대한 줄이기 위해 restrofit을 진행함.
인스턴스화가 되지 않게 abstract 해야 함*/
@RestApi()
abstract class RestaurantRepository {
  //http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;
  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate();
  //http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  //RestaurantDetailModel 은 detailpage값에 데이터값 , path() required String id = path()값에 id 값으로 대체해라.
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
//