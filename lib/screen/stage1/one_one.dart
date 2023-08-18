import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/model/user_information.dart';
import 'package:tamer/screen/stage1/battle_page_one.dart';

class oneandone extends StatefulWidget {
  final user_information user_info;

  oneandone({required this.user_info});

  Oneandone createState() => Oneandone();
}

class Oneandone extends State<oneandone> {
  OverlayEntry? empty_box;
  OverlayEntry? message_box;
  OverlayEntry? bag_box;
  OverlayEntry? no_item;
  OverlayEntry? open_fence;
  Map<String, int> reward = {};
  bool message_down = true;
  int clear_1 = 1;
  int chest_1_state = 1;
  bool fence_1_state = true;
  int botton_point = -1230;
  int left_point = 15;
  bool first_message = true;
  bool second_message = true;
  bool third_message = true;
  Timer? _timer;
  Timer? _move;
  int count = 0;
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
  String chest_1 = 'asset/image/chest_front_close.png';
  String fence_1 = 'asset/image/fence_RtoL.png';
  String action_button = 'asset/image/masic_circle.png';
  bool status = false;
  Map<String, Widget> item_widget = {};
  Map<String, String> item_name = {'old_key': '낡은 열쇠', 'slime': '슬라임의 영혼'};
  List<String> item = [];
  Map<String, dynamic> clear_rewards = {};
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  List<String> skill = [];

