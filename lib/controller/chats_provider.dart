import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/data/model/chat_user.dart';

import '../data/model/chat.dart';
import '../data/model/chat_message.dart';
import '../services/database_service.dart';
import '../services/locater.dart';
import 'auth_provider.dart';

class ChatListPervider extends ChangeNotifier {
  AuthProvider _authProvider;
  late DatabaseService _db;
  late List<Chat> chats;
  late StreamSubscription _chatStream;
  ChatListPervider(this._authProvider) {
    _db = getIt<DatabaseService>();
    getChats();
  }

  void getChats() async {
    try {
      _chatStream = _db
          .getChatsForUser(_authProvider.chatUser.uid)
          .listen((snapshot) async {
        chats = await Future.wait(snapshot.docs.map((doc) async {
          Map<String, dynamic> _chatData = doc.data() as Map<String, dynamic>;
          List<ChatUser> members = [];
          for (var uid in _chatData['members']) {
            final snap = await _db.getUser(uid);
            final userData = snap.data() as Map<String, dynamic>;
            userData['uid'] = snap.id;
            members.add(ChatUser.fromJson(userData));
          }

          List<ChatMessage> chatsMessages = [];
          final _chatMessage = await _db.getLastMessageForChat(doc.id);
          if (_chatMessage.docs.isNotEmpty) {
            Map<String, dynamic> _messageData =
                _chatMessage.docs.first.data()! as Map<String, dynamic>;
            print(_messageData);
            ChatMessage _message = ChatMessage.fromJSON(_messageData);
            chatsMessages.add(_message);
          }
          return Chat(
            uid: doc.id,
            currentUserUid: _authProvider.chatUser.uid,
            members: members,
            messages: chatsMessages,
            activity: _chatData["is_activity"],
            group: _chatData["is_group"],
          );
        }).toList());
        notifyListeners();
      });
    } catch (e) {
      print("Error in get chats");
      print(e);
    }
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }
}
