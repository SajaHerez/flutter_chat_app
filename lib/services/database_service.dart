import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'users';
const String CHAT_COLLECTION = 'chats';
const String MESSAGES_COLLECTION = 'messages';

class DatabaseService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> createUser(
      String uid, String name, String email, String imageURL) async {
    try {
      await fireStore.collection(USER_COLLECTION).doc(uid).set({
        'name': name,
        'image': imageURL,
        'email': email,
        'last_active': DateTime.now().toUtc()
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return fireStore.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<void> updateUserLastActiveTime(String uid) async {
    try {
      fireStore
          .collection(USER_COLLECTION)
          .doc(uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return fireStore
        .collection(CHAT_COLLECTION)
        .where("members", arrayContains: uid)
        .snapshots();
  }

 Future<QuerySnapshot> getLastMessageForChat(String chatID) {
   return  fireStore
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION).orderBy('sent_time',descending: true).limit(1).get();
  }
}
