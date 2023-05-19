
import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/helper/router/router_path.dart';
import 'package:flutter_chat_app_v1/helper/router/routing_helper.dart';

import '../../ui/screen/home/home_screen.dart';
import '../../ui/screen/sign in/sign_in_screen.dart';
import '../../ui/screen/sign up/sign_up_screen.dart';
import '../../ui/screen/splash/splash_screen.dart';

class Routers {
  Routers._();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouterName.signUpScreen:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case RouterName.loginScreen:
        return MaterialPageRoute(builder: (context) => SignInScreen());
       case RouterName.homeScreen:
        return MaterialPageRoute(
            builder: (context) =>  HomeScreen());
    
      default:
        return RoutingHelper.errorRoute();
    }
  }
}
