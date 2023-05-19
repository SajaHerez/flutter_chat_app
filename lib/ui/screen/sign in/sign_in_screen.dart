
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_provider.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../helper/theme/text_style_helper.dart';
import '../../../services/locater.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/rounded_button.dart';
import '../../../services/locater.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late AuthProvider _authProvider;
  late RoutingHelper _routingHelper;
  late double _deviceWidth;
  late double _deviceHeight;
  String? _email;
  String? _password;
  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _authProvider = Provider.of<AuthProvider>(context);
    _routingHelper = getIt<RoutingHelper>();
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(
            vertical: _deviceHeight * .02, horizontal: _deviceWidth * .03),
        height: _deviceHeight * .97,
        width: _deviceWidth * .96,
        alignment: Alignment.center,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Sign In",
                style: TextStyleHelper.titleStyle,
              ),
              SizedBox(
                height: _deviceHeight * 0.04,
              ),
              Container(
                height: _deviceHeight * .18,
                child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                            onSaved: (_value) {
                              setState(() {
                                _email = _value;
                              });
                            },
                            regEx:
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            hintText: "Email",
                            obscureText: false),
                        CustomTextFormField(
                            onSaved: (_value) {
                              setState(() {
                                _password = _value;
                              });
                            },
                            regEx: r".{8,}",
                            hintText: "Password",
                            obscureText: true),
                      ],
                    )),
              ),
              SizedBox(
                height: _deviceHeight * 0.05,
              ),
              RoundedButton(
                name: "Sign In",
                height: _deviceHeight * 0.065,
                width: _deviceWidth * 0.65,
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    loginFormKey.currentState!.save();
                       _authProvider.loginWithEmailandPassword(_email!, _password!);
                  }
                },
              ),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
              GestureDetector(
                onTap: () =>
                    _routingHelper.push(RouterName.signUpScreen),
                child: const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              )
            ]),
      )),
    );
  }
}
