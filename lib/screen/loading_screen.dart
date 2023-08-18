import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';

class loadingscreen extends StatefulWidget {

  @override
  LoadingScreen createState() => LoadingScreen();
}

class LoadingScreen extends State<loadingscreen> {
  SaveData saveData = SaveData();
  Timer? timer;
  bool load_logo = false;
  List<String> messages = [
    '영혼을 일정량 모으면 성장 시킬 수 있습니다.',
    '던전 입장시 소지할 수 있는 영혼은 최대 3개입니다.',
    '전투 시 명상을 사용하면 마나 회복과 해당턴 간 방어력 증가 효과를 얻습니다'
  ];
  int rannum = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      Timer.periodic(Duration(milliseconds: 1500), (timer) {
          rannum = Random().nextInt(messages.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!load_logo){
      Future.delayed(Duration(milliseconds: 100),(){
        setState(() {
            load_logo = true;
        });
      });
    }
    return Stack(
      children: [
        GestureDetector(
          child: Image.asset(
            'asset/image/loading_frame.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          onTap: () {
            setState(() {
              rannum = Random().nextInt(messages.length);
            });
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeOut,
                  width: load_logo? MediaQuery.of(context).size.width/6:0,
                  height: MediaQuery.of(context).size.height/2,
                  child: Image.asset(
                    'asset/image/loading_logo.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_right_outlined,
                  size: 50,
                ),
                Text(
                  '${messages[rannum]}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                Icon(
                  Icons.arrow_left_outlined,
                  size: 50,
                ),
              ],
            ),
            SizedBox()
          ],
        )
      ],
    );
  }
}
