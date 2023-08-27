import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(
      restaurantProvider); //restaurantDetailProvider는 id 데이터를 가져오는 역할을 합니다.
  // id가 끝에 들어와야 after을 불러올 수 있기때문

  if (state is! CursorPagination) {
    return null;
  }
  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

//PaginationProvider에 T타입 : Model,U타입 : repository를 받을 수 있음
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });


  getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CussorPagination이 아니라면) 데이터를 가져오는 시도를 합니다.
    if (state is! CursorPagination) {
      await this.paginate();
    }
    // state가 Cursorpagination이 아닐때 그냥 return
    if (state is! CursorPagination) {
      return;
    }
    final pState = state as CursorPagination; //기존 state

    final resp = await repository.getRestaurantDetail(id: id); //id값을 교체한 state
    //[RestaturantModel(1), RestaurantModel(2), RestaurantModel(3)]
    // id : 2인 친구를 detail모델을 가져오자
    // getDetail(id: 2);
    // [RestaturantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
    state = pState.copyWith(
      data: pState.data
          .map<RestaurantModel>(
            (e) => e.id == id ? resp : e,
          )
          .toList(), //id를 교체하는 로직
    );
  }
}
