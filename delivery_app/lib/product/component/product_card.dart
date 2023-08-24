import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.price})
      : super(key: key);

  factory ProductCard.fromModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          width: 110,
          height: 110,
          fit: BoxFit.cover,),
          name: model.name,
          detail: model.detail,
          price: model.price);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      //image 사이즈가 110 -> expanded로 이미지와 동일하게 text를 넣기 위함
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,

          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontSize: 14.0, color: BODY_TEXT_COLOR),
                ),
                Text(
                  '$price원',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: PRIMARY_COLOR,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
