import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'individualQuestion.dart';

class AskedQuestions extends StatefulWidget {
  @override
  _AskedQuestionsState createState() => _AskedQuestionsState();
}

class _AskedQuestionsState extends State<AskedQuestions> {
  bool loading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    loading = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar:
            commonAppBar(title: 'Recently Asked Questions', context: context),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('askDoubt').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      List<DocumentSnapshot> historyList = snapshot.data.docs;
                      print(historyList);
                      return ListView.builder(
                          itemCount: historyList.length,
                          itemBuilder: (context, int i) {
                            Map details = historyList[i].data();
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualQuestionsScreen(
                                                detailsList:
                                                    details['queryDetails'],
                                                id: historyList[i].id,
                                              )));
                                },
                                // onTap: showQuestionBottomSheet(
                                //     context, size, details),
                                child: Material(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: ConstrainedBox(
                                      constraints:
                                          BoxConstraints(minHeight: 60),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              details['queryDetails'][0]
                                                          ['imageUrl'] !=
                                                      null
                                                  ? SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: FullScreenWidget(
                                                        child: Center(
                                                          child: Hero(
                                                            tag: details[
                                                                    'queryDetails']
                                                                [0]['query'],
                                                            child:
                                                                Image.network(
                                                              details['queryDetails']
                                                                      [0]
                                                                  ['imageUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                    '${details['queryDetails'][0]['query']}'),
                                              ),
                                              SizedBox(width: 10),
                                              Text(''),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
