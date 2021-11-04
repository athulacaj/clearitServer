import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

void saveUserData(Map userData) async {
  final localData = await SharedPreferences.getInstance();

  String user = jsonEncode(userData);
  localData.setString('user', user);
}

void deleteUserData() async {
  final localData = await SharedPreferences.getInstance();
  localData.remove('user');
}

class MyAccount with ChangeNotifier {
  String uid = 'null';
  Map? userDetails;
  int coins = 0;
  void setUid(String uidi) {
    uid = uidi;
    notifyListeners();
  }

  void setCoins(int rCoins) {
    coins = rCoins;
    notifyListeners();
  }

  void addUser(Map user) async {
    userDetails = user;
    saveUserData(user);
    notifyListeners();
  }

  void removeUser() async {
    deleteUserData();
    notifyListeners();
  }

  Future<Map?> getUserData() async {
    final localData = await SharedPreferences.getInstance();
    String userData = localData.getString('user') ?? '';
    if (userData == "null" || userData == '') {
    } else {
      userDetails = jsonDecode(userData);
      return userDetails;
      notifyListeners();
    }
    return null;
  }
}
