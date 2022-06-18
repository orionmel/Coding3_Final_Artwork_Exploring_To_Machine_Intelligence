import 'package:flutter/material.dart';
import 'package:Ghost_In_the_Machine/homeScreen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  //const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context)
  {
    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds: HomeScreen(),
      imageBackground: Image.asset("assets/background_img.png").image,
      image: new Image.asset('assets/main.png'),
      photoSize: 220.0,
      useLoader: true,
      loaderColor: Colors.red,
      loadingText: Text(
        "From Kexin Mei ",
        style: TextStyle(
          color: Colors.yellowAccent,
          fontSize: 16.0,
        ),
      ),
    );
  }
}



