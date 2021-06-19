import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../commonAppbar.dart';
import 'topicsInCoursesScreen.dart';

class NotesAndEquationScreen extends StatefulWidget {
  @override
  _NotesAndEquationScreenState createState() => _NotesAndEquationScreenState();
}

FirebaseFirestore _firestore;

class _NotesAndEquationScreenState extends State<NotesAndEquationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List coursesList = [];

    return Scaffold(
      appBar: commonAppBar(title: 'Notes and Equation', context: context),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('notes').doc('courses').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Text('loading or no data');
              }

              if (snapshot.data != null) {
                coursesList = snapshot.data['coursesList'];
              }
              print(coursesList);
              return Expanded(
                child: ListView.builder(
                  itemCount: coursesList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopicsInCoursesScreen(
                                          courseName: coursesList[i],
                                        )));
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 60),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(coursesList[i])),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          TextButton(
              onPressed: () {
                _modalBottomSheetMenu(context, coursesList);
              },
              child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ))),
        ],
      ),
    );
  }
}

void _modalBottomSheetMenu(BuildContext context, List coursesList) {
  List returnList = coursesList;
  TextEditingController textEditingController = TextEditingController();
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 350.0,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: new Container(
            padding: EdgeInsets.all(13),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0))),
            child: Column(
              children: [
                Spacer(),
                TextField(
                  controller: textEditingController,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: 'Enter Course',
                  ),
                ),
                Spacer(),
                TextButton(
                    onPressed: () async {
                      returnList.add(textEditingController.text);
                      DocumentReference doc =
                          _firestore.collection('notes').doc('courses');
                      await doc.set({'coursesList': returnList});
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.blue,
                        alignment: Alignment.center,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ))),
              ],
            ),
          ),
        );
      });
}
