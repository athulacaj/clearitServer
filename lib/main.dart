import 'package:clearit_server/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:clearit_server/provider/account.dart';
import 'package:clearit_server/provider/commonprovider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<CommonProvider>(
      create: (context) => CommonProvider(),
    ),
    ChangeNotifierProvider<MyAccount>(
      create: (context) => MyAccount(),
    ),
    // StreamProvider(
    //   create: (BuildContext context) =>
    //       FirebaseServices().getUsersCoin('UPeQoO4eY6OAwLGtHoULKAE6oEi1'),
    // ),
    // StreamProvider<CoinsClass>.value(value: CoinsStream('fgdfg').getCoin)
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff7078ff),
        statusBarIconBrightness: Brightness.light));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StudyWithFun',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff7f86ff),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          tabBarTheme: TabBarTheme(
              labelColor: Colors.black, unselectedLabelColor: Colors.grey),
        ),

        home: SplashScreenWindow(),
        // initialRoute: HomeScreen.id,
        // routes: {
        //   HomeScreen.id: (context) => HomeScreen(),
        // },
      ),
    );
  }
}
