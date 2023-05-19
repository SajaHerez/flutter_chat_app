import 'package:flutter/material.dart';

class RoutingHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  void push(String route, {Object? arguments}) {
    navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  void pop() {
    navigatorKey.currentState!.pop();
  }

  void pushReplacement(String route, {Object? arguments}) {
    navigatorKey.currentState!
        .pushReplacementNamed(route, arguments: arguments);
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(child: Text("Error")),
      );
    });
  }
}
