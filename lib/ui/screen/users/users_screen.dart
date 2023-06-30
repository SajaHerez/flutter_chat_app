import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controller/auth_provider.dart';
import '../../../controller/users_provider.dart';
import '../../../helper/router/router_path.dart';
import '../../../helper/router/routing_helper.dart';
import '../../../model/chat_user.dart';
import '../../../services/locater.dart';
import '../../widget/app_bar.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/custom_list_tiles.dart';
import '../../widget/rounded_button.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late double _deviceWidth;
  late double _deviceHeight;
  late AuthProvider _authProvider;
  TextEditingController _searchController = TextEditingController();
  late UsersProvider _usersProvider;
  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => UsersProvider(_authProvider))
        ],
        child: Builder(builder: (context) {
          _usersProvider = context.watch<UsersProvider>();
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: _deviceHeight * .02, horizontal: _deviceWidth * .03),
            height: _deviceHeight * .97,
            width: _deviceWidth * .96,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  'Users',
                  primaryAction: IconButton(
                      onPressed: () async {
                        context.read<AuthProvider>().logout();
                        getIt<RoutingHelper>()
                            .pushReplacement(RouterName.splashScreen);
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      )),
                ),
                CustomTextField(
                  hintText: 'Search...',
                  controller: _searchController,
                  obscureText: false,
                  icon: Icons.search_rounded,
                  onEditingComplete: (value) {
                    _usersProvider.getUsers(name: value);
                    FocusScope.of(context).unfocus();
                  },
                ),
                listview(),
                _createButton()
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget listview() {
    List<ChatUser>? _users = _usersProvider.listUsers;
    return Expanded(child: () {
      if (_users != null) {
        if (_users.length != 0) {
          return ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext _context, int _index) {
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: _users[_index].name,
                subtitle: "Last Active: ${_users[_index].lasrDayActive()}",
                imagePath: _users[_index].imageURL,
                isActive: _users[_index].userWasActive(),
                isSelected: _usersProvider.selectedUsers.contains(
                  _users[_index],
                ),
                onTap: () {
                  _usersProvider.updateSelectedUsers(
                    _users[_index],
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Users Found.",
              style: TextStyle(
                color: Colors.white,
              ),
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
    }());
  }

  Widget _createButton() {
    return Visibility(
      visible: _usersProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _usersProvider.selectedUsers.length == 1
            ? "Chat With ${_usersProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _usersProvider.createChat();
        },
      ),
    );
  }
}
