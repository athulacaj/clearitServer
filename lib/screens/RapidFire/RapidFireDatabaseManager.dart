import 'package:cloud_firestore/cloud_firestore.dart';

class RapidFireDatabaseManager {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future saveData(Map<String, dynamic> data) async {
    await _firestore
        .collection('rapidFire/category/${data['category']}')
        .add(data);
  }

  Future update(Map<String, dynamic> data, String doc) async {
    await _firestore
        .collection('rapidFire/category/${data['category']}')
        .doc(doc)
        .update(data);
  }
}
