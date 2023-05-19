import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String USER_COLLECTION = 'users';

class CloudStorageService {
  final storage = FirebaseStorage.instance;

  Future<String?> saveUserImageToStorage(String uid, PlatformFile _file) async {
    try {
      Reference ref = storage
          .ref()
          .child('images/$USER_COLLECTION/$uid/profile.${_file.extension}');
      UploadTask _uploadTask = ref.putFile(File(_file.path!),);
      return await _uploadTask.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }


    Future<String?> saveChatImageToStorage(String chatId,String uid, PlatformFile _file) async {
    try {
      Reference ref = storage
          .ref()
          .child('images/chats/$chatId/${uid}_${DateTime.now().microsecondsSinceEpoch}.${_file.extension}');
      UploadTask _uploadTask = ref.putFile(File(_file.path!));
      return await _uploadTask.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }
}
