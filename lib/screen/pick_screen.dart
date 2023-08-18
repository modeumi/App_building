import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';
import 'package:tamer/screen/loading_screen.dart';
import 'package:tamer/screen/main_screen.dart';
import 'dart:math';

import 'package:tamer/screen/pick_before_screen.dart';
import 'package:tamer/model/user_information.dart';

class Pickscreen extends StatefulWidget {
  final user_information user;

  Pickscreen(this.user);

  @override
  PickScreen createState() => PickScreen();
}

class PickScreen extends State<Pickscreen> {
  SaveData saveData =SaveData();
  OverlayEntry? invalid;
  late Timer timer_pick;
  bool load = true;
  bool complete = false;
  bool switch_bool = false;
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.open(Audio('asset/audio/pick_up.mp3'),
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
    timer_pick.cancel();
    super.dispose();
  }

  void invalid_widget() {
    invalid = OverlayEntry(
        builder: (context) => Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.7,
                    height: MediaQuery.of(context).size.height / 4,
                    child: Center(
                      child: Text(
                        '정화된 자의 영혼이 부족합니다.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'asset/image/state_panel3.png',
                      ),
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
                Align(
                  alignment: Alignment(0.52, 0.15),
                  child: GestureDetector(
                    onTap: () {
                      invalid?.remove();
                    },
                    child: Image.asset('asset/image/back_button2.png'),
                  ),
                )
              ],
            ));
    Overlay.of(context).insert(invalid!);
    Timer(Duration(seconds: 1), () {
      invalid?.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? loadingscreen()
        : Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  'asset/image/pick_back.png',
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Positioned(
                  top: FractionalOffset(0.0, 0.0).dy,
                  right: FractionalOffset(0.0, 0.5).dx,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          audioPlayer.stop();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Main_screen(widget.user)));
                        },
                        child: Image.asset(
                          'asset/image/back_button.png',
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: FractionalOffset(0.0, 0.0).dx,
                  child: Stack(
                    children: [
                      Image.asset(
                        'asset/image/count_panel.png',
                        width: 200,
                      ),
                      Positioned(
                        top: 65,
                        left: 10,
                        child: Text(
                          'count : ${widget.user.user_pick_count}',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 10,
                        child: Container(
                          width: 130,
                          height: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 10,
                        child: Container(
                          width: 130 * (widget.user.user_pick_count / 70),
                          height: 15,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: FractionalOffset(0.0, 0.0).dx,
                  child: Image.asset(
                    'asset/image/character_info.png',
                    width: 300.0,
                    height: 105.0,
                  ),
                ),
                Align(
                  alignment: Alignment(-0.983, -0.91),
                  child: Image.asset(
                    'asset/image/pick_up.png',
                    width: 80,
                  ),
                ),
                Align(
                  alignment: Alignment(-0.6, -0.78),
                  child: Text(
                    '뽑기',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment(0.4, 1.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.user.user_inventory['nomal']! >= 10) {
                        picktable Picktable =
                            picktable(widget.user.user_pick_count);
                        Picktable.gotcha_one(widget.user);
                        String character = Picktable.pickresult;
                        audioPlayer.stop();
                        setState(() {
                          widget.user.user_inventory['nomal'] = (widget.user.user_inventory['nomal']?? 0) - 10;
                          if(widget.user.user_inventory['nomal'] == 0){
                            widget.user.user_inventory.remove('nomal');
                          }
                          switch_bool = false;
                        });
                        int counts = Picktable.count;
                        switch_bool = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Pick_before_screen(
                                    type: 'one',
                                    character_slot: character,
                                    user: widget.user)));
                        setState(() {
                          if (switch_bool == true) {
                            audioPlayer.play();
                          }
                          widget.user.user_pick_count = counts;
                        });
                      } else {
                        invalid_widget();
                      }
                    },
                    child: Image.asset(
                      'asset/image/pick_one.png',
                      width: MediaQuery.of(context).size.width / 5,
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment(1.0, 1.0),
                    child: GestureDetector(
                      onTap: () async {
                        if (widget.user.user_inventory['nomal']! >= 90) {
                          picktable Picktable =
                              picktable(widget.user.user_pick_count);
                          Picktable.gotcha_ten(widget.user);
                          List<String> character = Picktable.pickresult_ten;
                          int counts = Picktable.count;
                          audioPlayer.stop();
                          setState(() {
                            widget.user.user_inventory['nomal'] = (widget.user.user_inventory['nomal']?? 0) - 90;
                            if(widget.user.user_inventory['nomal'] == 0){
                              widget.user.user_inventory.remove('nomal');
                            }
                            switch_bool = false;
                          });
                          switch_bool = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Pick_before_screen(
                                      type: 'ten',
                                      character_slot: character,
                                      user: widget.user)));
                          setState(() {
                            if (switch_bool == true) {
                              audioPlayer.play();
                            }
                            widget.user.user_pick_count = counts;
                          });
                        } else {
                          invalid_widget();
                        }
                      },
                      child: Image.asset(
                        'asset/image/pick_ten.png',
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                    )),
                Align(
                  alignment: Alignment(0.5, -1),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 8,
                    height: MediaQuery.of(context).size.height / 8,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('asset/image/cost_image.png'),
                      fit: BoxFit.fill,
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'asset/image/item_nomal.png',
                          height: MediaQuery.of(context).size.height / 10,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(':  ${(widget.user.user_inventory['nomal'] ?? 0)}'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class picktable {
  final Map<String, List<String>> Grade = {
    'unique': ['gargoyle', 'durahan', 'woonst'],
    'rare': ['wolf', 'snakuble'],
    'nomal': ['goblin', 'skeleton', 'slime', 'nepenthes', 'bibat']
  };
  String grade = '';
  String pickresult = '';
  late int pick;
  late int rare_ran;
  late int unique_ran;
  late int nomal_ran;
  int count = 0;
  List<String> pickresult_ten = [];
  Map<String, int> pick_addinfo = {};

  picktable(int usercount) {
    pick = (Random().nextInt(30)) + 1;
    rare_ran = Random().nextInt(Grade['rare']!.length);
    unique_ran = Random().nextInt(Grade['unique']!.length);
    nomal_ran = Random().nextInt(Grade['nomal']!.length);
    count = usercount;
  }

  void gotcha_one(user_information user) {
    pick = (Random().nextInt(30)) + 1;
    if (count >= 70) {
      this.pickresult = Grade['unique']![unique_ran];
      count = 0;
      this.count = 0;
    } else {
      if (pick <= 15) {
        this.pickresult = Grade['nomal']![nomal_ran];
        this.count += 1;
      } else if (pick > 15 && pick <= 25) {
        this.pickresult = Grade['rare']![rare_ran];
        this.count += 1;
      } else if (pick > 25) {
        this.pickresult = Grade['unique']![unique_ran];
        this.count += 1;
      }
      Grade.forEach((key, value) {
        if (value == this.pickresult) {
          this.grade = key;
        }
      });
    }
    if (user.user_souls.keys.contains(pickresult)) {
      user.user_inventory['$pickresult'] =
          (user.user_inventory['$pickresult'] ?? 0) + 10;
    } else {
      user.user_souls[pickresult] =1;
    }
  }

  void gotcha_ten(user_information user) {
    this.pickresult_ten = [];
    for (int i = 1; i <= 10; i++) {
      pick = (Random().nextInt(30)) + 1;
      if (count >= 70) {
        this.pickresult = Grade['unique']![unique_ran];
        this.pickresult_ten.add(this.pickresult);
        this.count = 0;
      } else {
        if (pick <= 15) {
          this.pickresult = Grade['nomal']![nomal_ran];
          this.pickresult_ten.add(this.pickresult);
          this.count += 1;
        } else if (pick > 15 && pick <= 25) {
          this.pickresult = Grade['rare']![rare_ran];
          this.pickresult_ten.add(this.pickresult);
          this.count += 1;
        } else if (pick > 25) {
          this.pickresult = Grade['unique']![unique_ran];
          this.pickresult_ten.add(this.pickresult);
          this.count = 0;
        }
        Grade.forEach((key, value) {
          if (value == this.pickresult) {
            this.grade = key;
          }
        });
      }
    }
    for (String souls in pickresult_ten) {
      if (user.user_souls.keys.contains(souls)) {
        user.user_inventory['$souls'] =
            (user.user_inventory['$souls'] ?? 0) + 10;
      } else {
        user.user_souls[souls] =1;
      }
    }
  }
}
