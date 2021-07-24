import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:clearit_server/screens/shortNotes/addShortNotes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewShortNotesScreen extends StatefulWidget {
  const ViewShortNotesScreen({Key? key}) : super(key: key);

  @override
  _ViewShortNotesScreenState createState() => _ViewShortNotesScreenState();
}

String category = "bank";

class _ViewShortNotesScreenState extends State<ViewShortNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "RapidFire"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection("shortNotes")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> shortNotesList = snapshot.data!.docs;
                print(shortNotesList);
                return Expanded(
                  child: ListView.builder(
                    itemCount: shortNotesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = shortNotesList[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddShortNotesScreen(
                                          addShortNotesSnapshot: data)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(data['title']),
                                  SizedBox(height: 10),
                                  Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("shortNotes")
                                            .doc(data.id)
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete))
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
                          builder: (context) => AddShortNotesScreen()));
                },
                child: Text("Add new"))
          ],
        ),
      ),
    );
  }
}
