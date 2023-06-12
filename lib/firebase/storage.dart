
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoragePath {
  static String team(String teamId, String fileName) => "teams/$teamId/$fileName";
  static String user(String userId, String fileName) => "users/$userId/$fileName";
}


class Storage {
  static final FirebaseStorage instance = FirebaseStorage.instance;

  static Future<String?> uploadFile({required String path, required File? file}) async {
    if (file == null) return null;

    Reference storageReference = instance.ref().child(path);

    TaskSnapshot uploadTask = await storageReference.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  }
}

