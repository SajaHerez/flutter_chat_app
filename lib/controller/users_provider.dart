import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/services/locater.dart';

import '../helper/router/routing_helper.dart';
import '../model/chat_user.dart';
import '../services/database_service.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class UsersProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  late RoutingHelper _routingHelper;
  late DatabaseService _databaseService;
  List<ChatUser>? listUsers;
  late List<ChatUser> _listSelectedUsers;
  List<ChatUser> get selectedUsers {
    return _listSelectedUsers;
  }

  UsersProvider(this._authProvider) {
    listUsers = [];
    _routingHelper = getIt<RoutingHelper>();
    _databaseService = getIt<DatabaseService>();
    getUsers();
  }

  void getUsers({String? name}) {
    _listSelectedUsers = [];
    try {
      _databaseService.getUsers(name).then((snapshot) {
        listUsers = snapshot.docs.map((e) {
          Map<String, dynamic> data = e.data() as Map<String, dynamic>;
          data['uid'] = e.id;
          return ChatUser.fromJson(data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print('Error in getting users');
      print(e);
    }
  }

  void updateSelectedUsers(ChatUser user) {
    if (_listSelectedUsers.contains(user)) {
      _listSelectedUsers.remove(user);
    } else {
      _listSelectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat(Map<String, dynamic> data) async {
    try {
      List<String> _membersIds =
          _listSelectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_authProvider.chatUser.uid);
      bool _isGroup = _listSelectedUsers.length > 1;
      final _doc = await _databaseService.createChat(
        {
          "is_group": _isGroup,
          "is_activity": false,
          "members": _membersIds,
        },
      );




      
    } catch (e) {
      print('Error in creating chat');
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
