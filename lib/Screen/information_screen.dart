import 'dart:async';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Data/user_data.dart';
import 'package:eat_today/Screen/login_screen.dart';
import 'package:eat_today/Screen/main_screen.dart';
import 'package:flutter/material.dart';

class information_screen extends StatefulWidget {
  final UserData userData;

  information_screen(this.userData);

  Information_Screen createState() => Information_Screen();
}

class Information_Screen extends State<information_screen> {
  Color? backcolor;
  Color? buttoncolor;
  Color fontcolor = Colors.white;
  Controls controls = Controls();
  bool check_pass = true;
  int ex = 0;
  OverlayEntry? change_information;
  OverlayEntry? check_password;
  OverlayEntry? success_change;
  OverlayEntry? success_delete;
  OverlayEntry? success_colorch;
  OverlayEntry? delete_message;
  String pass = '';
  bool check_box = false;
  late int back_color;
  late int button_color;
  TextEditingController? insert_pass = TextEditingController();
  TextEditingController? pass_check = TextEditingController();

  Map<String, Widget> back_colors = {};
  List<OverlayEntry> overlays = [];
  Map<String, bool> back_select_slot = {};
  Map<String, Color> back_colorlist = {
    'blue': Colors.blue,
    'red': Colors.redAccent,
    'black': Colors.black,
    'white': Colors.white,
    'pink': Color(0xFFFFB2F5),
    'orange': Color(0xFFFFE08C),
    'green': Color(0xFFABF200),
    'purple': Colors.purpleAccent
  };

