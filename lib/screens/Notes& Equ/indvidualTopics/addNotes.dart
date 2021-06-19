import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddNotesScreen extends StatefulWidget {
  final String topic;
  AddNotesScreen({this.topic});
  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

List returnList = [];
String image;
String pdf;
bool _showSpinner = false;
TextEditingController titleController = TextEditingController();
UploadFileClass uploadFile;

class _AddNotesScreenState extends State<AddNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: 500.0,
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
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
                    TextField(
                      controller: titleController,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Enter Course',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.image, size: 40),
                                onPressed: () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  bool isSelected = false;
                                  uploadFile = new UploadFileClass(() {
                                    setState(() {
                                      if (isSelected) image = uploadFile.url;
                                    });
                                  });
                                  isSelected =
                                      await uploadFile.uploadFile('image');
                                  if (isSelected) image = uploadFile.url;
                                  _showSpinner = false;
                                  print(uploadFile.url);
                                  setState(() {});
                                }),
                            image != null
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Container(height: 20),
                          ],
                        ),
                        SizedBox(width: 50),
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.picture_as_pdf, size: 40),
                                onPressed: () async {
                                  uploadFile = new UploadFileClass(() {});
                                  bool isSelected =
                                      await uploadFile.uploadFile('pdf');
                                  if (isSelected) pdf = uploadFile.url;
                                  _showSpinner = false;
                                  setState(() {});
                                }),
                            pdf != null
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Container(height: 20),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: () async {
                          print(uploadFile.url);
                          // CollectionReference doc = _firestore
                          //     .collection('notes/topics/${widget.topic}');
                          // await doc.add({
                          //   'title': titleController.text,
                          //   'image': image,
                          //   "pdf": pdf
                          // });
                          // Navigator.pop(context);
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
            ),
          ),
        ),
      ),
    );
  }
}
