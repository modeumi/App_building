import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tamer/model/user_information.dart';
import 'package:tamer/screen/stage1/battle_page_one.dart';

class oneandtwo extends StatefulWidget {
  final user_information user;
  oneandtwo(this.user);
  OneandTwo createState() => OneandTwo();
}

class OneandTwo extends State<oneandtwo> {
  OverlayEntry? empty_box;
  int clear_1 = 1;
  late int botton_point = -910;
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
    left_point = left_point.clamp(-2780, 285);
    botton_point = botton_point.clamp(-1120,185);
    if (left_point >= -295 && botton_point <= -1120){
      botton_point = -1120;
    }
    if (botton_point >= -1120 && botton_point <= -1040 && left_point <= -295 && left_point >= -320){
      left_point = -295;
    }
    if (botton_point >= -880 && botton_point <= -670 && left_point <= -295 && left_point >= -320){
      left_point = -295;
    }
    if (left_point >=-295 && botton_point >= -680 ){
      botton_point = -680;
    }
    if (left_point <= -315 && left_point >= -1550 && botton_point <=-1015){
      botton_point = -1015;
    }
    if (left_point <= -315 && left_point >= -1395 && botton_point > -895){
      botton_point = -895;
    }
    if (botton_point >= -1015 && botton_point <= -130 && left_point <= -1540 && left_point >= -1560){
      left_point = -1540;
    }
    if( botton_point <= 20&& botton_point >=-880 && left_point >= -1430  && left_point <= -1350){
      left_point =-1430;
    }
    if(left_point <= -1565 && left_point >= -2180 && botton_point <= -120&& botton_point >= -140){
      botton_point = -120;
    }
    if(left_point >= -2180 && left_point <= -1430 && botton_point >=20 && botton_point <= 40){
      botton_point = 20;
    }
    if (botton_point >= 40 && botton_point <= 190 && left_point >= -2200 && left_point <= -2160){
      left_point = -2200;
    }
    if (botton_point <= -130 && botton_point >= -260 && left_point >= -2210 && left_point <= -2190){
    left_point = -2210;
    }
    if (left_point<= -2210 && botton_point< -260){
      botton_point = -260;
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
                'asset/image/1-2.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 4,
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
            Positioned(
              top: 170,
              left: 70,
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
                child: Image.asset('asset/image/up_b.png'),
              ),
            ),
            Positioned(
              top: 270,
              left: 70,
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
            Positioned(
              top: 240,
              left: 110,
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
            Positioned(
              top: 240,
              left: 0,
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
            Positioned(
              top: 270,
              left: 650,
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
                    Navigator.of(context).pop(true);
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
