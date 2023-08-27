import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/model_with_id.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/rating/model/rating_model.dart';
import 'package:retrofit/http.dart';

//abstract으로 인터페이스를 지정해줍니다. <T>값을 받아 rating, restaurantModel로 받을 것인지 확인합니다.
abstract class IBasePaginationRepository<T extends IModelWithId>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}