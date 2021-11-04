import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'addMindMath.dart';

class ViewMindMathScreen extends StatefulWidget {
  const ViewMindMathScreen({Key? key}) : super(key: key);

  @override
  _ViewMindMathScreenState createState() => _ViewMindMathScreenState();
}

String category = "bank";
bool _showSpinner = false;
Map<String, dynamic> databaseData = {};

class _ViewMindMathScreenState extends State<ViewMindMathScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "Mind Math"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("mindMath")
                  .doc('questions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List questionsList = snapshot.data!['questions'];
                databaseData = snapshot.data!.data()!;
                print(questionsList);
                return Expanded(
                  child: ListView.builder(
                    itemCount: questionsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map data = questionsList[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddMindMathScreen(
                                            data: databaseData,
                                            sltIndex: index,
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(data['question']),
                                      SizedBox(height: 10),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            questionsList.removeAt(index);
                                            FirebaseFirestore.instance
                                                .collection("mindMath")
                                                .doc('questions')
                                                .update({
                                              "questions": questionsList
                                            });
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                  // SizedBox(height: 10),
                                  Text("ans: ${data['answer']}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMindMathScreen(
                                data: databaseData,
                              )));
                },
                child: Text("Add new"))
          ],
        ),
      ),
    );
  }
}
