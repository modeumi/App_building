import 'dart:async';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:flutter/material.dart';

class join_screen extends StatefulWidget {
  Join_Screen createState() => Join_Screen();
}

class Join_Screen extends State<join_screen> {
  String email = '';
  String pass = '';
  String nickname = '';
  String birth = '';
  String gender = '';
  Map<String, bool> join_state = {};
  String messege = '';
  String id_message = '';
  Controls controls = Controls();
  bool join = false;
  late bool certification;
  TextEditingController pass_check = TextEditingController();
  OverlayEntry? success;

  Future<void> Success() async {
    success = OverlayEntry(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 2)),
            child: Center(
                child: Text(
              '회원가입이 완되었습니다. \n감사합니다',
              style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none, fontFamily: 'DnF'),
              textAlign: TextAlign.center,
            )),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(success!);
    Timer(Duration(seconds: 1), () {
      success!.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: Align(
                alignment: Alignment(0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5), // 색상
                        spreadRadius: 5, // 음영 범위
                        blurRadius: 7, // 블러 범위
                        offset: Offset(0, 3), // 음영 위치
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.height / 5,
                          child: Image.asset('asset/image/logo_join.png'),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 30,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  '아이디',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: SingleChildScrollView(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        join_state.remove('email_check');
                                        id_message = '';
                                        if (!value.contains('@') || !value.contains('.')) {
                                          join_state['email'] = false;
                                          id_message = '이메일의 형식이 올바르지 않습니다.';
                                        } else {
                                          email = value;
                                          join_state['email'] = true;
                                          id_message = '';
                                        }
                                      });
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(hintText: 'example@email.com', border: OutlineInputBorder(), counterText: ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () async {
                                id_message = '';
                                if (join_state.containsKey('email') && join_state['email']!) {
                                  bool dup_check = await controls.Duplication_Email(email);
                                  setState(() {
                                    if (dup_check) {
                                      join_state['email_check'] = true;
                                      id_message = '사용 가능한 이메일 입니다.';
                                    } else {
                                      id_message = '이미 존재하는 아이디 입니다.';
                                      join_state['email_check'] = false;
                                    }
                                  });
                                }
                              },
                              child: Text('중복확인'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (join_state.containsKey('email'))
                              if (!join_state['email']!)
                                Text(
                                  id_message,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                            if (join_state.containsKey('email_check'))
                              if (!join_state['email_check']!)
                                Text(
                                  id_message,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                            if (join_state.containsKey('email_check'))
                              if (join_state['email_check']!)
                                Text(
                                  id_message,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                  ),
                                )
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  '비밀번호',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      pass_check.text = '';
                                      join_state.remove('pass_check');
                                    });
                                    if (text.length <= 8 || !RegExp(r'[!@#_A-Za-z]').hasMatch(text) || RegExp(r'[ㄱ-ㅎ가-힣]').hasMatch(text)) {
                                      setState(() {
                                        join_state['pass'] = false;
                                      });
                                    } else {
                                      setState(() {
                                        pass = text;
                                        join_state['pass'] = true;
                                      });
                                    }
                                  },
                                  obscureText: true,
                                  maxLines: 1,
                                  maxLength: 20,
                                  decoration: InputDecoration(hintText: '최대 20자', border: OutlineInputBorder(), counterText: ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (join_state.containsKey('pass'))
                              Text(
                                join_state['pass']! ? '' : '비밀번호는 8자 이상 이며 영문과\n!,@,#,_ 중 하나 이상을 포함해야 합니다.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  '비밀번호 확인',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  controller: pass_check,
                                  onChanged: (text) {
                                    setState(() {
                                      if (text != pass) {
                                        join_state['pass_check'] = false;
                                      } else {
                                        join_state['pass_check'] = true;
                                      }
                                    });
                                  },
                                  obscureText: true,
                                  maxLines: 1,
                                  maxLength: 20,
                                  decoration: InputDecoration(hintText: '최대 20자', border: OutlineInputBorder(), counterText: ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (join_state.containsKey('pass_check'))
                              Text(
                                join_state['pass_check']! ? '' : '비밀번호가 일치하지 않습니다.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  '닉네임',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  maxLines: 1,
                                  maxLength: 8,
                                  onChanged: (text) {
                                    setState(() {
                                      if (text.length < 2) {
                                        join_state['nickname'] = false;
                                      } else {
                                        nickname = text;
                                        join_state['nickname'] = true;
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(hintText: '2자 이상, 최대 8자', border: OutlineInputBorder(), counterText: ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (join_state.containsKey('nickname'))
                              Text(
                                join_state['nickname']! ? '' : '올바른 닉네임을 입력해주세요.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Text(
                                  '성별',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 10,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 15,
                                child: Row(
                                  children: [
                                    Text(
                                      '남성',
                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                    ),
                                    Radio(
                                        value: '남성',
                                        groupValue: gender,
                                        onChanged: (value) {
                                          print('아이디 확인 : $email \n비밀번호 확인 : $pass');
                                          setState(() {
                                            gender = value!;
                                            join_state['gender'] = true;
                                          });
                                        })
                                  ],
                                ),
                              ),
                              Container(
                                  height: MediaQuery.of(context).size.height / 15,
                                  child: Row(
                                    children: [
                                      Text(
                                        '여성',
                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                      ),
                                      Radio(
                                          value: '여성',
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value!;
                                              join_state['gender'] = true;
                                            });
                                          }),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Text(
                                  '생년월일',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  onChanged: (text) {
                                    int? year = int.tryParse(text.substring(0, 4));
                                    int? month = int.tryParse(text.substring(4, 6));
                                    int? day = int.tryParse(text.substring(6, 8));
                                    setState(() {
                                      if (text.length == 8 &&
                                          (year! >= 1900 && year <= 2100) &&
                                          (month! >= 1 && month <= 12) &&
                                          (day! >= 1 && day <= 31)) {
                                        join_state['birth'] = true;
                                        birth = text;
                                      } else {
                                        join_state['birth'] = false;
                                      }
                                    });
                                  },
                                  maxLines: 1,
                                  maxLength: 8,
                                  decoration: InputDecoration(hintText: 'YYYYMMDD', border: OutlineInputBorder(), counterText: ''),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (join_state.containsKey('birth'))
                              Text(
                                join_state['birth']! ? '' : '생년월일의 형식이 올바르지 않습니다.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              join ? '' : messege,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    String state = controls.Join_Us(join_state);
                                    if (state == 'success') {
                                      await controls.Join(email, pass, nickname, gender, birth);
                                      await Success();
                                      Navigator.of(context).pop();
                                    } else {
                                      setState(() {
                                        if (state == 'email') {
                                          messege = '올바른 이메일을 입력해주세요.';
                                        } else if (state == 'pass') {
                                          messege = '비밀번호 형식이 올바르지 않습니다';
                                        } else if (state == 'pass_check') {
                                          messege = '비밀번호 확인이 일치하지 않습니다.';
                                        } else if (state == 'nickname') {
                                          messege = '올바른 닉네임을 입력해주세요.';
                                        } else if (state == 'gender') {
                                          messege = '성별을 체크해 주세요.';
                                        } else if (state == 'birth') {
                                          messege = '올바른 생년월일을 입력해주세요.';
                                        } else if (state == 'email_check') {
                                          messege = '이메일 중복확인을 실행해주세요';
                                        }
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                  child: Text('회원 가입')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소'))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
