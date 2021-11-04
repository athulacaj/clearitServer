import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewCoinRequestsScreen extends StatefulWidget {
  @override
  _ViewCoinRequestsScreenState createState() => _ViewCoinRequestsScreenState();
}

late TextEditingController _coinsToSendController;

class _ViewCoinRequestsScreenState extends State<ViewCoinRequestsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _coinsToSendController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "coin request"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection("common/getCoins/request")
                  .where("canceled", isNotEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> promocodes = snapshot.data!.docs;
                print(promocodes);
                return Expanded(
                  child: ListView.builder(
                    itemCount: promocodes.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = promocodes[index];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(data['name']),
                                      SizedBox(width: 20),
                                      Spacer(),
                                      Text(data['phone']),

                                      // IconButton(
                                      //     onPressed: () {},
                                      //     icon: Icon(Icons.delete))
                                    ],
                                  ),
                                  // SizedBox(height: 8),
                                  Divider(),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 150,
                                        child: TextField(
                                          controller: _coinsToSendController,
                                          keyboardType: TextInputType.number,
                                          decoration: ktxtDecoration.copyWith(
                                              hintText: "Enter coins "),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.send)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.cancel)),
                                    ],
                                  ),
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
          ],
        ),
      ),
    );
  }
}

InputDecoration ktxtDecoration = new InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 1.0),
  ),
  hintText: 'Enter promo code',
);
