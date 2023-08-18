import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tamer/model/user_information.dart';
import 'package:tamer/screen/stage1/battle_page_one.dart';

class oneandfour extends StatefulWidget {
  final user_information user;
  oneandfour(this.user);
  OneandFour createState() => OneandFour();
}

class OneandFour extends State<oneandfour> {
  OverlayEntry? empty_box;
  int clear_1 = 1;
  late int botton_point = -1240;
  late int left_point = -5;
  bool rock_1= true;
  Timer? _timer;
  Timer? _move;
  int count = 0;
  bool message_down = true;
  String front_standing = 'asset/image/front_stand.png';
  String front_work = 'asset/image/front_work.png';
  String back_standing = 'asset/image/back_stand.png';
  String back_work = 'asset/image/back_work.png';
  String left_standing = 'asset/image/left_stand.png';
  String left_work = 'asset/image/left_work.png';
  String right_standing = 'asset/image/right_stand.png';
  String right_work = 'asset/image/right_work.png';
  String nomal_standing = 'asset/image/back_stand.png';
  String monster_1 = 'asset/image/monster/slime_P.png';
  String monster_2 = 'asset/image/monster/wolf_P.png';
  String monster_3 = 'asset/image/monster/bibat_P.png';
  bool status = false;

  void move(int ch_botton, int ch_left, String standing, String work) {
    _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState(() {
        botton_point += ch_botton;
        left_point += ch_left;
        limit_point();
        count += 1;
        if (count % 2 == 0) {
          nomal_standing = standing;
        } else if (count % 2 != 0) {
          nomal_standing = work;
        }
      });
    });
  }

  void limit_point() {
    left_point = left_point.clamp(-2310, 285);
    botton_point = botton_point.clamp(-1430,185);
    if (botton_point <= -1350 && left_point <= -300 && left_point >= -320){
      left_point = -300;
    }
    if (botton_point >= -1190 && botton_point <= -960 &&left_point <= -300 && left_point >= -320){
      left_point = -300;
    }
    if(left_point >= -300 &&botton_point >= -990 && botton_point <= -970 ){
      botton_point = -990;
    }
    if (left_point <= -320&& left_point >= -1890 && botton_point <= -1330 && botton_point >= -1350){
      botton_point = -1330;
    }
    if (botton_point >= -1330 && botton_point <= -1200 && left_point <= -1890 && left_point >= -1910){
      left_point = -1890;
    }
    if(left_point >= -1890 && left_point <= -1410 && botton_point >= -1200 && botton_point <= -1180){
      botton_point = -1200;
    }
    if(left_point >= -1260 && left_point <= -310 && botton_point>= -1200 && botton_point <= -1180){
      botton_point = -1200;
    }
    if (botton_point >= -1180 && botton_point <=-720&& left_point >= -1280 && left_point <= -1260){
      left_point = -1280;
    }
    if( botton_point >= -1180 &&botton_point<= -720 && left_point <= -1400 && left_point >= -1420){
      left_point = -1400;
    }
    if(left_point <= -1410 &&left_point >= -2030 && botton_point <= -700 && botton_point >= -720){
      botton_point = -700;
    }
    if(left_point >= -1270 &&left_point <= -280 && botton_point<= -700 && botton_point >=-720){
      botton_point = -700;
    }
    if(botton_point >= -700 && botton_point <= -570 && left_point >= -280){
      left_point = -280;
    }
    if(left_point<=-280 && left_point>= -1250 &&botton_point>= -570 && botton_point<= -550){
      botton_point = -570;
    }
    if (left_point <= -1400 && left_point >= -1890  && botton_point>= -570 && botton_point <= -550){
      botton_point = -570;
    }
    if (botton_point >= -550 && botton_point <= -270 && left_point>= -1910 && left_point <= -1890){
      left_point =-1910;
    }
    if(botton_point>= -700 && botton_point <= -275 &&left_point <= -2030 && left_point>= -2050){
      left_point = -2030;
    }
    if(botton_point <=-265 && botton_point >= -285 &&left_point <= -2050){
      botton_point = -265;
    }
    if(botton_point >= 60 && left_point >= -1720 && left_point <= -1700){
      left_point = -1720;
    }
    if(left_point >= -1890 && left_point <= -1720 && botton_point <= -265 && botton_point >= -285){
      botton_point = -265;
    }
    if(botton_point >= -265 && botton_point<=-105&&left_point>= -1720 && left_point<= -1700 ){
      left_point = -1720;
    }
    if(left_point >= -1710 && left_point <= -1410 && botton_point <= -90 && botton_point >= -110){
      botton_point = -90;
    }
    if(left_point>= -1700 && left_point<= -1270 && botton_point >=50 && botton_point <= 70){
      botton_point = 50;
    }
    if(botton_point <= 50 && botton_point >=-560 && left_point >= -1270 && left_point <= -1250){
      left_point = -1270;
    }
    if(botton_point <= -100 && botton_point >= -560 && left_point<= -1390 && left_point >= -1410){
      left_point = -1390;
    }

  }
  void stop(String direction) {
    _timer?.cancel();
    count = 0;
    setState(() {
      if (direction == 'front') {
        nomal_standing = front_standing;
      } else if (direction == 'back') {
        nomal_standing = back_standing;
      } else if (direction == 'left') {
        nomal_standing = left_standing;
      } else if (direction == 'right') {
        nomal_standing = right_standing;
      }
    });
  }

  void Empty_box (){
    message_down = true;
    empty_box = OverlayEntry(
        builder: (context) =>
            Align(
              alignment: Alignment(0, 1),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1),
                    child: Image.asset('asset/image/state_panel2.png',
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3.5,),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      '비어있는 상자 입니다.',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0.42, 1),
                    child: GestureDetector(
                      onTap: () {
                        message_down = false;
                        empty_box?.remove();
                      },
                      child: Icon(
                        Icons.subdirectory_arrow_left,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ));
    Overlay.of(context).insert(empty_box!);
    if (message_down) {
      Timer(Duration(seconds: 2), () {
        empty_box?.remove();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: [
            Positioned(
              bottom: botton_point.toDouble(),
              left: left_point.toDouble(),
              child: Image.asset(
                'asset/image/1-4.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 3.4,
                alignment: Alignment.topLeft,
              ),
            ),
            Positioned(
              top: (20 - botton_point).toDouble(),
              right: (-2100 - left_point).toDouble(),
              child: Image.asset(
                monster_2,
                alignment: Alignment.center,
              ),
              width: MediaQuery.of(context).size.width / 7,
            ),
            Align(
              alignment: Alignment(-0.8,0.1),
              child: GestureDetector(
                onTapDown: (details) {
                  _move?.cancel();
                  setState(() {
                    status = true;
                    move(-20, 0, front_standing, front_work);
                    _move = Timer.periodic(Duration(milliseconds: 1000), (_) {
                      if (status) {
                      } else {
                        _move?.cancel();
                      }
                    });
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    status = false;
                    stop('front');
                    _move?.cancel();
                  });
                },
                onTapCancel: () {
                  setState(() {
                    status = false;
                    stop('front');
                    _move?.cancel();
                  });
                },
                child: Image.asset('asset/image/up_b.png',),
              ),
            ),
            Align(
              alignment: Alignment(-0.8,0.8),
              child: GestureDetector(
                onTapDown: (details) {
                  _move?.cancel();
                  setState(() {
                    status = true;
                    move(20, 0, back_standing, back_work);
                    _move = Timer.periodic(Duration(milliseconds: 1000), (_) {
                      if (status) {
                      } else {
                        _move?.cancel();
                      }
                    });
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    status = false;
                    stop('back');
                    _move?.cancel();
                  });
                },
                onTapCancel: () {
                  setState(() {
                    status = false;
                    stop('back');
                    _move?.cancel();
                  });
                },
                child: Image.asset('asset/image/down_b.png'),
              ),
            ),
            Align(
              alignment: Alignment(-0.68,0.42),
              child: GestureDetector(
                onTapDown: (details) {
                  _move?.cancel();
                  setState(
                        () {
                      status = true;
                      move(0, -20, right_standing, right_work);
                      _move = Timer.periodic(Duration(milliseconds: 1000), (_) {
                        if (status) {
                        } else {
                          _move?.cancel();
                        }
                      });
                    },
                  );
                },
                onTapUp: (details) {
                  setState(() {
                    status = false;
                    stop('right');
                    _move?.cancel();
                  });
                },
                onTapCancel: () {
                  setState(() {
                    status = false;
                    stop('right');
                    _move?.cancel();
                  });
                },
                child: Image.asset('asset/image/right_b.png'),
              ),
            ),
            Align(
              alignment: Alignment(-0.98,0.42),
              child: GestureDetector(
                onTapDown: (details) {

                  _move?.cancel();
                  setState(() {
                    status = true;
                    move(0, 20, left_standing, left_work);
                    _move = Timer.periodic(Duration(milliseconds: 1000), (_) {
                      if (status) {
                      } else {
                        _move?.cancel();
                      }
                    });
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    status = false;
                    stop('left');
                    _move?.cancel();
                  });
                },
                onTapCancel: () {
                  setState(() {
                    status = false;
                    stop('right');
                    _move?.cancel();
                  });
                },
                child: Image.asset('asset/image/left_b.png'),
              ),
            ),
            Positioned(
              top: 100,
              left: 300,
              child: Image.asset(
                nomal_standing,
                width: 100,
              ),
            ),
            Align(
              alignment: Alignment(1,0.9),
              child: GestureDetector(
                onTap: () async {
                  if (left_point <= -4180 &&
                      left_point >= -4360 &&
                      botton_point <= -590 &&
                      botton_point >= -730) {
                    if (clear_1 == 1) {
                      // int result_1 = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => one_one_battle(widget.user)));
                      // setState(() {
                      //   clear_1 = result_1;
                      //   monster_1 = 'asset/image/chest_front_close.png';
                      // });
                    } else if (clear_1 == 2) {
                      setState(() {
                        clear_1 = 3;
                        monster_1 = 'asset/image/chest_front_open.png';
                      });
                    } else if (clear_1 == 3) {
                      Empty_box();
                    }
                  }
                  if (left_point <= -4405&& left_point >= -4525 && botton_point >= -670 &&botton_point<=-610){
                    Navigator.of(context).pop();
                  }
                },
                child: Image.asset(
                  'asset/image/battle.png',
                  width: 150,
                ),
              ),
            ),
            if(clear_1 != 1)
              Positioned(
                top: (-560 - botton_point).toDouble(),
                right: (-4075 - left_point).toDouble(),
                child: Image.asset('asset/image/portal.png',),
              )
          ],
        ));
  }
}
