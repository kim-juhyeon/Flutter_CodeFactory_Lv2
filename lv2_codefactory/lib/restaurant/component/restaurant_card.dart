import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/const/colors.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;
  final String name;
  final List<String> tags;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;
  final double rating;

  const RestaurantCard(
      {required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.rating,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //clipRRect를 이용하여 child 속해 있는 이미지를 깎을 수 있음
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: image,
        ),
        SizedBox(height: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8.0),
            //join 함수를 이용하여 문자 사이에 dot을 집어 넣을 수 있다. (tags를 리스트함수로 지정하였음,)
            Text(
              tags.join('·'),
              style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                _IconText(
                  icon: Icons.start,
                  label: rating.toString(),
                ),
                renderDot(),
                _IconText(
                  icon: Icons.receipt,
                  label: ratingsCount.toString(),
                ),
                renderDot(),
                _IconText(
                  icon: Icons.timelapse_outlined,
                  label: '$deliveryTime 분',
                ),
                renderDot(),
                _IconText(
                  icon: Icons.monetization_on,
                  label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                ),
                renderDot(),
              ],
            )
          ],
        )
      ],
    );
  }
}

renderDot() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Text(
      '·',
      style: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

//Icon과 라벨이 한쌍으로 이루어져 있는 page이므로 따로 위젯을 설정해준다.
class _IconText extends StatelessWidget {
  //IconData는 icon을 불러 올 수 있는 함수이다.
  final IconData icon;
  final String label;

  const _IconText({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
