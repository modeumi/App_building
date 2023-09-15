import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Screen/join_screen.dart';
import 'package:flutter/material.dart';

class login_screen extends StatefulWidget {
  Login_Screen createState() => Login_Screen();
}

class Login_Screen extends State<login_screen> {
  TextEditingController insert_id = TextEditingController();
  TextEditingController insert_pw = TextEditingController();
  final Controls controls = Controls();
  bool login_state = true;
  bool login_button = true;
  bool auto_login = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.blue,
              child: Align(
                alignment: Alignment(0, 0.3),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      // 음영처리
                      BoxShadow(
                        // 음영처리
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset('asset/image/logo.png'),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 30,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text(
                                    '아이디',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 7,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    child: SingleChildScrollView(
                                      child: TextField(
                                        controller: insert_id,
                                        maxLines: 1,
                                        decoration: InputDecoration(hintText: '아이디 입력!', border: OutlineInputBorder(), counterText: ''),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  child: Text(
                                    '비밀번호',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2.5,
                                  child: TextField(
                                    obscureText: true,
                                    controller: insert_pw,
                                    maxLines: 1,
                                    maxLength: 20,
                                    decoration: InputDecoration(hintText: '비밀번호 입력!', border: OutlineInputBorder(), counterText: ''),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '자동로그인',
                              style: TextStyle(color: Colors.grey, fontSize: 15, decoration: TextDecoration.none),
                            ),
                            Checkbox(
                                value: auto_login,
                                onChanged: (value) {
                                  setState(() {
                                    auto_login = value!;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
                        ),
                        Text(
                          login_state ? '' : '아이디 혹은 비밀번호를 확인해 주세요',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                          onPressed: () async {
                            dynamic results = await controls.Login(insert_id.text, insert_pw.text, auto_login);
                            print('결과 : $results');
                            if (results == false) {
                              setState(() {
                                login_state = false;
                              });
                            } else {
                              Navigator.of(context).pop(results);
                            }
                          },
                          child: Text('로그인'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => join_screen()));
                          },
                          child: Text('회원가입'),
                        ),
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
