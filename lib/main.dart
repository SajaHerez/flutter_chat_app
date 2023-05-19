
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/services/locater.dart';
import 'package:provider/provider.dart';
import 'controller/auth_provider.dart';
import 'firebase_options.dart';
import 'helper/router/Router.dart';
import 'helper/router/router_path.dart';
import 'helper/router/routing_helper.dart';
import 'helper/theme/color_helper.dart';
import 'ui/screen/sign up/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate( androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,);

  registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
        navigatorKey: RoutingHelper.navigatorKey,
        onGenerateRoute: Routers.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            scaffoldBackgroundColor: ColorHelper.blue00,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: ColorHelper.blue00)),
        initialRoute: RouterName.splashScreen,
        //home: SignUpScreen()
      ),
    );
  }
}
