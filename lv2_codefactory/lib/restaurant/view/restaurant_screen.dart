import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/const/data.dart';

import '../component/restaurant_card.dart';

class RestaurnatScreen extends StatelessWidget {
  const RestaurnatScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();
// dio 패키지를 이용하여 api에 접속을 하고 accesstoken을 가져온다.
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
//splash_screen과 동일하게 storage 토큰 값을 가져온다.
// 그리고 postman으로 수정했던 부분 곧 accessToken 레스토랑 데이터를 가져올 수 있게되었다.
    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {
          'authorization': 'Bearer $accessToken',
        },
      ),
    );
//데이터값만 가져오기
    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            //paginateRestaurant() 메서드를 호출하여 Dio 패키지를 사용하여 API에서 레스토랑 목록을 가져옵니다.
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              /*future builder로 snapshot이 계속 업데이트 될 수 있도록 한다. 
              hasData가 false이면 빈 Container가 반환됩니다..*/
              return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    //itemBuilder가 실행될 때마다 0~20번의 item이 선택이 된다.
                    //item = index 설정으로 해당하는 url을 가져와서 빌드한다.
                    final item = snapshot.data![index];
                    return RestaurantCard(
                      image: Image.network(
                        'http://$ip${item['thumbUrl']}',
                        fit: BoxFit.cover,
                      ),
                      //Image.asset(
                      //'asset/img/food/ddeok_bok_gi.jpg',
                      //fit: BoxFit.cover,
                      //),
                      name: item['name'],
                      tags: List<String>.from(item['tags']),
                      ratingsCount: item['ratingsCount'],
                      deliveryTime: item['deliveryTime'],
                      deliveryFee: item['deliveryFee'],
                      ratings: item['ratings'],
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
