import 'dart:js';

import 'package:flutter_gorouter/screens/1_basic_screen.dart';
import 'package:flutter_gorouter/screens/root_screen.dart';
import 'package:go_router/go_router.dart';

// /-> home
// /basic -> basic screen
// /basic/basic_two
final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) {
          return RootScreen();
        },
        routes: [
          GoRoute(
            path: 'basic',
            builder: (context, state) {
              return BasicScreen();
            },
          )
        ]),
  ],
);
