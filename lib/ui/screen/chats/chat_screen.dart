import 'package:flutter/material.dart';

import '../../../controller/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../controller/chats_provider.dart';
import '../../../data/model/chat.dart';
import '../../../data/model/chat_message.dart';
import '../../../data/model/chat_user.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../services/locater.dart';
import '../../widget/app_bar.dart';
import '../../widget/custom_list_tiles.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AuthProvider _authProvider;
  late ChatListPervider _chatListPervider;
  late double _deviceWidth;
  late double _deviceHeight;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ChatListPervider(_authProvider)),
      ],
      child: Builder(builder: (context) {
        _chatListPervider = context.watch<ChatListPervider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * .98,
          width: _deviceWidth * .97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar("Chats",
                  primaryAction: IconButton(
                      onPressed: () async {
                        context.read<AuthProvider>().logout();
                        getIt<RoutingHelper>()
                            .pushReplacement(RouterName.splashScreen);
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ))),
              getChats()
            ],
          ),
        );
      }),
    );
  }

  Widget getChats() {
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

  Widget getListTile(Chat chat) {
    List<ChatUser> _recepients = chat.recepients();
    bool _isActive = _recepients.any(
      (element) => element.userWasActive(),
    );
    String _subTitletext = "";
    if (chat.messages.isNotEmpty) {
      // ignore: unrelated_type_equality_checks
      chat.messages.first.content != MessageType.TEXT
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
        // _navigation.navigateToPage(
        //   ChatPage(chat: _chat),
        // );
      },
    );
  }
}

