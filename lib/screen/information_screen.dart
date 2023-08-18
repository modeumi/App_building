import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/database/data_save.dart';
import 'package:tamer/screen/loading_screen.dart';
import 'package:tamer/screen/main_screen.dart';
import 'package:tamer/model/user_information.dart';

class Inforscreen extends StatefulWidget {
  final user_information user;

  Inforscreen(this.user);

  @override
  _Inforscreen createState() => _Inforscreen();
}

class _Inforscreen extends State<Inforscreen> {
  SaveData saveData = SaveData();
  OverlayEntry? invalid;
  bool success_bool = false;
  bool messege_false = false;
  bool messege_success = false;
  String success_string = '>--변환 성공--<';
  String level_string = '>--레벨업!--<';
  dynamic max_exp;

  final Map<String, String> souls_name = {
    'gargoyle': '가고일',
    'durahan': '듀라한',
    'wolf': '늑대',
    'goblin': '고블린',
    'skeleton': '스켈레톤',
    'slime': '슬라임',
    'bibat': '비배트',
    'woonst': '운스트',
    'snakuble': '스네이커블',
    'nepenthes': '네펜데스',
    'nomal': '정화된 자'
  };
  int page = 1;
  late Timer timer_info;
  int item_amount = 0;
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  bool load = true;
  String Name = '';
  Map<String, Widget> Characters = {};
  Map<String, Widget> inventory = {};

  @override
  void initState() {
    super.initState();
    audioPlayer.open(Audio('asset/audio/main_info.mp3'),
        loopMode: LoopMode.single, autoStart: true, showNotification: false);
    loading();
    showWidget();
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
    timer_info.cancel();
    super.dispose();
  }

