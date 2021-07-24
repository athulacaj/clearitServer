import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:clearit_server/utility/widgets/ImageView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addNotes.dart';
import 'pdfViewer.dart';

class NotesAndEquationScreen extends StatefulWidget {
  final String? topic;

  NotesAndEquationScreen({this.topic});
  @override
  _NotesAndEquationScreenState createState() => _NotesAndEquationScreenState();
}

List<DocumentSnapshot> notesList = [];

class _NotesAndEquationScreenState extends State<NotesAndEquationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(title: 'Topics', context: context),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('notes/topics/${widget.topic}')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Text('loading ...'),
                    );
                  }
                  notesList = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 80),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Spacer(),
                                      Expanded(
                                        flex: 6,
                                        child: Text(notesList[i]['title']),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        flex: 3,
                                        child: notesList[i]['pdf'] != null
                                            ? IconButton(
                                                icon: Icon(Icons.picture_as_pdf,
                                                    size: 40),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PdfScreen()));
                                                })
                                            : IconButton(
                                                icon:
                                                    Icon(Icons.image, size: 40),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ImageViewScreen(
                                                                  image: notesList[
                                                                          i][
                                                                      'image'])));
                                                }),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  // addNotesBottomSheet(context, widget.topic);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddNotesScreen(topic: widget.topic)));
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
      ),
    );
  }
}
