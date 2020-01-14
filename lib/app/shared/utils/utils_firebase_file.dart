import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UtilsFirebaseFile {
  static Future<String> putFile(File file, String patch) async {
    StorageUploadTask uploadTask =
        FirebaseStorage.instance.ref().child(patch).putFile(file);
    var a = await uploadTask.onComplete;
    return await a.ref.getDownloadURL();
  }

  File getDownloadFile() {}
}
