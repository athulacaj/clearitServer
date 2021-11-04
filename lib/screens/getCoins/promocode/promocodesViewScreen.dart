import 'package:clearit_server/screens/commonAppbar.dart';
import 'package:clearit_server/screens/shortNotes/addShortNotes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'addPromocodes.dart';

class PromocodesViewScreen extends StatefulWidget {
  const PromocodesViewScreen({Key? key}) : super(key: key);

  @override
  _PromocodesViewScreenState createState() => _PromocodesViewScreenState();
}

class _PromocodesViewScreenState extends State<PromocodesViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "Promo codes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection("common/getCoins/promocodes")
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPromocodeScreen(
                                            promo: data.id,
                                            coin: data['coin'],
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(data.id),
                                      SizedBox(width: 10),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("shortNotes")
                                                .doc(data.id)
                                                .delete();
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                  Text("coins: ${data['coin']}"),
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddPromocodeScreen()));
                },
                child: Text("Add new"))
          ],
        ),
      ),
    );
  }
}