  void ran_skill() {
    List<String> user_souls = widget.user_info.user_souls.keys.toList();
    if (user_souls.length > 3) {
      while (skill.length < 3) {
        String ranskill = user_souls[Random().nextInt(user_souls.length)];
        if (!skill.contains(ranskill)) {
          skill.add(ranskill);
        }
      }
    } else {
      skill = user_souls;
      if (skill.length < 3) {
        while (skill.length < 3) {
          skill.add('none');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.open(Audio('asset/audio/in_dungeon.mp3'),
        loopMode: LoopMode.single, autoStart: true, showNotification: false);
  }

  void messege(int bottom, int left) {
    if (bottom == -1230 && left == 15 && first_message == true) {
      message_down = true;
      message_box = OverlayEntry(
          builder: (context) => Align(
                alignment: Alignment(0, 1),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 1),
                      child: Image.asset(
                        'asset/image/state_panel2.png',
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.8),
                      child: Text(
                        '몬스터의 기운이 느껴진다. \n (앞으로 전진하세요) ',
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
                          message_box?.remove();
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
      Overlay.of(context).insert(message_box!);
      if (message_down) {
        Timer(Duration(seconds: 2), () {
          message_box?.remove();
        });
      }
      first_message = false;
    }
    if (left_point <= -645 && second_message == true) {
      message_down = true;
      message_box = OverlayEntry(
          builder: (context) => Align(
                alignment: Alignment(0, 1),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 1),
                      child: Image.asset(
                        'asset/image/state_panel2.png',
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.85),
                      child: Text(
                        '상자에서 아이템을 획득해서 \n 다른 상호작용에 \n 사용할 수 있습니다.',
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
                          message_box?.remove();
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
      second_message = false;
      Overlay.of(context).insert(message_box!);
      if (message_down) {
        Timer(Duration(seconds: 2), () {
          message_box?.remove();
        });
      }
    }
    if (left_point <= -1485 && third_message == true) {
      message_down = true;
      message_box = OverlayEntry(
          builder: (context) => Align(
                alignment: Alignment(0, 1),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 1),
                      child: Image.asset(
                        'asset/image/state_panel2.png',
                        height: MediaQuery.of(context).size.height / 3.5,
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.7),
                      child: Text(
                        '전방에 몬스터가 출현했습니다. \n 전투를 하여 승리하십시오!',
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
                          message_box?.remove();
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
      third_message = false;
      Overlay.of(context).insert(message_box!);
      if (message_down) {
        Timer(Duration(seconds: 2), () {
          message_box?.remove();
        });
      }
    }
  }

  void Empty_box() {
    empty_box = OverlayEntry(
        builder: (context) => Align(
              alignment: Alignment(0, 1),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1),
                    child: Image.asset(
                      'asset/image/state_panel2.png',
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
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

  void No_item(String item) {
    no_item = OverlayEntry(
        builder: (context) => Align(
              alignment: Alignment(0, 1),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1),
                    child: Image.asset(
                      'asset/image/state_panel2.png',
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      '"${item_name[item]}" 이(가) 필요합니다.',
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
                        no_item?.remove();
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
    Overlay.of(context).insert(no_item!);
    if (message_down) {
      Timer(Duration(seconds: 2), () {
        no_item?.remove();
      });
    }
  }

  void Open_fence(String item) {
    message_down = true;
    open_fence = OverlayEntry(
        builder: (context) => Align(
              alignment: Alignment(0, 1),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1),
                    child: Image.asset(
                      'asset/image/state_panel2.png',
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      '"${item_name[item]}" 을(를) 사용하여\n문을 열었습니다.',
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
                        open_fence?.remove();
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
    Overlay.of(context).insert(open_fence!);
    if (message_down) {
      Timer(Duration(seconds: 2), () {
        open_fence?.remove();
      });
    }
  }

  void get_items(String item, int num) {
    message_down = true;
    empty_box = OverlayEntry(
        builder: (context) => Align(
              alignment: Alignment(0, 1),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(0, 1),
                    child: Image.asset(
                      'asset/image/state_panel2.png',
                      height: MediaQuery.of(context).size.height / 3.5,
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.7),
                    child: Text(
                      '"${item_name[item]}" x ${num} 을(를) \n 획득하였습니다.',
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
                        setState(() {
                        message_down = false;
                        });
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

  void bag() {
    bag_box = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment(0, 1),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, 1),
              child: Image.asset(
                'asset/image/state_panel2.png',
                height: MediaQuery.of(context).size.height / 3.5,
              ),
            ),
            if (item.isNotEmpty)
              Align(
                  alignment: Alignment(0, 1),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (String name in item)
                          item_widget[name] = Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'asset/image/item_${name}.png',
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${item_name[name]} x ${reward[name]}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  )),
            if (item.isEmpty)
              Align(
                alignment: Alignment(0, 0.8),
                child: Text(
                  '비어있음.',
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
                  bag_box?.remove();
                },
                child: Icon(
                  Icons.subdirectory_arrow_left,
                  size: 50,
                ),
              ),
            )
          ],
        ),
      ),
    );
    Overlay.of(context).insert(bag_box!);
  }

  void move(int ch_botton, int ch_left, String standing, String work) {
    _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
      messege(botton_point, left_point);
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
      if (left_point <= -805 && left_point >= -905 && botton_point <= -1270) {
        action_button = 'asset/image/chest_button.png';
      } else if (left_point <= -1025 &&
          left_point >= -1065 &&
          fence_1_state == true) {
        action_button = 'asset/image/key_button.png';
      } else if (left_point <= -1785 &&
          left_point >= -1965 &&
          botton_point <= -1150 &&
          botton_point >= -1260 &&
          clear_1 == 1) {
        action_button = 'asset/image/battle_button.png';
      } else if (left_point <= -1785 &&
          left_point >= -1965 &&
          botton_point <= -1150 &&
          botton_point >= -1260 &&
          clear_1 == 2) {
        action_button = 'asset/image/chest_button.png';
      } else if (left_point <= -2010 &&
          left_point >= -4130 &&
          botton_point >= -1240 &&
          botton_point <= -1160 &&
          clear_1 == 3) {
        action_button = 'asset/image/teleport_button.png';
      } else {
        action_button = 'asset/image/masic_circle.png';
      }
    });
  }

  void limit_point() {
    left_point = left_point.clamp(-2150, 295);
    if (left_point >= -285 && botton_point <= -1430) {
      botton_point = -1430;
    }
    if (left_point >= -285 && botton_point >= -990) {
      botton_point = -990;
    }
    if (botton_point <= -990 &&
        botton_point >= -1190 &&
        left_point <= -285 &&
        left_point >= -425) {
      left_point = -285;
    }
    if (botton_point <= -1350 &&
        botton_point >= -1430 &&
        left_point <= -285 &&
        left_point >= -425) {
      left_point = -285;
    }
    if (left_point <= -300 && left_point >= -1535 && botton_point <= -1340) {
      botton_point = -1335;
    }
    if (left_point <= -300 && left_point >= -1535 && botton_point >= -1200) {
      botton_point = -1205;
    }
    if (botton_point <= -970 &&
        botton_point >= -1190 &&
        left_point >= -1560 &&
        left_point <= -1220) {
      left_point = -1565;
    }
    if (botton_point <= -1350 &&
        botton_point >= -1450 &&
        left_point >= -1560 &&
        left_point <= -1220) {
      left_point = -1565;
    }
    if (left_point <= -1550 && botton_point <= -1440) {
      botton_point = -1440;
    }
    if (left_point <= -1550 && botton_point >= -980) {
      botton_point = -980;
    }
    if (fence_1_state == true && left_point <= -1065) {
      left_point = -1065;
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Positioned(
          bottom: botton_point.toDouble(),
          left: left_point.toDouble(),
          child: Image.asset(
            'asset/image/1-1.png',
            fit: BoxFit.none,
            width: 7171,
            alignment: Alignment.topLeft,
          ),
        ),
        Positioned(
            top: (-1185 - botton_point).toDouble(),
            right: (-450 - left_point).toDouble(),
            child: Image.asset(chest_1)),
        Positioned(
          top: (-1700 - botton_point).toDouble(),
          right: (-800 - left_point).toDouble(),
          child: Image.asset(fence_1),
          width: MediaQuery.of(context).size.width / 3.5,
        ),
        Positioned(
          top: (-1100 - botton_point).toDouble(),
          right: (-1500 - left_point).toDouble(),
          child: Image.asset(
            monster_1,
            alignment: Alignment.center,
          ),
          width: MediaQuery.of(context).size.width / 7,
        ),
        Align(
          alignment: Alignment(-0.8, 0.2),
          child: GestureDetector(
            onTapDown: (details) {
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
        Align(
          alignment: Alignment(-0.8, 0.92),
          child: GestureDetector(
            onTapDown: (details) {
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
          alignment: Alignment(-0.685, 0.5),
          child: GestureDetector(
            onTapDown: (details) {
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
          alignment: Alignment(-0.98, 0.5),
          child: GestureDetector(
            onTapDown: (details) {
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
        Align(
          alignment: Alignment(-0.05, -0.2),
          child: Image.asset(
            nomal_standing,
            width: 100,
          ),
        ),
        Align(
          alignment: Alignment(1, 1),
          child: GestureDetector(
            onTap: () async {
                if (left_point <= -1785 &&
                    left_point >= -1965 &&
                    botton_point <= -1150 &&
                    botton_point >= -1260) {
                  if (clear_1 == 1) {
                    ran_skill();
                    int result_1 = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                one_one_battle(widget.user_info, skill)));
                    setState(() {
                      clear_1 = result_1;
                      monster_1 = 'asset/image/chest_front_close.png';
                    });
                  } else if (clear_1 == 2) {
                    setState(() {
                      reward['slime'] = 10;
                      item.add('slime');
                      get_items('slime', 10);
                      clear_1 = 3;
                      monster_1 = 'asset/image/chest_front_open.png';
                    });
                  } else if (clear_1 == 3) {
                    Empty_box();
                  }
                }
                if (left_point <= -2010 &&
                    left_point >= -4130 &&
                    botton_point >= -1240 &&
                    botton_point <= -1160 &&
                    clear_1 == 3) {
                  clear_rewards['clear_result'] = true;
                  clear_rewards['clear_reward'] = reward;
                  clear_rewards['exp'] = 100.toInt();
                  audioPlayer.stop();
                  Navigator.of(context).pop(clear_rewards);
                }
                if (left_point <= -805 &&
                    left_point >= -905 &&
                    botton_point <= -1270) {
                  if (chest_1_state == 1) {
                    get_items('old_key', 1);
                    setState(() {
                      item.add('old_key');
                      reward['old_key'] = 1;
                      chest_1 = 'asset/image/chest_front_open.png';
                      chest_1_state = 2;
                    });
                  } else if (chest_1_state == 2) {
                    Empty_box();
                  }
                }
                if (left_point <= -1025 &&
                    fence_1_state == true &&
                    item.contains('old_key')) {
                  Open_fence('old_key');
                  item.remove('old_key');
                  reward.remove('old_key');
                  setState(() {
                    fence_1_state = false;
                    fence_1 = 'asset/image/none.png';
                  });
                } else if (left_point <= -1025 &&
                    fence_1_state == true &&
                    !item.contains('old_key')) {
                  No_item('old_key');
                }
            },
            child: Image.asset(
              action_button,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ),
        ),
        Align(
            alignment: Alignment(0.6, 1),
            child: GestureDetector(
              onTap: () {
                bag();
              },
              child: Image.asset(
                'asset/image/bag.png',
                width: MediaQuery.of(context).size.width / 6,
              ),
            )),
        if (clear_1 != 1)
          Positioned(
            top: (-1120 - botton_point).toDouble(),
            right: (-1700 - left_point).toDouble(),
            child: Image.asset(
              'asset/image/portal.png',
            ),
          )
      ],
    ));
  }
}
