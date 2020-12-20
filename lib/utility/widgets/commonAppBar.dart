import 'package:flutter/material.dart';

PreferredSizeWidget commonAppBar({String title, BuildContext context}) {
  return AppBar(
    // brightness: Brightness.light,
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    title: Text(
      '$title',
      style: TextStyle(color: Colors.black),
    ),
    // actions: [
    //   IconButton(
    //     onPressed: () {},
    //     icon: Icon(
    //       Icons.notifications_active,
    //       color: Colors.black,
    //     ),
    //   ),
    // ],
  );
}
