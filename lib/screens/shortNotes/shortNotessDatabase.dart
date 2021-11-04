import 'package:cloud_firestore/cloud_firestore.dart';

class ShortNotesDatabase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static saveData(Map<String, dynamic> data) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore.instance
        .collection("shortNotes")
        .doc(time.toString())
        .set(data);
  }
}
