import 'package:clearit_server/screens/Notes&%20Equ/notesEquationIndex.dart';
import 'package:flutter/material.dart';
import 'package:clearit_server/screens/DailyWord/dailyWord.dart';
import 'package:clearit_server/screens/askADoubt/viewQuestions/askedQuestions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ClearIt Server'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => AskADoubt()));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AskedQuestions()));
                  },
                  child: Text('Asked doubts'),
                ),
                // FlatButton(
                //   onPressed: () {},
                //   child: Text('Mind math'),
                // ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DailyWord()));
                  },
                  child: Text('Daily Word'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text('Rapid Fire'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotesAndEquationScreen()));
                  },
                  child: Text('Notes & Equation'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text('Recently Asked Questions'),
                ),
              ],
            ),
            SizedBox(height: 30),
            FlatButton(
              onPressed: () {},
              child: Text('View Our Solution'),
            ),
          ],
        ),
      ),
    );
  }
}
