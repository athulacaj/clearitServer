import 'package:flutter/material.dart';

class AskABoubt extends StatefulWidget {
  @override
  _AskABoubtState createState() => _AskABoubtState();
}

class _AskABoubtState extends State<AskABoubt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Text('Ask A Doubt'),
          ),
        ],
      ),
    );
  }
}
