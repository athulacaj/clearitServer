import 'dart:io';

import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';

class AddSolutionScreen extends StatelessWidget {
  final TextEditingController ytbController;
  AddSolutionScreen(
      {required this.ytbController,
      required this.isImageSelected,
      required this.uploadFile,
      required this.uploadImage,
      required this.imgUrl,
      required this.removeImage});
  final UploadFileClass? uploadFile;
  final bool isImageSelected;
  final String? imgUrl;
  final Function removeImage, uploadImage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isImageSelected
            ? Container(
                height: 80,
                width: 80,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Spacer(),
                        imgUrl != null
                            ? Image.network(imgUrl!, height: 60, width: 60)
                            : Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image:
                                      FileImage(File(uploadFile!.file!.path)),
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
                              valueColor: uploadFile!.progress == 1.0
                                  ? AlwaysStoppedAnimation<Color>(Colors.green)
                                  : AlwaysStoppedAnimation<Color>(Colors.blue),
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
                              removeImage();
                              // setState(() {});
                            }),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
        SizedBox(height: 20),
        IconButton(
            icon: Icon(Icons.image, size: 40),
            onPressed: () async {
              uploadImage();
            }),
        SizedBox(height: 20),
        TextField(
          decoration: new InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
            ),
            hintText: 'Enter youtube link ',
          ),
          onChanged: (value) {},
          controller: ytbController,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
