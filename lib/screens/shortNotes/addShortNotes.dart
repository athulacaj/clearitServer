import 'dart:io';

import 'package:clearit_server/screens/DailyWord/dailyWord.dart';
import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'shortNotessDatabase.dart';

class AddShortNotesScreen extends StatefulWidget {
  final DocumentSnapshot? addShortNotesSnapshot;
  AddShortNotesScreen({this.addShortNotesSnapshot});
  @override
  _AddShortNotesScreenState createState() => _AddShortNotesScreenState();
}

TextEditingController _titleController = TextEditingController();
TextEditingController _ytbController = TextEditingController();
String? _ytbLink;
String? image;

class _AddShortNotesScreenState extends State<AddShortNotesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadFile = new UploadFileClass(callBack, "shortNotes", context);
    if (widget.addShortNotesSnapshot != null) {
      _titleController.text = widget.addShortNotesSnapshot!['title'];
      if (widget.addShortNotesSnapshot!['youtube'] != null)
        _ytbController.text = widget.addShortNotesSnapshot!['youtube'];
      image = widget.addShortNotesSnapshot!['image'];
    } else {
      _titleController.text = "";
      _ytbController.text = "";
      image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(context: context, title: "Short Notes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - 110,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: 'Enter title',
                  ),
                ),
                SizedBox(height: 20),
                image == null
                    ? isImageSelected
                        ? Container(
                            height: 80,
                            width: 80,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: FileImage(
                                            File(uploadFile!.file!.path)),
                                      )),
                                    ),
                                    SizedBox(height: 5),
                                    Spacer(),
                                    Positioned(
                                      child: SizedBox(
                                        height: 5,
                                        width: 70,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.grey,
                                          value: uploadFile!.progress,
                                          valueColor: uploadFile!.progress ==
                                                  1.0
                                              ? AlwaysStoppedAnimation<Color>(
                                                  Colors.green)
                                              : AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 15,
                                    child: IconButton(
                                        iconSize: 15,
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          uploadFile = null;
                                          isImageSelected = false;
                                          setState(() {});
                                        }),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container()
                    : Container(
                        height: 80,
                        width: 80,
                        child: Image.network(image!),
                      ),
                SizedBox(height: 20),
                IconButton(
                    icon: Icon(Icons.image, size: 40),
                    onPressed: () async {
                      iconButtonPressed('image');
                    }),
                SizedBox(height: 20),
                TextField(
                  controller: _ytbController,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.greenAccent, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: 'Enter youtube link ',
                  ),
                  onChanged: (value) {
                    _ytbLink = value;
                    setState(() {});
                  },
                ),
                Spacer(),
                TextButton(
                    onPressed: () async {
                      if (_ytbController.text != '') {
                        _ytbLink = _ytbController.text;
                      }
                      if (uploadFile!.isUploaded == false && _ytbLink == null) {
                        showToast("add image or youtube link");
                      } else {
                        _showSpinner = true;
                        setState(() {});
                        await ShortNotesDatabase.saveData({
                          'title': _titleController.text,
                          'image': image == null ? uploadFile!.url : image,
                          'youtube': _ytbLink
                        });
                        _showSpinner = false;
                        setState(() {});
                        Navigator.pop(context);
                      }
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
    );
  }

  bool _showSpinner = false;
  void callBack() {
    setState(() {});
  }

  UploadFileClass? uploadFile;
  bool isImageSelected = false;
  void iconButtonPressed(String type) async {
    _showSpinner = true;
    setState(() {});
    uploadFile = new UploadFileClass(callBack, "shortNotes", context);
    isImageSelected = await uploadFile!.uploadFile(type);
    if (isImageSelected) image = null;
    _showSpinner = false;
    setState(() {});
  }
}
