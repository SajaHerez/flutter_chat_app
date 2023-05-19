
import 'package:flutter/material.dart';

import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../helper/theme/spaces_helper.dart';
import '../../../helper/theme/string_helper.dart';
import '../../../helper/theme/text_style_helper.dart';
import '../../../services/locater.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5),
        () => getIt<RoutingHelper>().pushReplacement(RouterName.loginScreen));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            appIconPath,
            width: 150,
            height: 150,
          ),
          SpacesHelper.verticalSpace(30),
          Text("Chat App", style: TextStyleHelper.mainTitleStyle)
        ],
      )),
    ));
  }
}
