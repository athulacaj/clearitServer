import 'dart:io';
import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'dataBase.dart';
import 'uploadImage.dart';
import 'dataBase.dart';
import 'package:clearit_server/utility/functions/uploadFiles.dart';

bool _showSpinner = false;

class DailyWord extends StatefulWidget {
  @override
  _DailyWordState createState() => _DailyWordState();
}

late Size size;

class _DailyWordState extends State<DailyWord> {
  TextEditingController? doubtController;
  String? note;
  String? word;
  String? imgUrl;
  bool isUploading = false;

  @override
  void initState() {
    _showSpinner = false;
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
                    uploadFile != null && uploadFile!.file != null
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
                                    image:
                                        FileImage(File(uploadFile!.file!.path)),
                                  )),
                                ),
                                uploadFile!.progress == 1.0
                                    ? Container()
                                    : Positioned(
                                        left: 105,
                                        top: 25,
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.grey,
                                            value: uploadFile!.progress,
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
                        addImageFunction('image');
                      },
                    ),
                    SizedBox(
                        height: UploadFileClass != null
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (uploadFile != null && !uploadFile!.isUploaded) {
                          showToast(
                              "You are uploading a file ..!! Please wait until the upload finish");
                        } else {
                          if (uploadFile != null && uploadFile!.url != null) {
                            imageUrl = uploadFile!.url;
                          }
                          Map<String, dynamic> dailyWordDetails = {
                            'word': word,
                            'desc': note,
                            'image': imageUrl
                          };
                          _showSpinner = true;
                          setState(() {});
                          DailyDatabase dailydataBase =
                              DailyDatabase(dailyWordDetails, context);
                          await dailydataBase.saveData(dailyWordDetails);
                          _showSpinner = false;
                          showToast("saved ");
                          setState(() {});
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

  String? imageUrl;
  UploadFileClass? uploadFile;
  void addImageFunction(String type) async {
    _showSpinner = true;
    setState(() {});
    uploadFile = new UploadFileClass(callBack, "dailyWord");
    bool isSelected = await uploadFile!.uploadFile(type);
    if (isSelected) imageUrl = uploadFile!.url;
    _showSpinner = false;
    setState(() {});
  }
}

// int dropIndex=0;
String dropValue = dropDown[0];
List dropDown = ['bank', 'psc'];
