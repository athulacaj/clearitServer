import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AskDoubtDatabase {
  final Map dailyQuestion;
  final BuildContext context;

  AskDoubtDatabase(this.dailyQuestion, this.context);

  Future<void> saveData(Map queryDetails) async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('dailyWord')
        .doc('${now.toString().split(' ')[0]}')
        .set(dailyQuestion);
  }
}
