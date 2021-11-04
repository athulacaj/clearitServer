import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../commonAppbar.dart';
import 'indvidualTopics/Notes&Equation.dart';

class TopicsInCoursesScreen extends StatefulWidget {
  final String? courseName;
  TopicsInCoursesScreen({this.courseName});
  @override
  _TopicsInCoursesScreenState createState() => _TopicsInCoursesScreenState();
}

late FirebaseFirestore _firestore;

class _TopicsInCoursesScreenState extends State<TopicsInCoursesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    _firestore = FirebaseFirestore.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List? topicsList = [];

    return Scaffold(
      appBar: commonAppBar(title: 'Topics', context: context),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('notes/subjects/all/${widget.courseName}/subjects')
                .doc('topics')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot>? snapshot) {
              if (!snapshot!.hasData) {
                return Text('loading or no data');
              }
              print("${snapshot.data} 45");
              if (snapshot.data!.exists) {
                topicsList = snapshot.data!['topicsList'];
              }
              print(topicsList);
              return Expanded(
                child: ListView.builder(
                  itemCount: topicsList!.length,
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
                                    builder: (context) =>
                                        NotesAndEquationScreen(
                                          topic: topicsList![i],
                                        )));
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 60),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Text(topicsList![i]),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          topicsList!.removeAt(i);
                                          _firestore
                                              .collection(
                                                  'notes/subjects/all/${widget.courseName}/subjects')
                                              .doc('topics')
                                              .update(
                                                  {"topicsList": topicsList});
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
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
                _modalBottomSheetMenu(context, topicsList, widget.courseName);
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

void _modalBottomSheetMenu(
    BuildContext context, List? coursesList, String? courseName) {
  List? returnList = coursesList;
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
                      returnList!.add(textEditingController.text);
                      DocumentReference doc = _firestore
                          .collection('notes/subjects/all/$courseName/subjects')
                          .doc('topics');
                      await doc.set({'topicsList': returnList});
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
