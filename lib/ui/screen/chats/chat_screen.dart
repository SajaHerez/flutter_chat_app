import 'package:flutter/material.dart';

import '../../../controller/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../controller/chats_provider.dart';
import '../../../model/chat_message.dart';
import '../../../model/chat_user.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../services/locater.dart';
import '../../widget/app_bar.dart';
import '../../widget/custom_list_tiles.dart';
import '../../../model/chat.dart';
import 'chat_body.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late AuthProvider _authProvider;
  late ChatListPervider _chatListPervider;
  late RoutingHelper _routingHelper;
  late double _deviceWidth;
  late double _deviceHeight;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _routingHelper = getIt<RoutingHelper>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ChatListPervider(_authProvider)),
      ],
      child: Builder(builder: (contextz) {
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
                     const  ChatBodyWidget()
            ],
          ),
        );
      }),
    );
  }


}
