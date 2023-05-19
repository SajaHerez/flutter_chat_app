import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = 'users';
const String CHAT_COLLECTION = 'chats';
const String MESSAGES_COLLECTION = 'messages';

class DatabaseService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> createUser(
      String uid, String name, String email, String imageURL) async {
    try {
     await  fireStore.collection(USER_COLLECTION).doc(uid).set({
      'name':name,
      'image':imageURL,
      'email':email,
      'last_active':DateTime.now().toUtc()
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
}
