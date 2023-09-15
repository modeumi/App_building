import 'dart:async';
import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Data/user_data.dart';
import 'package:eat_today/Screen/admin_screen.dart';
import 'package:eat_today/Screen/loading_screen.dart';
import 'package:eat_today/Screen/login_screen.dart';
import 'package:eat_today/Screen/information_screen.dart';
import 'package:eat_today/Screen/request_screen.dart';
import 'package:eat_today/Screen/select_screen.dart';
import 'package:eat_today/Screen/view_screen.dart';
import 'package:flutter/material.dart';

class main_screen extends StatefulWidget {
  @override
  Main_Screen createState() => Main_Screen();
}

class Main_Screen extends State<main_screen> {
  bool exit = false;
  bool login_state = false;
  Controls controls = Controls();
  late UserData user;
  bool load = false;
  Color? back_color;
  Color? button_color;
  Color? font_color;
  Color? logo_color;
  OverlayEntry? login;
  List<OverlayEntry> overlays = [];

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
    Load_page();
  }

  void Load_page() async {
    dynamic result = await controls.autoLogin();
    setState(() {
      Color_Setting(result);
      load = true;
    });
  }

  void Color_Setting(dynamic result) {
    setState(() {
      if (result != null) {
        user = result;
        back_color = back_colorlist[back_colorlist.keys.toList()[user.backcolor - 1]];
        button_color = button_colorlist[button_colorlist.keys.toList()[user.buttoncolor - 1]];
        if (user.buttoncolor == 4) {
          font_color = Colors.black;
        } else {
          font_color = Colors.white;
        }
        if (user.backcolor == 3) {
          logo_color = Colors.white;
        } else {
          logo_color = Colors.black;
        }
        login_state = true;
      } else {
        logo_color = Colors.white;
        back_color = Colors.blue;
        button_color = Colors.indigo;
        font_color = Colors.white;
      }
    });
  }

  void Login() {
    login = OverlayEntry(
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '로그인이 필요한 서비스입니다.\n로그인 화면으로 이동할까요?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 18, decoration: TextDecoration.none),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: button_color),
                              onPressed: () async {
                                login!.remove();
                                overlays.remove(login!);
                                dynamic result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => login_screen()));
                                if (result.email != null) {
                                  setState(() {
                                    user = result;
                                    login_state = true;
                                    Color_Setting(result);
                                  });
                                }
                              },
                              child: Center(
                                child: Text(
                                  '예',
                                  style: TextStyle(color: font_color),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: button_color),
                                onPressed: () {
                                  login!.remove();
                                  overlays.remove(login!);
                                },
                                child: Center(
                                  child: Text(
                                    '아니요',
                                    style: TextStyle(color: font_color),
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
    overlays.add(login!);
    Overlay.of(context).insert(login!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? WillPopScope(
              onWillPop: () async {
                if (overlays.length != 0) {
                  OverlayEntry overlayEntry = overlays.last;
                  overlayEntry.remove();
                  overlays.remove(overlayEntry);
                  return false;
                } else {
                  if (!exit) {
                    setState(() {
                      exit = true;
                    });
                    Timer(Duration(seconds: 1), () {
                      setState(() {
                        exit = false;
                      });
                    });
                  } else {
                    return true;
                  }
                }
                return false;
              },
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: back_color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 10,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'asset/image/in_icon.png',
                                fit: BoxFit.fitHeight,
                              ),
                              Text(
                                '오늘 뭐 먹지?',
                                style: TextStyle(fontSize: 25.0, color: logo_color),
                              ),
                            ],
                          ),
                          login_state
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: button_color),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => information_screen(user)));
                                  },
                                  child: Text(
                                    '내정보',
                                    style: TextStyle(fontSize: 25, color: font_color),
                                  ))
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: button_color),
                                  onPressed: () async {
                                    dynamic result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => login_screen()));
                                    if (result.email != null) {
                                      setState(() {
                                        user = result;
                                        login_state = true;
                                        Color_Setting(result);
                                      });
                                    }
                                  },
                                  child: Text(
                                    '로그인',
                                    style: TextStyle(fontSize: 25, color: font_color),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    if (login_state)
                      user.level == 'admin'
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: button_color),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => admin_screen(back_color, button_color, font_color)));
                              },
                              child: Text(
                                '관리 페이지',
                                style: TextStyle(color: font_color),
                              ),
                            )
                          : Container(),
                    GestureDetector(
                      onTap: () async {
                        String menu = await controls.Randum_Menu();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => view_screen(back_color, button_color, font_color, menu)));
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'asset/image/main.png',
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          Text(
                            '무작위 메뉴 고르기!',
                            style: TextStyle(color: logo_color, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Text(
                      exit ? '뒤로가기를 한번더 누르면 종료됩니다' : '',
                      style: TextStyle(fontSize: 15, color: logo_color),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 4,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: button_color),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) => select_screen(back_color, button_color, font_color)));
                            },
                            child: Text(
                              '골라보기',
                              style: TextStyle(fontSize: 25, color: font_color),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: button_color),
                              onPressed: () async {
                                bool check = await controls.Check_login();
                                if (check) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => request_screen(back_color, button_color, font_color, user)));
                                } else {
                                  Login();
                                }
                              },
                              child: Icon(
                                Icons.settings,
                                color: font_color,
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : loading_screen(),
    );
  }
}
