import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';
import 'package:tamer/screen/dungeon_main_screen.dart';
import 'package:tamer/screen/information_screen.dart';
import 'package:tamer/screen/loading_screen.dart';
import 'package:tamer/screen/pick_screen.dart';
import 'package:tamer/model/user_information.dart';

class Main_screen extends StatefulWidget {
  final user_information user;

  Main_screen(this.user);

  @override
  main_screen createState() => main_screen();
}

class main_screen extends State<Main_screen> {
  SaveData saveData = SaveData();
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  bool load = true;

  @override
  void initState() {
    super.initState();
    audioPlayer.open(Audio('asset/audio/main_info.mp3'),
        loopMode: LoopMode.single, autoStart: true, showNotification: false);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? loadingscreen()
          : Stack(
              children: [
                Image.asset(
                  'asset/image/main_back.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
                Align(
                  alignment: Alignment(-1.0, -1.0),
                  child: Image.asset(
                    'asset/image/character_info.png',
                    width: MediaQuery.of(context).size.width / 2.31,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 3.6,
                  left: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 0.99,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Pickscreen(widget.user)));
                        },
                        child: Image.asset(
                          'asset/image/pick_up.png',
                          width: MediaQuery.of(context).size.width / 11,
                          height: 80.0,
                        ),
                      ),
                      Text(
                        '뽑기',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height / 1.9,
                  left: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 0.99,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Inforscreen(widget.user)));
                        },
                        child: Image.asset(
                          'asset/image/information.png',
                          width: MediaQuery.of(context).size.width / 11,
                        ),
                      ),
                      Text(
                        '정보',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      )
                    ],
                  ),
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height / 1.32,
                    left: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width * 0.99,
                    child: Column(children: [
                      GestureDetector(
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      dungeon_main(widget.user)));
                        },
                        child: Image.asset(
                          'asset/image/enter_dungeon.png',
                          width: MediaQuery.of(context).size.width / 11,
                        ),
                      ),
                      Text(
                        '던전 입장',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      )
                    ])),
                Positioned(
                  top: MediaQuery.of(context).size.height / 9,
                  left: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 0.4,
                  child: Image.asset(
                    'asset/image/charater1.png',
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 1.336,
                  left: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width * 0.987,
                  child: Image.asset(
                    'asset/image/header1.png',
                    width: MediaQuery.of(context).size.width / 11,
                  ),
                ),
                Align(
                    alignment: Alignment(-0.65, -0.85),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 7,
                      child: Column(
                        children: [
                          Text(
                            '이름 : ${widget.user.user_name} \n등급: ${widget.user.user_level}',
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.white),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 5,
                            child: Row(
                              children: [
                                Text(
                                  '경험치 ',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 10,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: 0 +
                                          (100 *
                                              (widget.user.user_exp /
                                                  widget.user.user_max_exp)),
                                      height: 10,
                                      color: Colors.yellow,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                Align(
                  alignment: Alignment(-0.63, -0.65),
                  child: Stack(
                    children: [],
                  ),
                ),
              ],
            ),
    );
  }
}
