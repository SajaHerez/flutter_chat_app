import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_provider.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/theme/text_style_helper.dart';
import '../../../services/cloud_storage_service.dart';
import '../../../services/database_service.dart';
import '../../../services/locater.dart';
import '../../../services/media_service.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/rounded_button.dart';
import '../../widget/rounded_image.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String _email;
  late String _name;
  late String _password;
  late double _deviceWidth;
  late double _deviceHeight;
  PlatformFile? _imageFile;
  late AuthProvider _authProvider;
  late DatabaseService _databaseService;
  late CloudStorageService _cloudStorageService;
  final registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _databaseService = getIt<DatabaseService>();
    _cloudStorageService = getIt<CloudStorageService>();
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
              vertical: _deviceHeight * 0.02,
            ),
            height: _deviceHeight * 0.98,
            width: _deviceWidth * 0.97,
            // alignment: Alignment.center,
            child: Form(
              key: registerFormKey,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyleHelper.mainTitleStyle,
                    ),
                    SizedBox(
                      height: _deviceHeight * 0.02,
                    ),
                    _profileImageField(),
                    SizedBox(
                      height: _deviceHeight * 0.05,
                    ),
                    CustomTextFormField(
                        onSaved: (_value) {
                          setState(() {
                            _name = _value;
                          });
                        },
                        regEx: r'.{6,}',
                        hintText: "Name",
                        obscureText: false),
                    SizedBox(
                      height: _deviceHeight * 0.02,
                    ),
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
                    SizedBox(
                      height: _deviceHeight * 0.02,
                    ),
                    CustomTextFormField(
                        onSaved: (_value) {
                          setState(() {
                            _password = _value;
                          });
                        },
                        regEx: r".{8,}",
                        hintText: "Password",
                        obscureText: true),
                    SizedBox(
                      height: _deviceHeight * 0.05,
                    ),
                    RoundedButton(
                      name: "Register",
                      height: _deviceHeight * 0.065,
                      width: _deviceWidth * 0.65,
                      onPressed: () async {
                        print('inside register button');
                        if (registerFormKey.currentState!.validate() &&
                            _imageFile != null) {
                          print('inside register button  2');
                          registerFormKey.currentState!.save();
                          print('inside register button 3');
                          String? uid =
                              await _authProvider.RegisterWithEmailandPassword(
                                  _email, _password);
                          print('inside register button  4');
                          String? _imagePath = await _cloudStorageService
                              .saveUserImageToStorage(uid!, _imageFile!);
                          print('inside register button 5');
                          await _databaseService.createUser(
                              uid, _name, _email, _imagePath!);
                          print('inside register button 6');
                          await _authProvider.logout();
                          print('inside register button 7');
                          await _authProvider.loginWithEmailandPassword(
                              _email, _password);
                          print('inside register button 8');
                          //getIt<RoutingHelper>().pop();
                         
                        }
                      },
                    ),
                    SizedBox(
                      height: _deviceHeight * 0.05,
                    ),
                  ]),
            ),
          )),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        getIt<MediaService>().pickImageFromlibrary().then((_file) {
          if (_file != null) {
            setState(() {
              _imageFile = _file;
            });
          }
        });
      },
      child: () {
        if (_imageFile != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _imageFile!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: "https://i.pravatar.cc/150?img=65",
            size: _deviceHeight * 0.15,
          );
        }
      }(), //  we add ()  at the end  to run the function that we declared above in side child
    );
  }
}
