import 'package:clearit_server/provider/account.dart';
import 'package:clearit_server/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/phoneAuth/login.dart';
import 'homeScreen/homescreen.dart';

bool _showSpinner = true;

class SplashScreenWindow extends StatefulWidget {
  static String id = 'Splash_Screen';

  @override
  _SplashScreenWindowState createState() => _SplashScreenWindowState();
}

class _SplashScreenWindowState extends State<SplashScreenWindow> {
  @override
  void initState() {
    _showSpinner = true;
    initFunctions();
    super.initState();
  }

  initFunctions() async {
    await initializeFlutterFire();
    bool _isLogin = await login(context);
    if (_isLogin == true) {
      Map? userDetails =
          await Provider.of<MyAccount>(context, listen: false).getUserData();
      if (userDetails == null) {
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PhoneLoginScreen()));
    }
    _showSpinner = false;
  }

  Future initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
//        _initialized = true;
//        print('firebase initialized');
      });
    } catch (e) {
      setState(() {
//        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: Center(
          child: Text('Your Logo'),
        ),
      ),
    );
  }
}

User? _user;

final FirebaseAuth _auth = FirebaseAuth.instance;

login(BuildContext context) async {
  bool isLogin = false;
  final User? user = _auth.currentUser;
  if (user != null) {
    _user = user;
    final uid = user.uid;
    print('uid $uid');
    Provider.of<MyAccount>(context, listen: false).setUid(uid);
    isLogin = true;
  } else {
    isLogin = false;
  }
  return isLogin;
}
