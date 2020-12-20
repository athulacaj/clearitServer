import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:clearit_server/screens/askADoubt/dataBase.dart';
import 'package:clearit_server/screens/askADoubt/uploadImage.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';

bool _showSpinner = false;

class DailyWord extends StatefulWidget {
  @override
  _DailyWordState createState() => _DailyWordState();
}

Size size;

class _DailyWordState extends State<DailyWord> {
  TextEditingController doubtController;
  UploadImage uploadImage;
  String note;
  String word;
  String imgUrl;
  bool isUploading = false;
  @override
  void initState() {
    _showSpinner = false;
    uploadImage = UploadImage(callBack);
    isUploading = false;
    TextEditingController doubtController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  void callBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Daily Word ', context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xff6369f2),
                        primaryColorDark: Color(0xff6369f2),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: doubtController,
                        autofocus: false,
                        maxLines: 1,
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          word = value;
                          // setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Word',
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xff6369f2),
                        primaryColorDark: Color(0xff6369f2),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: doubtController,
                        autofocus: false,
                        maxLines: 4,
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          note = value;
                          // setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter notes',
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    uploadImage.pickedFile != null
                        ? Container(
                            height: 80,
                            width: 240,
                            child: Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 240,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: FileImage(
                                        File(uploadImage.pickedFile.path)),
                                  )),
                                ),
                                uploadImage.progress == 1.0
                                    ? Container()
                                    : Positioned(
                                        left: 105,
                                        top: 25,
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.grey,
                                            value: uploadImage.progress,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    FlatButton(
                      color: Colors.lightBlueAccent,
                      child: Text(
                        'Upload an Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        isUploading = true;
                        uploadImage.uploadImage();
                      },
                    ),
                    SizedBox(
                        height: uploadImage.pickedFile != null
                            ? size.height / 13
                            : size.height / 5.2),
                    FlatButton(
                      color: Color(0xff6369f2),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (isUploading && uploadImage.progress != 1.0) {
                          showToast(
                              "You are uploading a image ..!! Please wait until the upload finish");
                        } else if (word == null) {
                          showToast('Enter Doubt before submit..!!');
                        } else {
                          Map<String, dynamic> dailyWordDetails = {
                            'word': word,
                            'note': note,
                            'imageUrl': uploadImage.url
                          };

                          AskDoubtDatabase askDoubtDatabase =
                              AskDoubtDatabase(dailyWordDetails, context);
                          showMyDialog(context, dailyWordDetails,
                              askDoubtDatabase, callBack);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// int dropIndex=0;
String dropValue = dropDown[0];
List dropDown = ['bank', 'psc'];

Future<void> showMyDialog(
    BuildContext context,
    Map<String, dynamic> dailyWordDetails,
    AskDoubtDatabase askDoubtDatabase,
    Function callBack) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure !!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('On submitting a coin is deducted'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('ok'),
            onPressed: () async {
              Navigator.of(context).pop();
              _showSpinner = true;
              callBack();
              await askDoubtDatabase.saveData(dailyWordDetails);
              _showSpinner = false;
              callBack();
            },
          ),
        ],
      );
    },
  );
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey.shade800,
      textColor: Colors.white,
      fontSize: 16.0);
}
