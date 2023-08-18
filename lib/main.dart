import 'package:flutter/material.dart';
import 'package:tamer/screen/home_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
          fontFamily: 'MBC',
          textTheme: TextTheme(
              headline1: TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.w400,
              ),
              headline2: TextStyle(
                color: Colors.blue,
                fontSize: 50.0,
                fontWeight: FontWeight.w400,
              ),
              headline3: TextStyle(
                color: Colors.black,
                fontSize: 50.0,
                fontWeight: FontWeight.w400,
              ))),
    ));
  });
}
