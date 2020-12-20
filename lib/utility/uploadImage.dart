import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImage {
  UploadImage(this.callBack);
  Function callBack;
  double progress = 0.4;
  PickedFile pickedFile;
  File image;
  String url;
  uploadImage(String item) async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    image = File(pickedFile.path);
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;

    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref('uploads/hello-world.txt')
        .putFile(image);

    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      progress =
          snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
      callBack();
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await task;
      url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
      callBack();
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }
  }
}
