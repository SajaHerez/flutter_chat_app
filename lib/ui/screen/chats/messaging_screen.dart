import 'package:flutter/material.dart';
import 'package:flutter_chat_app_v1/model/chat_message.dart';

import '../../../controller/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../controller/messaging_provider.dart';
import '../../../model/chat.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../services/locater.dart';
import '../../widget/app_bar.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/custom_list_tiles.dart';

class MessagingScreen extends StatefulWidget {
  final Chat chat;
  const MessagingScreen({super.key, required this.chat});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late AuthProvider _authProvider;
  late double _deviceWidth;
  late double _deviceHeight;
  late MessagingProvider _messagingProvider;
  late GlobalKey<FormState> _messageStateKey;
  late ScrollController _messagesListViewController;
  late RoutingHelper _routingHelper;

  @override
  void initState() {
    _messageStateKey = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _routingHelper = getIt<RoutingHelper>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => MessagingProvider(
                widget.chat.uid, _authProvider, _messagesListViewController))
      ],
      child: SafeArea(child: Builder(builder: (context) {
        _messagingProvider = context.watch<MessagingProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth * .97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 13,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                      onPressed: () {
                        _messagingProvider.deleteChat();
                      },
                    ),
                    secondaryAction: IconButton(
                      onPressed: () {
                        _routingHelper.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  _messagesListView(),
                  _sendMessageForm()
                ],
              ),
            ),
          ),
        );
      })),
    );
  }

  Widget _messagesListView() {
    if (_messagingProvider.messages != null) {
      if (_messagingProvider.messages!.isNotEmpty) {
        return Container(
          height: _deviceHeight * .65,
          child: ListView.builder(
              controller: _messagesListViewController,
              itemCount: _messagingProvider.messages!.length,
              itemBuilder: ((context, index) {
                ChatMessage message = _messagingProvider.messages![index];
                bool isOwnMessage =
                    message.senderID == _authProvider.chatUser.uid;
                return CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * .80,
                  message: message,
                  sender: widget.chat.members
                      .where((element) => element.uid == message.senderID)
                      .first,
                  isOwnMessage: isOwnMessage,
                );
              })),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
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
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.01,
      ),
      child: Form(
        key: _messageStateKey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      margin: const EdgeInsets.only(right: 5, bottom: 8),
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageStateKey.currentState!.validate()) {
            _messageStateKey.currentState!.save();
            _messagingProvider.sendTextMessage();
            _messageStateKey.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
          onSaved: (_value) {
            _messagingProvider.message = _value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: "Type a message",
          obscureText: false),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return SizedBox(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        onPressed: () {
          _messagingProvider.sendImageMessage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
