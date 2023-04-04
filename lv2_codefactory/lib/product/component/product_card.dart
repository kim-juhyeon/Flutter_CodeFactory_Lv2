import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'asset/img/food/ddeok.bok.gi.jpg',
        )
      ],
    );
  }
}
