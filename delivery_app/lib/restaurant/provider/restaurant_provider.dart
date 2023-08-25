import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
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

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoding()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    //추가로 데이터를 더 가져오기
    // true - 추가로 데이터 가져옴
    // false - 새로고 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    //강제로 다시 로딩하기
    // ture - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      //5가지 가능성
      // state의 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상테
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginaitonError - 에러가 있는상태
      // 4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 때,

      //바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있음)
      // 2) 로딩중 - fetchMore : true (20개 데이터를 불러오고 있을때 또 불러오는 경우를 방지하기 위함)
      //    fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
      if (state is CursorPagination && !forceRefetch) {
        final pState = state
            as CursorPagination; //as 값을 state가 CursorPagination 상태라고 공표해준다. 위쪽 코드에서 정의해줬지만, 런타임에서 다시 한번 공표를 해줌
        if (!pState.meta.hasMore) {
          //hasMore는 다음 페이지에 데이터가 있는지 없는지에 대한 것입니다. CursorPagination은 이미 api통신으로 데이터를 가지고 있습니다. hasmore가 false 일경우에는 바로 기존 데이터를(paginate함수를 실행하지 않는다.) 반환합니다.
          return;
        }
      }
      final isLoading = state is CursorPaginationLoding;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      //2번 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }
      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      //fetchMore 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );
        paginationParams = paginationParams.copywith(
            after: pState
                .data.last.id //api 주소: after데이터 뒤에 id 값을 기입함으로써, 다음페이지를 가져오기 위함
            );
        //데이터를 처음부터 가져오는 상황
      } else {
        //만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch (API 요청)을 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
          //나머지 상황
        } else {
          state = CursorPaginationLoding();
        }
      }

      final resp =
          await repository.paginate(paginationParams: paginationParams);
      if (state is CursorPaginationFetchingMore) {
        //paginate로 새로운 데이터를 넘겨줍니다.
        final pState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(
          data: [
            ...pState.data, //새로운데이터
            ...resp.data, // 기존데이터터
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다.");
    }
  }

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
