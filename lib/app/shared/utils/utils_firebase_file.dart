import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uniprint/app/shared/utils/utils_platform.dart';

class UtilsFirebaseFile {
  static Future<String> putFile(File file, String patch) async {
    StorageUploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child((UtilsPlatform.isDebug() ? 'DEBUG/' : '') + patch)
        .putFile(file);
    var a = await uploadTask.onComplete;
    return await a.ref.getDownloadURL();
  }
}
