import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  UploadImage(this.callBack);
  Function callBack;
  double progress = 0.4;
  PickedFile pickedFile;
  File image;
  String url;
  uploadImage() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    image = File(pickedFile.path);
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('$year')
        .child('doubts')
        .child('uid')
        .child("$dateInMs.jpg");

    UploadTask uploadTask = ref.putFile(image);
    uploadTask.snapshotEvents.listen((event) {
      progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      callBack();
      // set state is called using callback function
    }).onError((error) {
      // do something to handle error
    });

    url =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    callBack();
  }
}
