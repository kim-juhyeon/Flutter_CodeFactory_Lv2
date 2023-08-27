import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/utils/pagination_utils.dart';
import 'package:delivery_app/restaurant/component/restaurant_card.dart';

import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';

import 'package:delivery_app/restaurant/view/restaurnat_detail_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollerListener);
  }

  void scrollerListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면, 새로운 데이터를 추가요청
    PaginationUtils.Paginate(
        controller: controller, provider: ref.read(restaurantProvider.notifier));
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);
    // 처음 로딩일경우
    if (data is CursorPaginationLoding) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    //에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }
    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = data as CursorPagination;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount: cp.data.length + 1, //꿀팁 : 데이터를 가져올때 일부러 한개를 더 추가합니다.
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Center(
                  child: data is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text('데이터가 없습니다.'),
                ),
              );
            }

            final pItem = cp.data[index];
            //final pItem = RestaurantModel.fromJson(item);
            //p : parse 약자
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RestaurantDetailScreen(
                      id: pItem.id,
                    ),
                  ),
                );
              },
              child: RestaurantCard.fromModel(
                model: pItem,
              ),
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 16.0);
          },
        ));
  }
}
