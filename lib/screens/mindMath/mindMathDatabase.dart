import 'package:cloud_firestore/cloud_firestore.dart';

class MindMathDatabase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future saveData(Map<String, dynamic> data) async {
    await _firestore.collection('mindMath').doc('questions').set(data);
  }

  Future<Map<String, dynamic>> getData() async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('mindMath').doc('questions').get();
    if (!snap.exists) {
      Map<String, dynamic> data = {
        'date': DateTime.now().millisecondsSinceEpoch,
        'questions': []
      };
      return data;
    }
    return snap.data()!;
  }
}
