import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit_server/utility/uploadFiles.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RapidFireDatabaseManager.dart';
import 'addSolution.dart';

class AddRapidFireScreen extends StatefulWidget {
  final DocumentSnapshot? questionData;
  AddRapidFireScreen({this.questionData});
  @override
  _AddRapidFireScreenState createState() => _AddRapidFireScreenState();
}

List questionsList = [];
late TextEditingController _qtnController,
    _ytbController,
    _titleController,
    _timeController;

List<TextEditingController> optionControllerList = [];
Map<String, dynamic> questionMap = {};
int selectedIndex = 0;
int selectedOption = -1;
late TabController _tabController;
UploadFileClass? uploadFile;
bool isImageSelected = false;
bool _showSpinner = false;
List dropDown = ['bank', 'psc'];
String? category = dropDown[0];

class _AddRapidFireScreenState extends State<AddRapidFireScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    _qtnController = TextEditingController();
    _ytbController = TextEditingController();
    _timeController = TextEditingController();
    _titleController = TextEditingController();

    selectedIndex = 0;
    _showSpinner = false;
    uploadFile = new UploadFileClass(() {}, 'rapidFire');
    addDummyQuestions();
    if (widget.questionData != null) {
      questionsList = widget.questionData!["questionsList"];
      _timeController.text = widget.questionData!["time"].toString();
      _titleController.text = widget.questionData!["name"];
      print(questionsList);
    } else if (questionsList.length < 10) {
      addDummyQuestions();
    }
    _tabController.addListener(() {
      setState(() {});
    });

    updateUI(0);
  }

  addDummyQuestions() {
    optionControllerList = [];
    questionsList = [];
    for (int i = 0; i < 5; i++) {
      optionControllerList.add(TextEditingController());
    }
    for (int i = 0; i < 10; i++) {
      Map data = {
        'answerIndex': -1,
        'options': ['', '', '', '', ''],
        'question': '',
        'solution': {'image': null, 'youtube': '', 'path': null}
      };
      questionsList.add(data);
    }
    questionMap = {
      'date': null,
      'name': '',
      'time': 100,
      'questionsList': questionsList
    };
  }

  void addDataToList() {
    questionsList[_tabController.index]['question'] = _qtnController.text;
    questionsList[_tabController.index]['solution']['youtube'] =
        _ytbController.text;
    for (int i = 0; i < 5; i++) {
      questionsList[_tabController.index]['options'][i] =
          optionControllerList[i].text;
    }
  }

  void updateUI(int i) {
    _tabController.index = i;

    _qtnController.text = questionsList[i]['question'];
    _ytbController.text = questionsList[i]['solution']['youtube'];
    // print(
    //     questionsList[i]['solution']['image']);
    for (int j = 0; j < 5; j++) {
      optionControllerList[j].text =
          questionsList[_tabController.index]['options'][j];
    }
    createUploadFileClass(questionsList[i]['solution']['image']);
    setState(() {});
  }

  void createUploadFileClass(String? img) async {
    uploadFile = new UploadFileClass(() {}, 'rapidFire');
    uploadFile!.isUploaded = false;
    isImageSelected = false;
    if (img == null) {
    } else {
      print("img : " + img);

      uploadFile!.url = img;
      uploadFile!.isUploaded = true;
      uploadFile!.progress = 1.0;
      isImageSelected = true;
    }
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {});
  }

  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(questionsList);

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        // appBar: commonAppBar(context: context, title: "Add Rapid Fire Questions"),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: questionsList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: _tabController.index == i
                                  ? Colors.blueAccent
                                  : null,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                    primary: _tabController.index == i
                                        ? Colors.white
                                        : null,
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onPressed: () async {
                                    addDataToList();
                                    updateUI(i);
                                  },
                                  child: Text((i + 1).toString())),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        for (int index = 0; index <= 9; index++)
                          ListView(
                            children: [
                              SizedBox(
                                // height: size.height,
                                width: size.width - 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text("Question : ${index + 1}"),
                                        SizedBox(width: 20),
                                        Text(
                                            "answer : option ${questionsList[index]['answerIndex'] + 1}"),
                                      ],
                                    ),
                                    SizedBox(height: 14),
                                    TextField(
                                      controller: _qtnController,
                                      decoration: KinputDecoration.copyWith(
                                          hintText: "Enter question"),
                                      onChanged: (value) {},
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: 6),
                                    // options
                                    Column(
                                      children: [
                                        for (int i = 0; i < 5; i++)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, bottom: 9),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  child: TextField(
                                                    controller:
                                                        optionControllerList[i],
                                                    decoration: KinputDecoration
                                                        .copyWith(
                                                      hintText:
                                                          "Enter Option${i + 1}",
                                                    ),
                                                    onChanged: (value) {},
                                                  ),
                                                  width: size.width - 20 - 52,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      questionsList[index]
                                                          ['answerIndex'] = i;
                                                      setState(() {});
                                                    },
                                                    icon: Icon(questionsList[
                                                                    index][
                                                                'answerIndex'] ==
                                                            i
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank)),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 40),
                                    Text('Solution'),
                                    SizedBox(height: 20),

                                    AddSolutionScreen(
                                      ytbController: _ytbController,
                                      uploadFile: uploadFile,
                                      isImageSelected: isImageSelected,
                                      imgUrl: questionsList[index]['solution']
                                          ['image'],
                                      removeImage: () {
                                        uploadFile = null;
                                        isImageSelected = false;
                                        questionsList[index]['solution']
                                            ['image'] = null;
                                        setState(() {});
                                      },
                                      uploadImage: () async {
                                        _showSpinner = true;
                                        setState(() {});
                                        uploadFile = new UploadFileClass(() {
                                          setState(() {
                                            if (uploadFile!.isUploaded) {
                                              questionsList[index]['solution']
                                                  ['image'] = uploadFile!.url;
                                              _showSpinner = false;
                                            }
                                          });
                                        }, "shortNotes");
                                        isImageSelected = await uploadFile!
                                            .uploadFile('image');
                                        if (!isImageSelected) {
                                          _showSpinner = false;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ],
                          )
                      ]),
                ),
                Container(
                    height: 55,
                    width: size.width - 20,
                    color: Colors.grey.withOpacity(.1),
                    padding: EdgeInsets.all(4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // bottomButton(
                        //     title: "Save", icon: Icons.save, onTap: () {}),
                        bottomButton(
                            icon: Icons.clear_all,
                            title: "clear all",
                            onTap: () {
                              clearAll();
                            }),
                        bottomButton(
                            title: "Proceed",
                            icon: Icons.check,
                            onTap: () {
                              addDataToList();
                              if (validate(questionsList))
                                showModalBottomSheet<void>(
                                    context: context,
                                    isDismissible: false,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder: (BuildContext
                                              context,
                                          StateSetter
                                              setState /*You can rename this!*/) {
                                        return ModalProgressHUD(
                                          inAsyncCall: _showSpinner,
                                          child: Container(
                                            height: size.height - 200,
                                            padding: EdgeInsets.all(16),
                                            color: Colors.white,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  SizedBox(height: 30),
                                                  TextField(
                                                    decoration: KinputDecoration
                                                        .copyWith(
                                                      hintText: "Enter title",
                                                    ),
                                                    controller:
                                                        _titleController,
                                                    onChanged: (value) {},
                                                  ),
                                                  SizedBox(height: 10),
                                                  TextField(
                                                    controller: _timeController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: KinputDecoration
                                                        .copyWith(
                                                      hintText:
                                                          "Enter time in s",
                                                    ),
                                                    onChanged: (value) {},
                                                  ),
                                                  SizedBox(height: 5),
                                                  DropdownButton<String>(
                                                      items: dropDown
                                                          .map((var value) {
                                                        return new DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: (MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    2) -
                                                                50,
                                                            child: Text(
                                                              '$value',
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      value: category,
                                                      onChanged:
                                                          (String? value) {
                                                        int i = 0;
                                                        print(value);
                                                        category = value!;

                                                        setState(() {});
                                                      }),
                                                  SizedBox(height: 5),
                                                  ElevatedButton(
                                                      child:
                                                          const Text('Publish'),
                                                      onPressed: () async {
                                                        if (_titleController
                                                                    .text ==
                                                                "" ||
                                                            _titleController
                                                                    .text ==
                                                                "") {
                                                          showToast(
                                                              "please fill every field");
                                                        } else {
                                                          questionMap = {
                                                            'date': DateTime
                                                                    .now()
                                                                .millisecondsSinceEpoch,
                                                            'name':
                                                                _titleController
                                                                    .text,
                                                            'category':
                                                                category,
                                                            'time': int.parse(
                                                                _timeController
                                                                    .text),
                                                            'questionsList':
                                                                questionsList
                                                          };
                                                          _showSpinner = true;
                                                          setState(() {});
                                                          if (widget
                                                                  .questionData ==
                                                              null) {
                                                            await RapidFireDatabaseManager()
                                                                .saveData(
                                                                    questionMap);
                                                          } else {
                                                            await RapidFireDatabaseManager()
                                                                .update(
                                                                    questionMap,
                                                                    widget
                                                                        .questionData!
                                                                        .id);
                                                          }
                                                          _showSpinner = false;
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                    });
                            }),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate(List questionsList) {
    int i = 0;
    for (Map qstn in questionsList) {
      if (qstn["question"] == '') {
        showToastBlack("Add a question in ${i + 1}");
        return false;
      }
      for (int j = 0; j < qstn['options'].length; j++) {
        if (qstn['options'][j] == '') {
          showToastBlack("fill option ${j + 1} for qstn ${i + 1}");
          return false;
        }
      }
      if (qstn["answerIndex"] == -1) {
        showToastBlack("give a answer for qstn ${i + 1}");
        return false;
      }
      i++;
    }
    return true;
  }

  void clearAll() {
    _qtnController.text = '';
    _titleController.clear();
    // questionsList = [];
    addDummyQuestions();
    setState(() {});
  }
}

Widget bottomButton(
    {required IconData icon, required String title, required Function onTap}) {
  return Material(
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    ),
  );
}

const InputDecoration KinputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
  hintText: 'Enter ',
);
