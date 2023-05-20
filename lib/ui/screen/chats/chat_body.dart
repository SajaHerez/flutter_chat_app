import 'package:flutter/material.dart';

import '../../../controller/chats_provider.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../model/chat.dart';
import '../../../model/chat_message.dart';
import '../../../model/chat_user.dart';
import '../../../services/locater.dart';
import '../../widget/custom_list_tiles.dart';
import 'package:provider/provider.dart';

class ChatBodyWidget extends StatefulWidget {
  const ChatBodyWidget({super.key});

  @override
  State<ChatBodyWidget> createState() => _ChatBodyWidgetState();
}

class _ChatBodyWidgetState extends State<ChatBodyWidget> {
  late ChatListPervider _chatListPervider;
  late double _deviceHeight;
  late RoutingHelper _routingHelper;

  Widget getListTile(Chat chat) {
    List<ChatUser> _recepients = chat.recepients();
    bool _isActive = _recepients.any(
      (element) => element.userWasActive(),
    );
    String _subTitletext = "";
    if (chat.messages.isNotEmpty) {
      // ignore: unrelated_type_equality_checks
      _subTitletext = chat.messages.first.content != MessageType.TEXT
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.10,
      title: chat.title(),
      subtitle: _subTitletext,
      imagePath: chat.imageURL(),
      isActive: _isActive,
      isActivity: chat.activity,
      onTap: () {
        _routingHelper.push(RouterName.messgingScreen, arguments: chat);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _routingHelper = getIt<RoutingHelper>();
    _chatListPervider = context.watch<ChatListPervider>();
    List<Chat> chats = _chatListPervider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.length > 0) {
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (BuildContext context, int index) {
                  return getListTile(chats[index]);
                });
          } else {
            return const Center(
              child: Text(
                "No Chats Found.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }
}
