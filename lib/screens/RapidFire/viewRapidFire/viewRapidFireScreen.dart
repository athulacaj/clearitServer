import 'package:clearit_server/screens/RapidFire/AddRapidFire.dart';
import 'package:clearit_server/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewRapidFireScreen extends StatefulWidget {
  const ViewRapidFireScreen({Key? key}) : super(key: key);

  @override
  _ViewRapidFireScreenState createState() => _ViewRapidFireScreenState();
}

List dropDown = ['bank', 'psc'];
String? category = dropDown[0];

class _ViewRapidFireScreenState extends State<ViewRapidFireScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context: context, title: "RapidFire"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
                items: dropDown.map((var value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      alignment: Alignment.center,
                      width: (MediaQuery.of(context).size.width / 2) - 50,
                      child: Text(
                        '$value',
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
                value: category,
                onChanged: (String? value) {
                  int i = 0;
                  print(value);
                  category = value!;

                  setState(() {});
                }),
            StreamBuilder<QuerySnapshot<Map>>(
              stream: FirebaseFirestore.instance
                  .collection("rapidFire/category/$category")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> rapidFireList = snapshot.data!.docs;
                rapidFireList.sort((a, b) => b['date'].compareTo(a['date']));
                print(rapidFireList);
                return Expanded(
                  child: ListView.builder(
                    itemCount: rapidFireList.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot data = rapidFireList[index];
                      DateTime d =
                          DateTime.fromMillisecondsSinceEpoch(data['date']);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Material(
                          elevation: 4,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddRapidFireScreen(
                                          questionData: data)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(data['name']),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection(
                                                    "rapidFire/category/$category")
                                                .doc(data.id)
                                                .delete();
                                          },
                                          icon: Icon(Icons.delete)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    d.toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddRapidFireScreen()));
                },
                child: Text("Add new"))
          ],
        ),
      ),
    );
  }
}
