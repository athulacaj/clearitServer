import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:flutter/material.dart';

import 'mindMathDatabase.dart';

class AddMindMathScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final int? sltIndex;
  AddMindMathScreen({required this.data, this.sltIndex});
  @override
  _AddMindMathScreenState createState() => _AddMindMathScreenState();
}

class _AddMindMathScreenState extends State<AddMindMathScreen> {
  late TextEditingController _questionController, _answerController;
  Map<String, dynamic> data = {
    'date': DateTime.now().millisecondsSinceEpoch,
    'questions': []
  };
  bool _showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _questionController = new TextEditingController();
    _answerController = new TextEditingController();
    data = widget.data;
    _showSpinner = false;
    if (widget.sltIndex != null) {
      List qstnList = widget.data['questions'];
      _questionController.text = qstnList[widget.sltIndex!]['question'];
      _answerController.text = qstnList[widget.sltIndex!]['answer'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "Add Mind Math q"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              // keyboardType: TextInputType.number,
              decoration: KinputDecoration.copyWith(
                hintText: "Enter question",
              ),
              onChanged: (value) {},
            ),
            SizedBox(height: 10),
            TextField(
              controller: _answerController,
              // keyboardType: TextInputType.number,
              decoration: KinputDecoration.copyWith(
                hintText: "Enter answer",
              ),
              onChanged: (value) {},
            ),
            SizedBox(height: 10),
            Spacer(),
            ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (widget.sltIndex != null) {
                    data['questions'][widget.sltIndex!] = {
                      'question': _questionController.text,
                      'answer': _answerController.text
                    };
                  } else {
                    data['questions'].add({
                      'question': _questionController.text,
                      'answer': _answerController.text
                    });
                  }
                  _showSpinner = true;
                  print(data);
                  setState(() {});
                  await MindMathDatabase().saveData(data);
                  _showSpinner = false;
                  _answerController.clear();
                  _questionController.clear();
                  setState(() {});
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}

const InputDecoration KinputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
  hintText: 'Enter ',
);
