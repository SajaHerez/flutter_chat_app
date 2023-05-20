import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/chat_user.dart';
import '../helper/router/router_path.dart';
import '../helper/router/routing_helper.dart';
import '../services/database_service.dart';
import '../services/locater.dart';

class AuthProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final RoutingHelper _routingHelper;
  late final DatabaseService _databaseService;
  late ChatUser chatUser;
  AuthProvider() {
    _auth = FirebaseAuth.instance;
    _routingHelper = getIt<RoutingHelper>();
    _databaseService = getIt<DatabaseService>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeFirebase(_auth);
    });
    // _auth.authStateChanges().listen((user) {
    //   if (user != null) {
    //     print("logged in");
    //     _databaseService.updateUserLastActiveTime(user.uid);
    //     _databaseService.getUser(user.uid).then((snapshot) {
    //       Map<String, dynamic> _userData =
    //           snapshot.data() as Map<String, dynamic>;
    //       chatUser = ChatUser.fromJson({
    //         'uid': user.uid,
    //         'name': _userData["name"],
    //         'email': _userData['email'],
    //         'image': _userData['image'],
    //         'last_active': _userData['last_active']
    //       });
    //       _routingHelper.pushReplacement(RouterName.homeScreen);
    //       print(chatUser.toJson());
    //     });
    //   } else {
    //     _routingHelper.pushReplacement(RouterName.loginScreen);
    //     print('not authenticated');
    //   }
    // });
  }

  Future<void> _initializeFirebase(_auth) async {
    try {
      _auth.authStateChanges().listen((user) {
        if (user != null) {
          print("logged in");
          _databaseService.updateUserLastActiveTime(user.uid);
          _databaseService.getUser(user.uid).then((snapshot) {
            if (snapshot.data() != null) {
              Map<String, dynamic> _userData =
                  snapshot.data() as Map<String, dynamic>;
              chatUser = ChatUser.fromJson({
                'uid': user.uid,
                'name': _userData["name"],
                'email': _userData['email'],
                'image': _userData['image'],
                'last_active': _userData['last_active']
              });
              _routingHelper.pushReplacement(RouterName.homeScreen);
              print(chatUser.toJson());
            }
          });
        } else {
          _routingHelper.pushReplacement(RouterName.loginScreen);
          print('not authenticated');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithEmailandPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      print("Login failed");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> RegisterWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userCredential.user?.uid;
    } on FirebaseAuthException {
      print("Register failed");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
