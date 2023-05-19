class ChatUser {
  String uid;
  String name;
  String email;
  String imageURL;
  DateTime lastActive;

  ChatUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.lastActive});

   factory  ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        imageURL: json['image'],
        lastActive: json['last_active'].toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': imageURL,
      'last_active': lastActive
    };
  }

  String lasrDayActive() {
    return '${lastActive.month}/${lastActive.day}/${lastActive.year}';
  }

  bool userWasActive() {
    return DateTime.now().difference(lastActive).inHours < 2;
  }

}