  Map<String, Widget> button_colors = {};
  Map<String, bool> button_select_slot = {};
  Map<String, Color> button_colorlist = {
    'blue': Colors.indigo,
    'red': Color(0xFFFF0000),
    'black': Colors.black,
    'white': Colors.white,
    'pink': Color(0xFFFF00DD),
    'orange': Color(0xFFFFBB00),
    'green': Color(0xFF1DDB16),
    'purple': Colors.purple
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      back_color = widget.userData.backcolor;
      button_color = widget.userData.buttoncolor;
      if (button_color == 4) {
        fontcolor = Colors.black;
      }
      backcolor = back_colorlist[back_colorlist.keys.toList()[widget.userData.backcolor - 1]];
      buttoncolor = button_colorlist[button_colorlist.keys.toList()[widget.userData.buttoncolor - 1]];
    });
    for (int i = 1; i <= back_colorlist.length; i++) {
      back_select_slot['select_$i'] = false;
      if (widget.userData.backcolor == i) {
        back_select_slot['select_$i'] = true;
      }
    }
    for (int i = 1; i <= button_colorlist.length; i++) {
      button_select_slot['select_$i'] = false;
      if (widget.userData.buttoncolor == i) {
        button_select_slot['select_$i'] = true;
      }
    }
  }

  void Color_widget(BuildContext context) {
    for (int i = 1; i <= button_colorlist.length; i++) {
      button_colors['color_$i'] = GestureDetector(
          onTap: () {
            setState(() {
              button_color = i;
              for (int j = 1; j <= button_select_slot.length; j++) {
                button_select_slot['select_$j'] = false;
              }
              button_select_slot['select_$i'] = !button_select_slot['select_$i']!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: button_colorlist[button_colorlist.keys.toList()[i - 1]]!,
              border:
                  Border.all(color: button_select_slot['select_$i']! ? Colors.yellow : Colors.grey, width: button_select_slot['select_$i']! ? 4 : 0),
            ),
            width: MediaQuery.of(context).size.width * 0.2,
          ));
    }

    for (int i = 1; i <= back_colorlist.length; i++) {
      back_colors['color_$i'] = GestureDetector(
          onTap: () {
            print('몇번째 배경 눌럿냐 $i');
            setState(() {
              back_color = i;
              for (int j = 1; j <= back_select_slot.length; j++) {
                back_select_slot['select_$j'] = false;
              }
              back_select_slot['select_$i'] = !back_select_slot['select_$i']!;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: back_colorlist[back_colorlist.keys.toList()[i - 1]]!,
                border:
                    Border.all(color: back_select_slot['select_$i']! ? Colors.yellow : Colors.grey, width: back_select_slot['select_$i']! ? 4 : 0)),
            width: MediaQuery.of(context).size.width * 0.2,
          ));
    }
  }

  void Delete_Message(String uid) {
    delete_message = OverlayEntry(
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(border: Border.all(color: buttoncolor!, width: 2), color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '정말 회원 탈퇴를\n진행하시겠습니까?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'DnF', fontSize: 20, fontWeight: FontWeight.w200, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      Text(
                        '작성하신 리뷰와 사진 등의 정보가 모두 삭제됩니다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'DnF', fontSize: 10, fontWeight: FontWeight.w200, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: buttoncolor!),
                              onPressed: () async {
                                await controls.Delete_User(uid);
                                Success_Delete(context);
                                delete_message!.remove();
                                overlays.remove(delete_message!);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => main_screen()));
                              },
                              child: Center(
                                child: Text('삭제'),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: buttoncolor!),
                              onPressed: () async {
                                delete_message!.remove();
                                overlays.remove(delete_message!);
                              },
                              child: Center(
                                child: Text('취소'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
    Overlay.of(context).insert(delete_message!);
  }

  Future<void> Success_Change(BuildContext context) async {
    success_change = OverlayEntry(
        builder: (context) => Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // 색상
                      spreadRadius: 5, // 음영 범위
                      blurRadius: 7, // 블러 범위
                      offset: Offset(0, 3), // 음영 위치
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    '정보가 변경되었습니다 \n다시 로그인 해주세요.',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'DnF',
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ));
    overlays.add(success_change!);
    Overlay.of(context).insert(success_change!);
    Timer(Duration(milliseconds: 1500), () {
      success_change!.remove();
    });
  }

  Future<void> Success_Delete(BuildContext context) async {
    success_delete = OverlayEntry(
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // 색상
                        spreadRadius: 5, // 음영 범위
                        blurRadius: 7, // 블러 범위
                        offset: Offset(0, 3), // 음영 위치
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '회원 탈퇴가 완료되었습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'DnF',
                          decoration: TextDecoration.none,
                          fontSize: 25,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Text(
                        '이용해 주셔서감사합니다.\n다음 방문을 기다리겠습니다',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'DnF',
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
    Overlay.of(context).insert(success_delete!);
    Timer(Duration(milliseconds: 1500), () {
      success_delete!.remove();
    });
  }

  void Success_Colorch(BuildContext context) {
    success_colorch = OverlayEntry(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // 색상
                  spreadRadius: 5, // 음영 범위
                  blurRadius: 7, // 블러 범위
                  offset: Offset(0, 3), // 음영 위치
                )
              ],
            ),
            child: Center(
              child: Text(
                '색상이 변경되었습니다.\n변경사항은 다음 앱 실행부터 적용됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'DnF',
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(success_colorch!);
    Future.delayed(Duration(seconds: 2), () {
      success_colorch!.remove();
    });
  }

  void Change_Information(BuildContext context, String oldpass) {
    String password = '';
    String nickname = '';
    Map<String, bool> right_info = {};
    change_information = OverlayEntry(
      builder: (context) => StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.5),
          child: Scaffold(
            backgroundColor: Colors.white.withOpacity(0),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // 색상
                      spreadRadius: 5, // 음영 범위
                      blurRadius: 7, // 블러 범위
                      offset: Offset(0, 3), // 음영 위치
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '정보 변경',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 3)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '비밀번호 변경하지 않음',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          Checkbox(
                              value: check_box,
                              onChanged: (value) {
                                setState(() {
                                  check_box = value!;
                                  if (check_box) {
                                    password = oldpass;
                                    insert_pass?.text = '';
                                    pass_check?.text = '';
                                    right_info['pass'] = true;
                                    right_info['pass_check'] = true;
                                  } else {
                                    password = '';
                                    right_info.remove('pass');
                                    right_info.remove('pass_check');
                                  }
                                });
                              }),
                        ],
                      ),
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      check_box
                          ? TextField(
                              controller: insert_pass,
                              enabled: false,
                              decoration: InputDecoration(fillColor: Colors.grey, filled: true),
                            )
                          : TextField(
                              controller: insert_pass,
                              obscureText: true,
                              maxLines: 1,
                              maxLength: 20,
                              decoration: InputDecoration(
                                hintText: '8자 이상 특수문자 (!@#_ 중 1개 이상) 포함',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  right_info.remove('pass_check');
                                  pass_check?.text = '';
                                  if (value.length <= 8 || !RegExp(r'[!@#_A-Za-z]').hasMatch(value) || RegExp(r'[ㄱ-ㅎ가-힣]').hasMatch(value)) {
                                    right_info['pass'] = false;
                                  } else {
                                    password = value;
                                    right_info['pass'] = true;
                                  }
                                  password = value;
                                });
                              },
                            ),
                      Container(
                        height: MediaQuery.of(context).size.height / 20,
                        child: Text(
                          (right_info['pass'] ?? true) ? '' : '비밀번호는 영문 대소문자 8자 이상 이며 \n!,@,#,_ 중 하나 이상을 포함해야 합니다.',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        '비밀번호 확인',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      check_box
                          ? TextField(
                              enabled: false,
                              controller: pass_check,
                              decoration: InputDecoration(fillColor: Colors.grey, filled: true),
                            )
                          : TextField(
                              controller: pass_check,
                              obscureText: true,
                              maxLines: 1,
                              decoration: InputDecoration(hintText: '비밀번호를 한번더 입력해주세요'),
                              onChanged: (text) {
                                setState(() {
                                  if (text == password) {
                                    right_info['pass_check'] = true;
                                  } else {
                                    right_info['pass_check'] = false;
                                  }
                                });
                              },
                            ),
                      Container(
                        height: MediaQuery.of(context).size.height / 20,
                        child: Text(
                          (right_info['pass_check'] ?? true) ? '' : '비밀번호가 일치하지 않습니다',
                          style: TextStyle(color: Colors.red, fontSize: 15, decoration: TextDecoration.none),
                        ),
                      ),
                      Text(
                        '닉네임',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      TextField(
                        maxLines: 1,
                        maxLength: 8,
                        decoration: InputDecoration(hintText: '2자 이상 8자 이하', counterText: ''),
                        onChanged: (text) {
                          setState(() {
                            if (text.length >= 2 && text.length <= 8) {
                              nickname = text;
                              right_info['nickname'] = true;
                            } else {
                              right_info['nickname'] = false;
                            }
                          });
                        },
                      ),
                      if (right_info.containsKey('nickname'))
                        Text(
                          right_info['nickname']! ? '' : '닉네임은 2글자 이상 8글자 이하로 입력해야합니다',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 3)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                            onPressed: () async {
                              bool result = controls.Change_Check(right_info);
                              if (result) {
                                await Success_Change(context);
                                await controls.Change_Information(widget.userData.email!, nickname, password);
                                change_information!.remove();
                                overlays.remove(change_information!);
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => login_screen()));
                              }
                            },
                            child: Text(
                              '변경',
                              style: TextStyle(
                                color: fontcolor,
                              ),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                              onPressed: () {
                                change_information!.remove();
                                overlays.remove(change_information!);
                              },
                              child: Text(
                                '취소',
                                style: TextStyle(
                                  color: fontcolor,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
    overlays.add(change_information!);
    Overlay.of(context).insert(change_information!);
  }

  void Check_Password(BuildContext context, String type) {
    String messege = '';
    String password = '';
    check_password = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // 색상
                      spreadRadius: 5, // 음영 범위
                      blurRadius: 7, // 블러 범위
                      offset: Offset(0, 3), // 음영 위치
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '비밀번호 확인',
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500, fontFamily: 'DnF', decoration: TextDecoration.none),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: TextField(
                        obscureText: true,
                        maxLines: 1,
                        onChanged: (text) {
                          password = text;
                        },
                        decoration: InputDecoration(hintText: '비밀번호 입력', border: OutlineInputBorder(), counterText: ''),
                      ),
                    ),
                    Text(
                      check_pass ? '' : messege,
                      style: TextStyle(color: Colors.red, fontSize: 15, decoration: TextDecoration.none),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttoncolor,
                            ),
                            onPressed: () async {
                              bool result = await controls.Password_Check(widget.userData.email!, password);
                              if (result == true) {
                                check_pass = true;
                                if (type == 'change') {
                                  setState(() {
                                    Change_Information(context, password);
                                  });
                                  check_password!.remove();
                                  overlays.remove(check_password!);
                                  setState(() {
                                    check_pass = true;
                                  });
                                } else if (type == 'delete') {
                                  String uid = await controls.Get_UID();
                                  Delete_Message(uid);
                                  check_password!.remove();
                                  overlays.remove(check_password!);
                                }
                              } else {
                                setState(() {
                                  messege = '비밀번호가 일치하지 않습니다.';
                                  check_pass = false;
                                });
                              }
                            },
                            child: Text(
                              '확인',
                              style: TextStyle(fontSize: 25, color: fontcolor),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                            onPressed: () {
                              setState(() {
                                check_pass = true;
                              });
                              check_password!.remove();
                              overlays.remove(check_password!);
                            },
                            child: Text(
                              '취소',
                              style: TextStyle(fontSize: 25, color: fontcolor),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    overlays.add(check_password!);
    Overlay.of(context).insert(check_password!);
  }

  @override
  Widget build(BuildContext context) {
    Color_widget(context);
    String birth = widget.userData.birth!;
    String birthdate = '${birth.substring(0, 4)}년 ${birth.substring(4, 6)}월 ${birth.substring(6, 8)}일';
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (overlays.length > 0) {
            OverlayEntry overlayEntry = overlays.last;
            overlayEntry.remove();
            overlays.removeLast();
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          color: backcolor,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ],
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.height / 5,
                      child: Image.asset('asset/image/information.png'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: backcolor!, width: 3.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '정보',
                                style: TextStyle(color: Colors.blueGrey, fontSize: 30, decoration: TextDecoration.none),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                                onPressed: () {
                                  Check_Password(context, 'change');
                                },
                                child: Text(
                                  '정보변경',
                                  style: TextStyle(color: fontcolor),
                                ),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: backcolor!, width: 1)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  '닉네임:',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 20, decoration: TextDecoration.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  widget.userData.nickname!,
                                  style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  '이메일:',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 20, decoration: TextDecoration.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  widget.userData.email!,
                                  style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  '생년월일:',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 18, decoration: TextDecoration.none),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  birthdate,
                                  style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(color: backcolor!, width: 2),
                              top: BorderSide(color: backcolor!, width: 2),
                            )),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttoncolor,
                                      ),
                                      onPressed: () {
                                        Check_Password(context, 'delete');
                                      },
                                      child: Container(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          child: Center(
                                            child: Text(
                                              '회원탈퇴',
                                              style: TextStyle(fontSize: 15, color: fontcolor),
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.45,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: backcolor!, width: 3)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '색상 변경',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 30, decoration: TextDecoration.none),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: backcolor!, width: 1)),
                          ),
                          Text(
                            '배경색',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 20, decoration: TextDecoration.none),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0)),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.10,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: back_colors.values.toList(),
                              ),
                            ),
                          ),
                          Text(
                            '버튼색',
                            style: TextStyle(color: Colors.blueGrey, fontSize: 20, decoration: TextDecoration.none),
                          ),
                          Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0)),
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.10,
                            decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: button_colors.values.toList(),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttoncolor,
                              ),
                              onPressed: () async {
                                Success_Colorch(context);
                                await controls.Color_Change(back_color, button_color);
                              },
                              child: Text(
                                '변경하기',
                                style: TextStyle(color: fontcolor),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '뒤로가기',
                        style: TextStyle(color: fontcolor),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: backcolor!,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: buttoncolor),
                      onPressed: () async {
                        await controls.Logout();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => main_screen()));
                      },
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          color: fontcolor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
