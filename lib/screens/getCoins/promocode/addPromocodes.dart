import 'package:clearit_server/utility/functions/showToast.dart';
import 'package:clearit_server/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPromocodeScreen extends StatefulWidget {
  final String? promo;
  final int? coin;
  AddPromocodeScreen({this.promo, this.coin});

  @override
  _AddPromocodeScreenState createState() => _AddPromocodeScreenState();
}

bool _showSpinner = false;
TextEditingController _promocodeController = new TextEditingController();
TextEditingController _coinsController = new TextEditingController();

class _AddPromocodeScreenState extends State<AddPromocodeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showSpinner = false;
    if (widget.promo != null) {
      _promocodeController.text = widget.promo!;
    }
    if (widget.coin != null) {
      _coinsController.text = widget.coin!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _promocodeController,
                    decoration: ktxtDecoration,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _coinsController,
                    keyboardType: TextInputType.number,
                    decoration: ktxtDecoration.copyWith(
                        hintText: "Enter coins to send"),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () async {
                        int? coins;
                        if (_coinsController.text != "") {
                          try {
                            coins = int.parse(_coinsController.text);
                          } catch (e) {
                            showToast(e.toString());
                          }
                        }
                        if (_promocodeController.text != "" && coins != null) {
                          _showSpinner = true;
                          setState(() {});
                          await FirebaseFirestore.instance
                              .collection("common/getCoins/promocodes")
                              .doc(_promocodeController.text)
                              .set({"coin": coins});
                          Navigator.pop(context);
                        } else {
                          showToast("error,check the values");
                        }
                      },
                      child: Text("     Save      "))
                ],
              ),
            ),
          ),
        ));
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
