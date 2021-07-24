import 'dart:io';

import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'dataBase.dart';

class ReplyScreen extends StatefulWidget {
  final String id;
  final int replyingNo;
  ReplyScreen({required this.id, required this.replyingNo});
  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

late UploadFileClass uploadImage;
bool _showSpinner = false;
bool isUploading = false;
List<UploadFileClass> uploadFileList = [];
String replyText = '';

class _ReplyScreenState extends State<ReplyScreen> {
  @override
  void initState() {
    _showSpinner = false;
    uploadImage = UploadFileClass(callBack, "reply");
    isUploading = false;
    // TODO: implement initState
    super.initState();
  }

  void callBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Reply', context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xff6369f2),
                        primaryColorDark: Color(0xff6369f2),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        // controller: doubtController,
                        autofocus: false,
                        maxLines: 4,
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          replyText = value;
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
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: uploadFileList.length,
                        itemBuilder: (BuildContext context, int i) {
                          UploadFileClass uploadedFile =
                              uploadFileList[uploadFileList.length - 1 - i];
                          return uploadedFile.file != null
                              ? Container(
                                  height: 80,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: BorderSide(
                                        width: 1, color: Colors.grey.shade600),
                                  )),
                                  margin: EdgeInsets.all(6),
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Spacer(),
                                            uploadedFile.type == 'image'
                                                ? Container(
                                                    height: 60,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                      image: FileImage(File(
                                                          uploadedFile
                                                              .file!.path)),
                                                    )),
                                                  )
                                                : Text(
                                                    '${uploadedFile.type}_${i + 1}'),
                                            SizedBox(height: 5),
                                            Spacer(),
                                            Positioned(
                                              child: SizedBox(
                                                height: 5,
                                                width: 70,
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.grey,
                                                  value: uploadedFile.progress,
                                                  valueColor: uploadedFile
                                                              .progress ==
                                                          1.0
                                                      ? AlwaysStoppedAnimation<
                                                          Color>(Colors.green)
                                                      : AlwaysStoppedAnimation<
                                                          Color>(Colors.blue),
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
                                                  uploadFileList.removeAt(
                                                      uploadFileList.length -
                                                          1 -
                                                          i);
                                                  setState(() {});
                                                }),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(Icons.attach_file),
                        Text('Attach Files'),
                      ],
                    ),
                    SizedBox(height: 0),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              iconButtonPressed('image');
                            }),
                        IconButton(
                            icon: Icon(Icons.picture_as_pdf),
                            onPressed: () {
                              iconButtonPressed('pdf');
                            }),
                        IconButton(
                            icon: Icon(Icons.audiotrack),
                            onPressed: () {
                              iconButtonPressed('audio');
                            }),
                      ],
                    ),
                    Divider(),
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
                      onPressed: () async {
                        bool _allUploaded = true;

                        List attachments = [];
                        for (UploadFileClass uploadedFile in uploadFileList) {
                          if (!uploadedFile.isUploaded) {
                            _allUploaded = false;
                            break;
                          }
                          attachments.add({
                            'type': uploadedFile.type,
                            'url': uploadedFile.url
                          });
                        }

                        FocusScope.of(context).unfocus();
                        if (!_allUploaded) {
                          showToast(
                              "You are uploading a file ..!! Please wait until the upload finish");
                        }
                        // else if (solution == null) {
                        //   showToast('Enter solution before submit..!!');
                        // }
                        else {
                          Map solution = {
                            'text': replyText,
                            'attachments': attachments
                          };

                          DoubtsReplyDatabaseClass askDoubtDatabase =
                              DoubtsReplyDatabaseClass(
                                  solution: solution,
                                  context: context,
                                  id: widget.id,
                                  replyingNo: widget.replyingNo);
                          _showSpinner = true;
                          setState(() {});
                          await askDoubtDatabase.saveData();
                          _showSpinner = false;
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

  void iconButtonPressed(String type) async {
    _showSpinner = true;
    setState(() {});
    UploadFileClass uploadFile = new UploadFileClass(callBack, "reply");
    bool isSelected = await uploadFile.uploadFile(type);
    if (isSelected) uploadFileList.add(uploadFile);
    _showSpinner = false;
    setState(() {});
  }
}