  void showWidget() {
    for (String name in widget.user.user_souls.keys) {
      Characters[name] = Container(
        child: GestureDetector(
          onTap: () {
            setState(() {
              this.Name = name;
              if (widget.user.user_souls[Name]! < 10) {
                max_exp = (5 + (widget.user.user_souls[Name]! - 1) * 4);
              } else {
                max_exp = '최대 레벨에 도달했습니다.';
              }
            });
          },
          child: Image.asset('asset/image/monster/${name}_D.png'),
        ),
      );
    }
    if (widget.user.user_inventory.isNotEmpty) {
      for (String name in widget.user.user_inventory.keys) {
        inventory[name] = Container(
          height: 50,
          child: GestureDetector(
            onTap: () {
              setState(() {
                item_amount = 0;
                Name = name;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'asset/image/item_${name}.png',
                ),
                Text(
                  '${souls_name[name]}의 영혼',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${widget.user.user_inventory[name]} 개',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      inventory[''] = Container();
    }
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
                        '정화된 자의 영혼은 변환할 수 없습니다.',
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
                'asset/image/info_back.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment(-0.93, -0.5),
                child: Container(
                  width: 50,
                  height: 100,
                  child: GridView.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 2,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              Name = '';
                              page = 1;
                            });
                          },
                          child: Image.asset('asset/image/souls_button.png',
                              fit: BoxFit.fill)),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Name = '';
                            page = 2;
                          });
                        },
                        child: Image.asset(
                          'asset/image/bag_button.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (page == 1)
                Align(
                  alignment: Alignment(-0.70, 0.2),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'asset/image/info_choise.png',
                              ),
                              fit: BoxFit.fitHeight)),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: Characters.values.toList(),
                        ),
                      )),
                ),
              if (page == 1)
                if (Name != '')
                  Align(
                    alignment: Alignment(0.75, 0),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height * 0.95,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('asset/image/level_back.png'),
                                fit: BoxFit.fitWidth)),
                        child: Column(
                          children: [
                            Image.asset(
                              'asset/image/monster/${Name}_P.png',
                              width: MediaQuery.of(context).size.width / 3.5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3.1,
                              height: MediaQuery.of(context).size.height * 0.32,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'asset/image/souls_info.png'),
                                      fit: BoxFit.fitWidth)),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${souls_name[Name]}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          decoration: TextDecoration.none),
                                    ),
                                    Text(
                                      '레벨 : ${widget.user.user_souls['${Name}']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          decoration: TextDecoration.none),
                                    ),
                                    Text(
                                      '레벨 업에 필요한 영혼 : ${max_exp}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                          decoration: TextDecoration.none),
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 8,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8.5,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.user.user_inventory
                                              .containsKey(Name)) {
                                            if (widget.user .user_inventory[Name]! >(5 +(widget.user.user_souls['${Name}']! -1) * 4) &&
                                                widget.user.user_souls['$Name']! <10) {
                                              setState(() {
                                                widget.user.user_inventory['$Name'] =
                                                    (widget.user.user_inventory['$Name'] ??0) -(5 +(widget.user.user_souls['${Name}']! -1) *4);
                                                widget.user.user_souls['${Name}'] =(widget.user.user_souls['${Name}'] ??0) +1;
                                                if (widget.user .user_souls[Name]! <10) { max_exp = (5 +(widget.user.user_souls[Name]! -1) *4);
                                                } else {
                                                  max_exp = '최대 레벨에 도달했습니다.';
                                                }
                                                if (widget.user.user_inventory[Name] == 0) {
                                                  widget.user.user_inventory.remove(Name);
                                                }
                                                messege_success = true;
                                                showWidget();
                                                Timer(Duration(seconds: 1), () {
                                                  setState(() {
                                                    messege_success = false;
                                                  });
                                                });
                                                setState(() async {
                                                  await saveData
                                                      .save_data(widget.user);
                                                });
                                              });
                                            } else {
                                              setState(() {
                                                messege_false = true;
                                                Timer(Duration(seconds: 1), () {
                                                  setState(() {
                                                    messege_false = false;
                                                  });
                                                });
                                              });
                                            }
                                          } else {
                                            setState(() {
                                              messege_false = true;
                                              Timer(Duration(seconds: 1), () {
                                                setState(() {
                                                  messege_false = false;
                                                });
                                              });
                                            });
                                          }
                                        },
                                        child: Image.asset(
                                          'asset/image/level_up_button.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        messege_false
                                            ? Text(
                                                '성장에 필요한 영혼이 부족합니다.',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10),
                                              )
                                            : Text(''),
                                        messege_success
                                            ? Text(
                                                level_string,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 10),
                                              )
                                            : Text(''),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
              if (page == 2)
                Align(
                  alignment: Alignment(-0.70, 0.2),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'asset/image/info_choise.png',
                              ),
                              fit: BoxFit.fitHeight)),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: inventory.values.toList(),
                          ),
                        ),
                      )),
                ),
              if (page == 2)
                if (Name != '')
                  Align(
                    alignment: Alignment(1, 0.5),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.53,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('asset/image/item_info.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 12,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Image.asset(
                                  'asset/image/item_${Name}.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 80,
                                color: Colors.blue,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 12,
                                height: MediaQuery.of(context).size.height / 4,
                                child: Image.asset('asset/image/item_nomal.png',
                                    fit: BoxFit.fill),
                              ),
                            ],
                          ),
                          // SizedBox(height: 20,),

                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (item_amount <= 0) {
                                        item_amount -= 0;
                                      } else {
                                        item_amount -= 1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    color: Colors.blue,
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${item_amount} 번',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      decoration: TextDecoration.none),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (item_amount >=
                                          widget.user.user_inventory[Name]! ~/
                                              10) {
                                        item_amount += 0;
                                      } else {
                                        item_amount += 1;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                    height:
                                        MediaQuery.of(context).size.height / 10,
                                    color: Colors.blue,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      item_amount =
                                          widget.user.user_inventory[Name]! ~/
                                              10;
                                    });
                                  },
                                  child:
                                      Image.asset('asset/image/max_button.png'),
                                )
                              ],
                            ),
                          ),
                          Text(
                            '(몬스터의 영혼 10개로 정화된 자의 영혼 8를 교환할 수 있습니다.)',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.height / 6,
                            child: GestureDetector(
                              onTap: () {
                                if (Name == 'nomal') {
                                  invalid_widget();
                                } else if (item_amount == 0) {
                                } else if (Name != 'nomal' &&
                                    item_amount <=
                                        widget.user.user_inventory[Name]! ~/
                                            10) {
                                  setState(() {
                                    widget.user.user_inventory[Name] =
                                        (widget.user.user_inventory[Name] ??
                                                0) -
                                            item_amount * 10;
                                    widget.user.user_inventory['nomal'] =
                                        (widget.user.user_inventory['nomal'] ??
                                                0) +
                                            item_amount * 8;
                                    if (widget.user.user_inventory[Name] == 0) {
                                      widget.user.user_inventory.remove(Name);
                                      inventory.remove(Name);
                                    }
                                    inventory.clear();
                                    showWidget();
                                  });
                                  success_bool = true;
                                  Timer(Duration(seconds: 1), () {
                                    setState(() {
                                      success_bool = false;
                                    });
                                  });
                                  setState(() async {
                                    await saveData.save_data(widget.user);
                                  });
                                }
                              },
                              child:
                                  Image.asset('asset/image/trade_button.png'),
                            ),
                          ),
                          Text(
                            success_bool ? success_string : '',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                                decoration: TextDecoration.none),
                          )
                        ],
                      ),
                    ),
                  ),
              Align(
                alignment: Alignment(1, -1),
                child: GestureDetector(
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
              ),
            ],
          ));
  }
}
