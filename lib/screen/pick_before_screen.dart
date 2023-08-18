import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';
import 'package:tamer/screen/loading_screen.dart';
import 'package:tamer/model/user_information.dart';

class Pick_before_screen extends StatefulWidget {
  final String type;
  final dynamic character_slot;
  final user_information user;

  Pick_before_screen(
      {required this.type, required this.character_slot, required this.user});

  @override
  Pick_Before_Screen createState() => Pick_Before_Screen(type, character_slot);
}

class Pick_Before_Screen extends State<Pick_before_screen> {
  SaveData saveData = SaveData();
  bool load = true;
  String picktype = '';
  List<String> C_List = [];
  String C_one = '';
  bool onepick = false;
  Map<String, bool> view = {};
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  bool back = false;

  Pick_Before_Screen(String type, dynamic character) {
    this.picktype = type;
    if (character is List<String>) {
      C_List = character;
    } else if (character is String) {
      C_one = character;
    }
  }

  @override
  void initState() {
    super.initState();
    loading();
    setState((){
      for (int i = 1; i < 11; i++) {
        view['view$i'] = false;
      }
    });
    action();
  }
  Future<void> loading() async {
    await saveData.save_data(widget.user);
      setState(() {
        load = false;
      });
  }

  void action() async {
    if (picktype == 'ten') {
      for (int i = 1; i < 11; i++) {
        await Future.delayed(Duration(milliseconds: 200), () {});
        setState(() {
          view['view$i'] = true;
          if (i == 10) {
            back = true;
          }
        });
        audioPlayer.open(Audio('asset/audio/pick_ten.wav'),
            loopMode: LoopMode.none, autoStart: true, showNotification: false);
      }
    }
  }

  final Map<String, String> character_name = {
    'gargoyle': '가고일',
    'durahan': '듀라한',
    'wolf': '늑대',
    'goblin': '고블린',
    'skeleton': '스켈레톤',
    'slime': '슬라임',
    'bibat': '비배트',
    'woonst': '운스트',
    'snakuble': '스네이커블',
    'nepenthes': '네펜데스'
  };
  final Map<String, String> character_info = {
    'gargoyle': '문지기, \n돌피부',
    'durahan': '머리없음, \n목에서 불남',
    'fenrir': '늑대의 형상, \n거대함',
    'auger': '큰 몸집,\n 공격적',
    'goblin': '지능 떨어짐, \n집단생활',
    'skeleton': '지능이 낮음, \n명령엔 복종'
  };
  final Map<String, List<String>> Grade = {
    'unique': ['gargoyle', 'durahan', 'woonst'],
    'rare': ['wolf', 'snakuble'],
    'nomal': ['goblin', 'skeleton', 'slime', 'nepenthes', 'bibat']
  };

  @override
  Widget build(BuildContext context) {
    return load
        ? loadingscreen()
        : Stack(
            children: [
              if (this.picktype == 'ten')
                Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        'asset/image/pick_before_back.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          // 각 colum 으로 만들어서 제스처 넣은다음에 이미지 클릭시 해당 클릭 캐릭터 나오도록 조정
                          children: [
                            // 1번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view1']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.8
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 1.27,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[0]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),

                            // 2번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view2']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.50
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 1.18,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[1]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 3번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view3']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 2.0
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 1.10,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[2]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 4번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view4']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.75
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 1.0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[3]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 5번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view5']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.45
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.92,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[4]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 6번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view6']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.85
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.83,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[5]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 7번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view7']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.58
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.74,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[6]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 8번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view8']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 2.0
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.68,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[7]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            //9번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view9']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.75
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.59,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[8]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            // 10번째
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                              top: view['view10']!
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).size.height * 1.5
                                  : MediaQuery.of(context).size.height * -2,
                              left: MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width * 0.50,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'asset/image/monster/${C_List[9]}_pick.png',
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                ),
                              ),
                            ),
                            if (back)
                              Align(
                                alignment: Alignment(1.0, -1.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Image.asset(
                                    'asset/image/back_button.png',
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              else if (this.picktype == 'one')
                Container(
                  color: Colors.grey,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            onepick = true;
                          });
                        },
                        child: Image.asset(
                          'asset/image/one_pick_back2.png',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Align(
                        alignment: Alignment(1, -1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Image.asset(
                            'asset/image/back_button.png',
                            width: MediaQuery.of(context).size.width / 5,
                          ),
                        ),
                      ),
                      if (onepick)
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                onepick = false;
                              });
                            },
                            child: Image.asset(
                              'asset/image/monster/one_pick_${C_one}.png',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
  }
}

