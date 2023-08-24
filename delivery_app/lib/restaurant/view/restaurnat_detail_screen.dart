import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/component/product_card.dart';
import 'package:delivery_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailSceen extends ConsumerWidget {
  final String id;

  const RestaurantDetailSceen({required this.id, Key? key}) : super(key: key);



// final accessToken = await storage.read(key: ACCESS_TOKEN);
//
// final resp = await dio.get(
//   'http://$ip/restaurant/$id',
//   options: Options(
//     headers: {
//       'authorization': 'Bearer $accessToken',
//     },
//   ),
//);
//return resp.data;


@override
Widget build(BuildContext context, WidgetRef ref) {
  return DefaultLayout(
    title: '불타는 떡볶이',
    child: FutureBuilder<RestaurantDetailModel>(
      future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(
        id: id),
      builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        //final item = RestaurantDetailModel.fromJson(snapshot.data!);
        return CustomScrollView(
          slivers: [
            renderTop(model: snapshot.data!),
            renderLable(),
            renderProduct(products: snapshot.data!.products),
          ],
        );
      },
    ),
  );
}

SliverPadding renderLable() {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverToBoxAdapter(
      child: Text(
        '메뉴',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
    ),
  );
}

SliverPadding renderProduct({
  required List<RestaurantProductModel> products,
}) {
  return SliverPadding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    sliver: SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final model = products[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(model: model),
          );
        },
        childCount: products.length,
      ),
    ),
  );
}

SliverToBoxAdapter renderTop({
  required RestaurantDetailModel model,
}) {
  return SliverToBoxAdapter(
    child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ),
  );
}}
