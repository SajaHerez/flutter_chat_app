import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/services/locater.dart';

import '../helper/router/routing_helper.dart';
import '../model/chat_message.dart';
import '../services/cloud_storage_service.dart';
import '../services/database_service.dart';
import '../services/media_service.dart';
import 'auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class MessagingProvider extends ChangeNotifier {
  AuthProvider _authProvider;
  late RoutingHelper _routingHelper;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late CloudStorageService _cloudStorageService;
  ScrollController messagesController;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardController;
  String chatID;
  List<ChatMessage>? messages;
  late StreamSubscription _streamSubscription;

  String? _message;

  void set message(String _value) {
    _message = _value;
  }

  String get message => _message ?? "";
  MessagingProvider(this.chatID, this._authProvider, this.messagesController) {
    _databaseService = getIt<DatabaseService>();
    _cloudStorageService = getIt<CloudStorageService>();
    _mediaService = getIt<MediaService>();
    _routingHelper = getIt<RoutingHelper>();
    keyboardController = KeyboardVisibilityController();
    listenToKeyboardChanges();
    listenToMessages();
  }
  void listenToMessages() {
    try {
      _streamSubscription =
          _databaseService.getMessagesForChat(chatID).listen((snapshot) {
        List<ChatMessage>? _messages = snapshot.docs.map((m) {
          Map<String, dynamic> _json = m.data() as Map<String, dynamic>;
          return ChatMessage.fromJSON(_json);
        }).toList();
        messages = _messages;
        notifyListeners();
        // scroll to the bottom of the chat screen
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (messagesController.hasClients) {
            messagesController
                .jumpTo(messagesController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print('Error in messages');
      print(e);
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = keyboardController.onChange.listen((visible) {
      print('Keyboard visibility direct query: $visible');
      _databaseService.updateChatData(chatID, {'is_activity': visible});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage mess = ChatMessage(
          content: _message!,
          type: MessageType.TEXT,
          sentTime: DateTime.now(),
          senderID: _authProvider.chatUser.uid);
      _databaseService.addMessagetoChat(chatID, mess);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _mediaService.pickImageFromlibrary();
      if (_file != null) {
        String? downloadURL = await _cloudStorageService.saveChatImageToStorage(
            chatID, _authProvider.chatUser.uid, _file);
        ChatMessage mess = ChatMessage(
            content: downloadURL!,
            type: MessageType.IMAGE,
            senderID: _authProvider.chatUser.uid,
            sentTime: DateTime.now());
        await _databaseService.addMessagetoChat(chatID, mess);
      }
    } catch (e) {
      print('Error in sended image');
      print(e);
    }
  }

  void deleteChat() {
    _routingHelper.pop();
    _databaseService.deleteChat(chatID);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription.cancel();
    // _keyboardVisibilityStream.cancel();
    super.dispose();
  }
}
