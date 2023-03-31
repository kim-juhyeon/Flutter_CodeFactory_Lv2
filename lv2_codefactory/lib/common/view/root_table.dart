import 'package:flutter/material.dart';
import 'package:lv2_codefactory/common/layout/default_layout.dart';

class RootTab extends StatelessWidget {
  const RootTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text('RootTab'),
      ),
    );
  }
}
