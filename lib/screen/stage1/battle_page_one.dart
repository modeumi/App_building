import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tamer/model/user_information.dart';
import 'package:tamer/screen/monster_status.dart';
import 'package:tamer/screen/user_status.dart';

class one_one_battle extends StatefulWidget {
  final user_information user_info;
  final List<String> skill_list;

  one_one_battle(this.user_info, this.skill_list);

  One_one_battle createState() => One_one_battle(1, 1);
}

class One_one_battle extends State<one_one_battle> {
  late Timer timer;
  bool load = true;
  bool click_medi = true;
  OverlayEntry? skillpage;
  OverlayEntry? emptyMp;
  OverlayEntry? victory;
  OverlayEntry? defeat;
  late User user;
  late Slime slime;
  late int userhp;
  late int userhpMax;
  late int usermp;
  late int usermpMax;
  late int monsterhp;
  late int monsterhpMax;
  late int user_lavel;
  Map<String, bool> skill_state = {};

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

  One_one_battle(int userlevel, int monsterlevel) {
    user = User(userlevel);
    slime = Slime(monsterlevel);
    userhp = user.Hp;
    userhpMax = user.HpMax;
    usermp = user.Mp;
    usermpMax = user.MpMax;
    monsterhp = slime.Hp;
    monsterhpMax = slime.HpMax;
    user_lavel = userlevel;
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.skill_list.length; i++) {
      if (widget.skill_list[i] != 'none') {
        skill_state['skill_${i + 1}'] = true;
      } else {
        skill_state['skill_${i + 1}'] = false;
      }
    }
    timer = Timer(Duration(seconds: 3), () {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'asset/image/battle_back.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment(1, -1),
          child: Image.asset(
            'asset/image/monster/slime_P.png',
            width: MediaQuery.of(context).size.width / 3,
          ),
        ),
        Align(
          alignment: Alignment(-1, 1),
          child: Image.asset(
            'asset/image/back_character.png',
            width: MediaQuery.of(context).size.width / 2.5,
          ),
        ),
        Align(
          alignment: Alignment(0.65, 1),
          child: GestureDetector(
              onTap: () {
                if(click_medi) {
                  fight().meditation(this.user, this.slime);
                  setState(() {
                    this.usermp = user.Mp;
                    this.userhp = user.Hp;
                    this.monsterhp = slime.Hp;
                  });
                }
              },
              child: Image.asset(
                'asset/image/meditation.png',
                width: MediaQuery.of(context).size.width / 7,
              )),
        ),
        Align(
          alignment: Alignment(1, 1),
          child: GestureDetector(
              onTap: () {
                Skillpage(context, user, slime);
                setState(() {
                  click_medi = false;
                });
              },
              child: Image.asset(
                'asset/image/skill.png',
                width: MediaQuery.of(context).size.width / 7,
              )),
        ),
        Align(
          alignment: Alignment(0, 0.9),
          child: Container(
            padding: EdgeInsets.only(top: 5, left: 18),
            width: MediaQuery.of(context).size.width / 2.75,
            height: MediaQuery.of(context).size.height / 4.5,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('asset/image/state_panel2.png'),
                    fit: BoxFit.fill)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.user_info.user_name}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Hp ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    // 유저 체력칸
                    Stack(
                      children: [
                        Container(
                          width: 180,
                          height: 22,
                          color: Colors.black,
                        ),
                        Container(
                          width: 180 * (this.userhp / this.userhpMax),
                          height: 22,
                          color: Colors.red,
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Mp ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    // 유저 마나 칸
                    Stack(
                      children: [
                        Container(
                          width: 180,
                          height: 22,
                          color: Colors.black,
                        ),
                        Container(
                          width: 180 * (this.usermp / this.usermpMax),
                          height: 22,
                          color: Colors.blue,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),

        // 몬스터 정보 창
        Align(
            alignment: Alignment(0, -1),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, left: 18),
                  width: MediaQuery.of(context).size.width / 2.75,
                  height: MediaQuery.of(context).size.height / 5.5,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/image/state_panel3.png'),
                          fit: BoxFit.fill)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '슬라임',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Hp ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          // 몬스터  체력칸

                          Stack(
                            children: [
                              Container(
                                width: 180,
                                height: 25,
                                color: Colors.black,
                              ),
                              Container(
                                width:
                                    180 * (this.monsterhp / this.monsterhpMax),
                                height: 25,
                                color: Colors.red,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  void Skillpage(BuildContext maincontext, User user, Slime slime) {
    skillpage = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment(1, 1),
        child: Container(
          padding: EdgeInsets.only(top: 10,left: 10,right: 10),
          width: MediaQuery.of(context).size.width / 4,
          height: MediaQuery.of(context).size.height / 2,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('asset/image/skill_page.png'),
            fit: BoxFit.fill,
          )),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  skill_state['skill_1']!
                      ? GestureDetector(
                          onTap: () {
                            skillpage?.remove();
                            fight battle = fight();
                            battle.Battle(
                                user, slime, widget.skill_list[0], user_lavel);
                            if (battle.check == false) {
                              EmptyMp(maincontext);
                            }
                            setState(() {
                              click_medi = true;
                              this.userhp = user.Hp;
                              this.usermp = user.Mp;
                              this.monsterhp = slime.Hp;
                              if (this.userhp <= 0) {
                                this.userhp = 0;
                              } else if (this.monsterhp <= 0) {
                                this.monsterhp = 0;
                              } else if (this.usermp <= 0) {
                                this.usermp = 0;
                              }
                            });
                            if (user.Hp <= 0) {
                              Defeat(maincontext);
                            } else if (slime.Hp <= 0) {
                              Victory(maincontext);
                            }
                          },
                          child: Text(
                            '${souls_name[widget.skill_list[0]]}',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  skill_state['skill_2']!
                      ? GestureDetector(
                          onTap: () {
                            skillpage?.remove();
                            fight battle = fight();
                            battle.Battle(
                                user, slime, widget.skill_list[1], user_lavel);
                            if (battle.check == false) {
                              EmptyMp(maincontext);
                            }
                            setState(() {
                              click_medi = true;
                              this.userhp = user.Hp;
                              this.usermp = user.Mp;
                              this.monsterhp = slime.Hp;
                              if (this.userhp <= 0) {
                                this.userhp = 0;
                              } else if (this.monsterhp <= 0) {
                                this.monsterhp = 0;
                              } else if (this.usermp <= 0) {
                                this.usermp = 0;
                              }
                            });
                            if (user.Hp <= 0) {
                              Defeat(maincontext);
                            } else if (slime.Hp <= 0) {
                              Victory(maincontext);
                            }
                          },
                          child: Text(
                            '${souls_name[widget.skill_list[1]]}',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : SizedBox(
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  skill_state['skill_3']!
                      ? GestureDetector(
                          onTap: () {
                            skillpage?.remove();
                            fight battle = fight();
                            battle.Battle(
                                user, slime, widget.skill_list[2], user_lavel);
                            if (battle.check == false) {
                              EmptyMp(maincontext);
                            }
                            setState(() {
                              click_medi = true;
                              this.userhp = user.Hp;
                              this.usermp = user.Mp;
                              this.monsterhp = slime.Hp;
                              if (this.userhp <= 0) {
                                this.userhp = 0;
                              } else if (this.monsterhp <= 0) {
                                this.monsterhp = 0;
                              } else if (this.usermp <= 0) {
                                this.usermp = 0;
                              }
                            });
                            if (user.Hp <= 0) {
                              Defeat(maincontext);
                            } else if (slime.Hp <= 0) {
                              Victory(maincontext);
                            }
                          },
                          child: Text(
                            '${souls_name[widget.skill_list[2]]}',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      : SizedBox(
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          skillpage?.remove();
                        },
                        child: Image.asset(
                          'asset/image/back_button1.png',
                          width: MediaQuery.of(context).size.height/10,
                        ),
                      ),
                    ]
                  )
                ],
              ),

         ),
        ),
    );
    Overlay.of(context).insert(skillpage!);
  }

  void EmptyMp(BuildContext context) {
    emptyMp = OverlayEntry(
      builder: (context) => Positioned(
        top: 150,
        left: 330,
        child: Stack(
          children: [
            Image.asset(
              'asset/image/state_panel.png',
              width: 200,
            ),
            Positioned(
              top: 22,
              left: 35,
              child: Text(
                '마나가 부족함',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
    Overlay.of(context).insert(emptyMp!);
    Timer(Duration(seconds: 1), () {
      emptyMp?.remove();
    });
  }

  void Victory(BuildContext context) {
    victory = OverlayEntry(
      builder: (context) => Positioned(
        top: 150,
        left: 330,
        child: Stack(
          children: [
            Image.asset(
              'asset/image/state_panel.png',
              width: 200,
            ),
            Positioned(
              top: 22,
              left: 35,
              child: Text(
                '승리!',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
    Overlay.of(context).insert(victory!);
    Timer(Duration(seconds: 3), () {
      victory?.remove();
      Navigator.pop(context, 2);
    });
  }

  void Defeat(BuildContext context) {
    defeat = OverlayEntry(
      builder: (context) => Positioned(
        top: 150,
        left: 330,
        child: Stack(
          children: [
            Image.asset(
              'asset/image/state_panel.png',
              width: 200,
            ),
            Positioned(
              top: 22,
              left: 35,
              child: Text(
                '패배!',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
    Overlay.of(context).insert(defeat!);
    Timer(Duration(seconds: 3), () {
      defeat?.remove();
      Navigator.of(context).pop();
    });
  }
}

class fight {
  late bool check;

  fight() {
    check = true;
  }

// 배틀의 순서는 유저 공격 , 몬스터 공격 , 유저 대미지 처리(몬스터 사망확인) , 몬스터 데미지 처리(유저 사망확인)
  void Battle(User user, Slime slime, String soul, int level) {
    user.attack_process(soul, level);
    // attack_process을 호출해서 Mp_leftover가 Mp에 따라 Empty가 되거나 '' 가됨
    if (user.Mp_leftover != 'Empty') {
      slime.damage_process(user.attack_info);
      while (true) {
        // 몬스터 사망시 종료
        if (slime.survival == 'death') {
          break;
        } else {
          Monster_Attack(user, slime);
          user.status_process(slime.attack_info);
          slime.status_process(user.attack_info);
          // 유저 사망시 종료
          if (user.survival == 'death') {
            break;
          }
          break;
        }
        // slime
      }
      // Mp_leftover가 Empty일 경우
    } else {
      this.check = false;
    }
  }

  void Monster_Attack(User user, Slime slime) {
    slime.attack_process();
    user.damage_process(slime.attack_info);
  }

  void meditation(User user, Slime slime) {
    user.meditation();
    Monster_Attack(user, slime);
    user.status_process(slime.attack_info);
    slime.status_process(user.attack_info);
  }
}
