import 'package:flutter/material.dart';
import 'package:flutter_gorouter/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        body: ListView(
      children: [
        ElevatedButton(onPressed: (){
          context.go('/basic');
        }, child: Text('Go basic'))
      ],
    ));
  }
}
