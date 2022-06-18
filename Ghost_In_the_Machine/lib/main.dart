import 'package:flutter/material.dart';
import 'package:Ghost_In_the_Machine/splashScreen.dart';

//import 'package:flutter/services.dart';

void main() {
  //修改systembar
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   //statusBarBrightness: Brightness.dark,
  //   //statusBarIconBrightness: Brightness.dark,
  //   //statusBarColor: Colors.black,
  // ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 此小部件是应用程序的根。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ghost In the Machine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //对话框设计
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),

      //设计主页mysplashscreen
      home: MySplashScreen(),
    );
  }
}
