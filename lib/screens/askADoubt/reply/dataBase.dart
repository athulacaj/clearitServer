import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class DoubtsReplyDatabaseClass {
  final Map? solution;
  final String? id;
  final BuildContext? context;
  final int? replyingNo;

  DoubtsReplyDatabaseClass(
      {this.solution, this.context, this.id, this.replyingNo});

  Future<void> saveData() async {
    print(id);
    DateTime now = DateTime.now();
    DocumentReference ref =
        FirebaseFirestore.instance.collection('askDoubt').doc(id);
    List queryDetails = (await ref.get())['queryDetails'];
    print(queryDetails[replyingNo!]);
    queryDetails[replyingNo!]['solution'] = solution;
    try {
      await ref.update({'queryDetails': queryDetails, "isReplied": true}).then(
          (value) => showToast("Saved Successfully"));
    } catch (e) {
      showToast("something went wrong try again $e");
    }
  }
}
