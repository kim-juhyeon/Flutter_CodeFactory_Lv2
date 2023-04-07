import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lv2_codefactory/common/const/data.dart';
import 'package:lv2_codefactory/common/dio/dio.dart';
import 'package:lv2_codefactory/restaurant/model/restaurant_model.dart';
import 'package:lv2_codefactory/restaurant/repository/restaurant_repository.dart';
import 'package:lv2_codefactory/restaurant/view/restaurant_detail_screen.dart';

import '../component/restaurant_card.dart';

class RestaurnatScreen extends ConsumerWidget {
  const RestaurnatScreen({Key? key}) : super(key: key);
//provider를 이용하여 dio를 글로벌 함수로 정하게 되었고, dio를 resp에 넣어 줬는데 문제없이 돌아가게 되었음 : dio에 storage파일을 포함하고 있으므로
//똑깥은 인스턴스를 불러올 수 있는 장점이 있음!
  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);

//splash_screen과 동일하게 storage 토큰 값을 가져온다.
// 그리고 postman으로 수정했던 부분 곧 accessToken 레스토랑 데이터를 가져올 수 있게되었다.
    final resp =
        await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant')
            .paginate(); //데이터값만 가져오기
    return resp.data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantModel>>(
            //paginateRestaurant() 메서드를 호출하여 Dio 패키지를 사용하여 API에서 레스토랑 목록을 가져옵니다.
            future: paginateRestaurant(ref),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              /*future builder로 snapshot이 계속 업데이트 될 수 있도록 한다. 
              hasData가 false이면 빈 Container->circulater가 반환됩니다..*/
              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    //itemBuilder가 실행될 때마다 0~20번의 item이 선택이 된다.
                    //item = index 설정으로 해당하는 url을 가져와서 빌드한다.
                    final pItem = snapshot.data![index];
                    //factory화 하는데 item에 변수에서 에러가 나오기 때문에 retaurnatmodel.fromejson 그리고 json:item은 같다는 로직을 짜줍니다.
                    //final pItem = RestaurantModel.fromJson(item);
                    //RestaurantCard도 factory화 해서 fromModel로 변수를 지정해 줬고 이를 pItem과 같다라는 걸 명령해야 에러가 없음
                    //GestureDetector 눌렀을때 반응할 수 있는 위젯이고 안에 onTap을 하여 detailpage로 넘어갈 수 있게 만듬
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(
                              //Screen에 있는 id 값이 detailScreen에 넘어갈려면 id값이 있어야 하기 때문에 id값을 pItem.id값과 id가 같다고 해줍니다.
                              //그리고 DetailScreen에 id를 명시해줍니다.
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
                    return SizedBox(
                      height: 16.0,
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
