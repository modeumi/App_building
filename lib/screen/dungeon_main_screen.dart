import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';
import 'package:tamer/screen/loading_screen.dart';
import 'package:tamer/screen/main_screen.dart';
import 'package:tamer/screen/stage1/one_one.dart';
import 'package:tamer/model/user_information.dart';

class dungeon_main extends StatefulWidget {
  final user_information user;

  dungeon_main(this.user);

  @override
  _dungeon_main createState() => _dungeon_main();
}

class _dungeon_main extends State<dungeon_main> {
  SaveData saveData = SaveData();
  OverlayEntry? not_messege;
  late Timer timer;
  bool load = true;
  Map<String, bool> clear = {};
  bool click = true;
  String door_1 = 'asset/image/dungeon_not_clear.png';
  String door_2 = 'asset/image/dungeon_not_clear.png';
  String door_3 = 'asset/image/dungeon_not_clear.png';
  String door_4 = 'asset/image/dungeon_not_clear.png';
  String door_5 = 'asset/image/dungeon_not_clear.png';
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    super.initState();
    audioPlayer.open(Audio('asset/audio/dungeon_main.mp3'),
        loopMode: LoopMode.single, autoStart: true, showNotification: false);
    if (widget.user.user_clear['1-1'] == true) {
      door_1 = 'asset/image/dungeon_clear.png';
    }
    if (widget.user.user_clear['1-2'] == true) {
      door_2 = 'asset/image/dungeon_clear.png';
    }
    if (widget.user.user_clear['1-3'] == true) {
      door_3 = 'asset/image/dungeon_clear.png';
    }
    if (widget.user.user_clear['1-4'] == true) {
      door_4 = 'asset/image/dungeon_clear.png';
    }
    if (widget.user.user_clear['1-5'] == true) {
      door_5 = 'asset/image/dungeon_clear.png';
    }
    loading();
  }

  Future<void> loading() async {
    await saveData.save_data(widget.user);
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        load = false;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> Possess_Soul() async {
    not_messege = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment(0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('asset/image/state_panel3.png'),
            fit: BoxFit.fill,
          )),
          child: Center(
            child: Text(
              '아직 입장할 수 없는 장소입니다.\n(추후 업데이트를 기다려주세요)',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(not_messege!);
    await Timer(Duration(milliseconds: 1700), () {
      not_messege!.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? loadingscreen()
        : Stack(
            children: [
              Image.asset(
                'asset/image/dungeon_main.png',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height / 8,
                  right: MediaQuery.of(context).size.width / 1.3,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (click) {
                            setState(() {
                              click = false;
                            });
                            audioPlayer.stop();
                            Map<String, dynamic> result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => oneandone(
                                          user_info: widget.user,
                                        )));
                            setState(() {
                              for (String soul in result['clear_reward'].keys) {
                                widget.user.user_inventory['$soul'] =
                                    ((widget.user.user_inventory['$soul'] ??
                                                0) +
                                            result['clear_reward']['$soul'])
                                        .toInt();
                              }
                              widget.user.user_clear['1-1'] =
                                  result['clear_result'];
                              widget.user.user_exp += result['exp'] as int;
                              widget.user.levelup();
                              if (widget.user.user_clear['1-1'] == true) {
                                door_1 = 'asset/image/dungeon_clear.png';
                              } else {
                                door_1 = 'asset/image/dungeon_not_clear.png';
                              }
                              audioPlayer.open(Audio('asset/audio/dungeon_main.mp3'));
                              click = true;
                            });
                          }
                        },
                        child: Image.asset(
                          door_1,
                          width: MediaQuery.of(context).size.width / 7,
                        ),
                      ),
                      Text(
                        '1 - 1',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ],
                  )),
              Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  right: MediaQuery.of(context).size.width / 1.6,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (click) {
                            click = false;
                            await Possess_Soul();
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                click = true;
                              });
                            });
                          }
                          // Map<String, dynamic> result = await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => oneandtwo(widget.user)));
                          // setState(() {
                          //   widget.user.user_clear['1-2'] = result['clear_result'];
                          //   widget.user.user_exp += result['exp'] as int;
                          //   if (widget.user.user_clear['1-2'] == true) {
                          //     door_2 = 'asset/image/dungeon_clear.png';
                          //   }
                          //   else {
                          //     door_2 = 'asset/image/dungeon_not_clear.png';
                          //   }
                          // });
                        },
                        child: Image.asset(
                          door_2,
                          width: MediaQuery.of(context).size.width / 7,
                        ),
                      ),
                      Text(
                        '1 - 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.0,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ],
                  )),
              // 1- 3 스테이지
              Positioned(
                top: MediaQuery.of(context).size.height / 3,
                left: MediaQuery.of(context).size.width / 2.4,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (click) {
                          click = false;
                          await Possess_Soul();
                          Timer(Duration(seconds: 2), () {
                            setState(() {
                              click = true;
                            });
                          });
                        }
                        // Map<String, dynamic> result = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => oneandthree(widget.user)));
                        // setState(() {
                        //
                        //   widget.user.user_clear['1-3'] = result['clear_result'];
                        //   widget.user.user_exp += result['exp'] as int;
                        //   if (widget.user.user_clear['1-3'] == true) {
                        //     door_3 = 'asset/image/dungeon_clear.png';
                        //   }
                        //   else {
                        //     door_3 = 'asset/image/dungeon_not_clear.png';
                        //   }
                        // });
                      },
                      child: Image.asset(
                        door_3,
                        width: MediaQuery.of(context).size.width / 7,
                      ),
                    ),
                    Text(
                      '1 - 3',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),

              // 1-4 스테이지
              Positioned(
                  top: MediaQuery.of(context).size.height / 2.5, //2.3 / bo
                  left: MediaQuery.of(context).size.width / 1.75, // 9 / ri
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (click) {
                            click = false;
                            await Possess_Soul();
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                click = true;
                              });
                            });
                          }
                          // Map<String, dynamic> result = await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => oneandfour(widget.user)));
                          // setState(() {
                          //   widget.user.user_clear['1-4'] = result['clear_result'];
                          //   widget.user.user_exp += result['exp'] as int;
                          //   if (widget.user.user_clear['1-4'] == true) {
                          //     door_4 = 'asset/image/dungeon_clear.png';
                          //   }
                          //   else {
                          //     door_4 = 'asset/image/dungeon_not_clear.png';
                          //   }
                          // });
                        },
                        child: Image.asset(
                          door_4,
                          width: MediaQuery.of(context).size.width / 7,
                        ),
                      ),
                      Text(
                        '1 - 4',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.0,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  )),
              Positioned(
                bottom: MediaQuery.of(context).size.height / 2.3,
                right: MediaQuery.of(context).size.width / 9,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (click) {
                          click = false;
                          await Possess_Soul();
                          Timer(Duration(seconds: 2), () {
                            setState(() {
                              click = true;
                            });
                          });
                        }

                        // Map<String, dynamic> result = await Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => oneandfive(widget.user)));
                        // setState(() {
                        //   widget.user.user_clear['1-5'] = result['clear_result'];
                        //   widget.user.user_exp += result['exp'] as int;
                        //   if (widget.user.user_clear['1-5'] == true) {
                        //     door_5 = 'asset/image/dungeon_clear.png';
                        //   }
                        //   else {
                        //     door_5 = 'asset/image/dungeon_not_clear.png';
                        //   }
                        // });
                      },
                      child: Image.asset(
                        door_5,
                        width: MediaQuery.of(context).size.width / 7,
                      ),
                    ),
                    Text(
                      '1 - 5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment(1, -1),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    audioPlayer.stop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Main_screen(widget.user)));
                  },
                  child: Image.asset(
                    'asset/image/back_button.png',
                    width: MediaQuery.of(context).size.width / 4.5,
                  ),
                ),
              ),
            ],
          );
  }
}
