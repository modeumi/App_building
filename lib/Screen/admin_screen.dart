import 'dart:async';
import 'dart:io';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Screen/view_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class admin_screen extends StatefulWidget {
  final Color? back_color;
  final Color? button_color;
  final Color? font_color;

  admin_screen(this.back_color, this.button_color, this.font_color);

  Admin_Screen createState() => Admin_Screen();
}

class Admin_Screen extends State<admin_screen> with WidgetsBindingObserver {
  int button_num = 0;
  List<Widget> review = [];
  List<Widget> question = [];
  List<Widget> member = [];
  Map<String, Widget> menus = {};
  Map<String, Widget> members = {};
  Map<String, Widget> reviews = {};
  Map<String, Widget> filter_review = {};
  Map<String, Widget> inquires = {};
  Map<String, Widget> filter_inquires = {};
  Map<String, Widget> menu_request = {};
  Map<String, Widget> filter_request = {};
  Controls controls = Controls();
  Map<String, bool> menu_check = {};
  Map<String, dynamic> add_menu = {};
  Map<String, dynamic> all_review = {};
  Map<String, dynamic> all_inquiry = {};
  Map<String, dynamic> all_request = {};
  List<OverlayEntry> overlays = [];
  TextEditingController filter = TextEditingController();
  TextEditingController t_filter_inquiry = TextEditingController();
  TextEditingController t_filter_request = TextEditingController();
  TextEditingController user_nickname = TextEditingController();
  TextEditingController answer_text = TextEditingController();
  TextEditingController? menu_name;
  TextEditingController? menu_category;
  TextEditingController? menu_eattype;
  TextEditingController? menu_eattime;
  TextEditingController? menu_comment;
  OverlayEntry? success;
  OverlayEntry? message;
  OverlayEntry? image_viewer;
  OverlayEntry? user_information;
  OverlayEntry? insert_answer;
  bool request_add = false;
  double containerHeight = 0;
  final ImagePicker imagePicker = ImagePicker();
  File? image_select;
  String image_downlods = '';
  String select_value = '';
  String nickname = '';
  String level = '';
  String answer = '';

  @override
  void initState() {
    super.initState();
    menu_name = TextEditingController();
    menu_category = TextEditingController();
    menu_eattype = TextEditingController();
    menu_eattime = TextEditingController();
    menu_comment = TextEditingController();
  }

  void User_Information(String uid, Map<String, dynamic> user) {
    setState(() {
      level = user['level'];
      user_nickname.text = user['nickname'];
    });
    user_information = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0),
                body: Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                        color: Colors.white, border: Border.all(color: widget.button_color!, width: 2), borderRadius: BorderRadius.circular(5)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: widget.button_color!, width: 3))),
                            child: Text(
                              '정보 변경',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: widget.button_color!, width: 2))),
                                child: Text(
                                  '닉네임',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                              ),
                              TextField(
                                controller: user_nickname,
                                onChanged: (text) {
                                  setState(() {
                                    nickname = text;
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: widget.button_color!, width: 2))),
                            child: Text(
                              '등급',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ),
                          Column(
                            children: [
                              RadioListTile(
                                  title: Text('member'),
                                  value: 'member',
                                  groupValue: level,
                                  onChanged: (value) {
                                    setState(() {
                                      level = value.toString();
                                    });
                                  }),
                              RadioListTile(
                                title: Text('admin'),
                                value: 'admin',
                                groupValue: level,
                                onChanged: (value) {
                                  setState(() {
                                    level = value.toString();
                                  });
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.1,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border(top: BorderSide(color: widget.button_color!, width: 2))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () async {
                                      bool result = await controls.Admin_Change_Information(uid, nickname, level);
                                      Success(result);
                                      Members(context);
                                      user_information!.remove();
                                      overlays.remove(user_information!);
                                    },
                                    child: Text(
                                      '변경',
                                      style: TextStyle(color: widget.font_color, fontSize: 15),
                                    )),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () {
                                      user_information!.remove();
                                      overlays.remove(user_information!);
                                    },
                                    child: Text(
                                      '취소',
                                      style: TextStyle(color: widget.font_color, fontSize: 15),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    overlays.add(user_information!);
    Overlay.of(context).insert(user_information!);
  }

  void Image_Viewer(String url) {
    image_viewer = OverlayEntry(
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
              child: Center(
                child: GestureDetector(
                    onTap: () {
                      image_viewer!.remove();
                      overlays.remove(image_viewer!);
                    },
                    child: url != ''
                        ? Image.network(
                            url,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(color: Colors.white),
                            child: Center(
                              child: Text(
                                'No Image',
                                style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),
                              ),
                            ),
                          )),
              ),
            ));
    overlays.add(image_viewer!);
    Overlay.of(context).insert(image_viewer!);
  }

  void Insert_Answer(String docid, Map<String, dynamic> inquiry) {
    insert_answer = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)),
            child: Center(
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0),
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black, width: 3),
                                  ),
                                ),
                                child: Text(
                                  '문의 내용',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.03,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.black, width: 1),
                                        ),
                                      ),
                                      child: Text(
                                        '제목',
                                        style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        inquiry['title'],
                                        style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.black, width: 1),
                                        ),
                                      ),
                                      child: Text(
                                        '파일',
                                        style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        String url = await controls.Load_Inquiry_Image(inquiry['imageurl']);
                                        Image_Viewer(url);
                                      },
                                      child: Text(
                                        inquiry['imageurl'],
                                        style: TextStyle(color: Colors.blue, fontSize: 15, decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '내용: ',
                                      style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      inquiry['content'],
                                      style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black, width: 1),
                                  ),
                                ),
                                child: Text(
                                  '답변 작성',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.3,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                child: TextField(
                                  controller: answer_text,
                                  maxLength: 300,
                                  maxLines: 12,
                                  onChanged: (value) {
                                    if (value.length != 0) {
                                      setState(() {
                                        answer = value;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () async {
                                      await controls.Insert_Answer(docid, answer);
                                      await Inquiry();
                                      Success(true);
                                      insert_answer!.remove();
                                      overlays.remove(insert_answer!);
                                    },
                                    child: Center(
                                      child: Text(
                                        '작성완료',
                                        style: TextStyle(color: widget.font_color),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () {
                                      insert_answer!.remove();
                                      overlays.remove(insert_answer!);
                                    },
                                    child: Center(
                                      child: Text(
                                        '취소',
                                        style: TextStyle(color: widget.font_color),
                                      ),
                                    ),
                                  ),
                                ],
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
        },
      ),
    );
    overlays.add(insert_answer!);
    Overlay.of(context).insert(insert_answer!);
  }

  void Message(String name, String type) {
    message = OverlayEntry(
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
                  decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 2), color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        type == 'review'
                            ? '정말 리뷰를\n삭제하시겠습니까?'
                            : type == 'menu'
                                ? '정말 해당 메뉴를\n삭제하시겠습니까?'
                                : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                              onPressed: () async {
                                if (type == 'review') {
                                  await controls.Delete_Review(name);
                                  await Reviews(context);
                                  message!.remove();
                                  overlays.remove(message!);
                                  Success(true);
                                } else if (type == 'menu') {
                                  await controls.Delete_menu(name);
                                  await Menus(context);
                                  message!.remove();
                                  overlays.remove(message!);

                                  Success(true);
                                }
                              },
                              child: Center(
                                child: Text('삭제'),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                              onPressed: () async {
                                message!.remove();
                                overlays.remove(message!);
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
    overlays.add(message!);
    Overlay.of(context).insert(message!);
  }

  void Success(bool result) {
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
              result ? '작업이 완료되었습니다.' : '작업에 실패하였습니다.',
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

  void Filter_Review(String option) {
    setState(() {
      filter_review = {};
    });
    if (option != '') {
      List<String> filter_data = reviews.keys.where((element) => element.contains(option)).toList();
      setState(() {
        for (String name in filter_data) {
          filter_review[name] = reviews[name]!;
        }
      });
    } else {
      setState(() {
        filter_review = reviews;
      });
    }
  }

  Future<void> Request() async {
    Map<String, dynamic> result = await controls.Load_Menu_Request();
    for (String name in result.keys) {
      menu_request[name] = Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '메뉴 이름: ${result[name]['name']}',
              style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
            ),
            Text(
              '카테고리: ${result[name]['category']}',
              style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
            ),
            Text(
              '한줄 평: ${result[name]['comment']}',
              style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
            ),
            Text(
              '요청자 : ${result[name]['writer']}',
              style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 10),
              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () async {
                          String url = await controls.Load_Request_Image(result[name]['imageurl']);
                          setState(() {
                            add_menu['name'] = result[name]['name'];
                            menu_name!.text = result[name]['name'];

                            add_menu['category'] = result[name]['category'];
                            menu_category!.text = result[name]['category'];

                            add_menu['eattype'] = result[name]['eattype'];
                            menu_eattype!.text = result[name]['eattype'];

                            add_menu['comment'] = result[name]['comment'];
                            menu_comment!.text = result[name]['comment'];

                            add_menu['eattime'] = result[name]['eattime'].split(',').map((e) => e.trim()).toList();
                            menu_eattime!.text = result[name]['eattime'];

                            add_menu['image'] = result[name]['imageurl'];
                            print('왜 널이지 ${result[name]['imageurl']}');
                            image_downlods = url;

                            request_add = true;

                            button_num = 1;
                          });
                        },
                        child: Text(
                          '추가',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () async {
                          await controls.Delete_Request(name);
                          menu_request.remove(name);
                          overlays.remove(menu_request!);
                          Success(true);
                        },
                        child: Text(
                          '삭제',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  Future<void> Inquiry() async {
    Map<String, dynamic> result = await controls.Load_AllInquiry();
    all_inquiry = result;
    setState(() {
      inquires.clear();
    });
    for (String name in result.keys) {
      inquires[name] = GestureDetector(
        onTap: () {
          if (all_inquiry[name]['answer'] == '') {
            answer_text.text = '안녕하세요.\n오늘뭐먹지 입니다.';
          } else {
            answer_text.text = all_inquiry[name]['answer'];
          }
          Insert_Answer(name, all_inquiry[name]);
        },
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          padding: EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.button_color),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '작성자 - ${result[name]['writer']}',
                style: TextStyle(color: widget.font_color, fontSize: 15),
              ),
              Text(
                '제목 - ${result[name]['title']}',
                style: TextStyle(color: widget.font_color, fontSize: 20),
              ),
              Text(
                result[name]['answer']! == '' ? '- 답변 미등록' : '- 답변 완료',
                style: TextStyle(color: widget.font_color, fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
    setState(() {
      filter_inquires = inquires;
    });
  }

  void Filter_Request(String option) {
    setState(() {
      filter_request = {};
    });
    for (String name in menu_request.keys) {
      if (all_request[name]['writer'].contains(option)) {
        filter_request[name] = menu_request[name]!;
      }
    }
    if (option == '') {
      filter_request = menu_request;
    }
  }

  void Filter_Inquiry(String option) {
    setState(() {
      filter_inquires = {};
    });
    if (option == 'all') {
      setState(() {
        filter_inquires = inquires;
      });
    } else if (option == 'true') {
      for (String key in all_inquiry.keys) {
        if (all_inquiry[key]['answer'] != '') {
          setState(() {
            filter_inquires[key] = inquires[key]!;
          });
        }
      }
    } else if (option == 'false') {
      for (String key in all_inquiry.keys) {
        if (all_inquiry[key]['answer'] == '') {
          setState(() {
            filter_inquires[key] = inquires[key]!;
          });
        }
      }
    } else {
      for (String key in all_inquiry.keys) {
        if (all_inquiry[key]['writer'].contains(option)) {
          setState(() {
            filter_inquires[key] = inquires[key]!;
          });
        }
      }
    }
    if (option == '') {
      setState(() {
        filter_inquires = inquires;
      });
    }
  }

  Future<void> Reviews(BuildContext context) async {
    Map<String, dynamic> result = await controls.Load_AllReview();
    setState(() {
      reviews = {};
      for (String name in result.keys) {
        reviews['${name}_${result[name]['menu']}_${result[name]['user']}'] = Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 2)),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                    height: double.infinity,
                    child: Text(
                      result[name]['menu'],
                      style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                    )),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        result[name]['text'],
                        style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.button_color,
                          ),
                          onPressed: () async {
                            String url = await controls.Load_Review_Image(result[name]['image']);
                            Image_Viewer(url);
                          },
                          child: Center(
                            child: Text(
                              '사진 보기',
                              style: TextStyle(fontSize: 20, color: widget.font_color),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.button_color,
                          ),
                          onPressed: () {
                            Message(name, 'review');
                          },
                          child: Center(
                            child: Text(
                              '게시글 삭제 ',
                              style: TextStyle(fontSize: 20, color: widget.font_color),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
      filter_review = reviews;
    });
  }

  Future<void> Members(BuildContext context) async {
    Map<String, dynamic> member_info = await controls.Load_Member();
    setState(() {
      member = [];
      for (String id in member_info.keys) {
        members[id] = Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(top: 5, bottom: 5),
          height: MediaQuery.of(context).size.height * 0.23,
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            border: Border.all(color: widget.back_color!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${member_info[id]['email']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  member_info[id]['gender'] == '남성'
                      ? Icon(
                          Icons.man,
                          color: Colors.blue,
                          size: 30,
                        )
                      : Icon(
                          Icons.woman,
                          color: Colors.red,
                          size: 30,
                        )
                ],
              ),
              Text(
                '닉네임 : ${member_info[id]['nickname']}',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                '생년월일 : ${member_info[id]['birth']}',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(border: Border.all(color: widget.back_color!, width: 2)),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.button_color,
                        ),
                        onPressed: () {
                          User_Information(id, member_info[id]);
                        },
                        child: Text(
                          '정보 수정',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () {
                          setState(() {
                            button_num = 2;
                            filter.text = id;
                            Filter_Review(id);
                          });
                        },
                        child: Text(
                          '게시글',
                          style: TextStyle(
                            color: widget.font_color,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () {
                          setState(() {
                            button_num = 4;
                            t_filter_inquiry.text = member_info[id]['email'];
                            Filter_Inquiry(member_info[id]['email']);
                          });
                        },
                        child: Text(
                          '문의',
                          style: TextStyle(
                            color: widget.font_color,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () {
                          setState(() {
                            button_num = 6;
                            t_filter_request.text = member_info[id]['email'];
                            Filter_Request(member_info[id]['email']);
                          });
                        },
                        child: Text(
                          '메뉴 요청',
                          style: TextStyle(
                            color: widget.font_color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }

  Future<void> Menus(BuildContext context) async {
    Map<String, dynamic> menus_info = await controls.Load_Menu();
    setState(() {
      menus = {};
    });
    for (String menu in menus_info.keys) {
      menus[menu] = Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(top: 5, bottom: 5),
        height: MediaQuery.of(context).size.height / 8,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(border: Border.all(color: widget.back_color!)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$menu',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.button_color,
                    ),
                    onPressed: () async {
                      String result = await controls.Load_Main_Image(menus_info[menu]['imageurl']);
                      setState(() {
                        add_menu['name'] = menu;
                        menu_name!.text = menu;

                        add_menu['category'] = menus_info[menu]['category'];
                        menu_category!.text = menus_info[menu]['category'];

                        add_menu['eattype'] = menus_info[menu]['eattype'];
                        menu_eattype!.text = menus_info[menu]['eattype'];

                        add_menu['comment'] = (menus_info[menu]['comment'] ?? '');
                        menu_comment!.text = (menus_info[menu]['comment'] ?? '');

                        add_menu['eattime'] = menus_info[menu]['eattime'];
                        menu_eattime!.text = menus_info[menu]['eattime'].join(',');

                        add_menu['oldimage'] = menus_info[menu]['imageurl'];

                        image_downlods = result;
                        menu_check.clear();

                        button_num = 1;
                      });
                    },
                    child: Text(
                      '수정',
                      style: TextStyle(
                        color: widget.font_color,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => view_screen(widget.back_color, widget.button_color, widget.font_color, menu)));
                    },
                    child: Text(
                      '게시글',
                      style: TextStyle(
                        color: widget.font_color,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                    onPressed: () {
                      Message(menu, 'menu');
                    },
                    child: Text(
                      '삭제',
                      style: TextStyle(
                        color: widget.font_color,
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      setState(() {
        containerHeight = MediaQuery.of(context).size.height * 0.8 - bottomInset;
      });
    });
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (overlays.length != 0) {
            OverlayEntry overlayEntry = overlays.last;
            overlayEntry.remove();
            overlays.remove(overlayEntry);
            return false;
          } else {
            return true;
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: widget.back_color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height / 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () {
                          setState(() {
                            button_num = 1;
                            request_add = false;
                            menu_check.clear();
                            add_menu.clear();
                            menu_category!.text = '';
                            menu_comment!.text = '';
                            menu_name!.text = '';
                            menu_eattime!.text = '';
                            menu_eattype!.text = '';
                            image_downlods = '';
                            image_select = null;
                          });
                        },
                        child: Text(
                          '음식 추가',
                          style: TextStyle(
                            color: widget.font_color,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.button_color,
                        ),
                        onPressed: () async {
                          await Menus(context);
                          setState(() {
                            button_num = 5;
                          });
                        },
                        child: Text(
                          '음식 관리',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.button_color,
                        ),
                        onPressed: () async {
                          await Reviews(context);
                          setState(() {
                            button_num = 2;
                            filter.text = '';
                          });
                        },
                        child: Text(
                          '리뷰 관리',
                          style: TextStyle(
                            color: widget.font_color,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                        onPressed: () {
                          setState(() {
                            Members(context);
                            button_num = 3;
                          });
                        },
                        child: Text(
                          '회원 관리',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.button_color,
                        ),
                        onPressed: () async {
                          await Inquiry();
                          setState(() {
                            t_filter_inquiry.text = '';
                            button_num = 4;
                          });
                        },
                        child: Text(
                          '문의 관리',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.button_color,
                        ),
                        onPressed: () async {
                          await Request();
                          setState(() {
                            button_num = 6;
                            t_filter_request.text = '';
                          });
                        },
                        child: Text(
                          '메뉴 요청',
                          style: TextStyle(color: widget.font_color),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.9,
                height: containerHeight,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: button_num == 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '메뉴 추가',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 30),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '미리보기',
                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                      ),
                                      image_downlods != ''
                                          ? Container(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              height: MediaQuery.of(context).size.height * 0.15,
                                              child: Image.network(image_downlods, fit: BoxFit.cover))
                                          : image_select != null
                                              ? Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  height: MediaQuery.of(context).size.height * 0.15,
                                                  decoration:
                                                      BoxDecoration(image: DecorationImage(image: FileImage(image_select!), fit: BoxFit.cover)),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context).size.width * 0.2,
                                                  height: MediaQuery.of(context).size.height * 0.15,
                                                  decoration: BoxDecoration(),
                                                  child: Center(
                                                    child: Text(
                                                      'No Image',
                                                      style: TextStyle(fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () async {
                                      File? result = await controls.Image_Select();
                                      setState(() {
                                        image_select = result;
                                        add_menu['image'] = image_select;
                                        image_downlods = '';
                                      });
                                    },
                                    child: Text('사진 업로드'),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      '메뉴 이름',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        controller: menu_name,
                                        maxLines: 1,
                                        maxLength: 20,
                                        decoration: InputDecoration(hintText: '메뉴를 알 수 있는 이름', border: OutlineInputBorder(), counterText: ''),
                                        onChanged: (value) {
                                          setState(() {
                                            add_menu['name'] = value;
                                          });
                                        },
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
                                  menu_check['menu_dup'] != null
                                      ? menu_check['menu_dup']!
                                          ? '중복되지 않습니다'
                                          : '중복되는 이름이 존재합니다'
                                      : '',
                                  style: TextStyle(fontSize: 15, color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: widget.button_color,
                                    ),
                                    onPressed: () async {
                                      bool result = await controls.Menu_Duplication(add_menu['name']);
                                      setState(() {
                                        menu_check['menu_dup'] = result;
                                      });
                                    },
                                    child: Text(
                                      '중복 확인',
                                      style: TextStyle(color: widget.font_color),
                                    ))
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              height: MediaQuery.of(context).size.height / 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      '카테고리',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        controller: menu_category,
                                        maxLines: 1,
                                        maxLength: 20,
                                        decoration: InputDecoration(hintText: '햄버거,피자,치킨 등 큰 범위', border: OutlineInputBorder(), counterText: ''),
                                        onChanged: (value) {
                                          setState(() {
                                            add_menu['category'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              height: MediaQuery.of(context).size.height / 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      '식사타입',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        controller: menu_eattype,
                                        maxLines: 1,
                                        maxLength: 20,
                                        decoration: InputDecoration(hintText: '면,빵,튀김 등', border: OutlineInputBorder(), counterText: ''),
                                        onChanged: (value) {
                                          setState(() {
                                            add_menu['eattype'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              height: MediaQuery.of(context).size.height / 15,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      '식사시간',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: TextField(
                                        controller: menu_eattime,
                                        maxLines: 1,
                                        maxLength: 20,
                                        decoration: InputDecoration(hintText: ',(쉼표)로 구분', border: OutlineInputBorder(), counterText: ''),
                                        onChanged: (value) {
                                          setState(() {
                                            add_menu['eattime'] = value.split(',').map((e) => e.trim()).toList();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5, bottom: 5),
                              height: MediaQuery.of(context).size.height / 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.2,
                                    child: Text(
                                      '한줄평',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: MediaQuery.of(context).size.height * 0.2,
                                      child: TextField(
                                        controller: menu_comment,
                                        maxLines: 1,
                                        maxLength: 50,
                                        decoration: InputDecoration(hintText: '간단한 평', border: OutlineInputBorder(), counterText: ''),
                                        onChanged: (value) {
                                          setState(() {
                                            add_menu['comment'] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                    onPressed: () async {
                                      if (request_add) {
                                        bool result = await controls.Request_To_Menu(add_menu);
                                        setState(() {
                                          menu_check.clear();
                                          add_menu.clear();
                                          menu_category!.text = '';
                                          menu_comment!.text = '';
                                          menu_name!.text = '';
                                          menu_eattime!.text = '';
                                          menu_eattype!.text = '';
                                          image_downlods = '';
                                          request_add = false;
                                          image_select = null;
                                        });
                                        Success(result);
                                      } else {
                                        bool result = await controls.Menu_Add(add_menu);
                                        setState(() {
                                          image_select = null;
                                          menu_check.clear();
                                          add_menu.clear();
                                          menu_category!.text = '';
                                          menu_comment!.text = '';
                                          menu_name!.text = '';
                                          menu_eattime!.text = '';
                                          menu_eattype!.text = '';
                                          image_downlods = '';
                                        });
                                        Success(result);
                                      }
                                    },
                                    child: Text(
                                      '등록',
                                      style: TextStyle(
                                        color: widget.font_color,
                                      ),
                                    ))
                              ],
                            )
                          ],
                        )
                      : button_num == 2
                          ? Column(
                              children: [
                                TextField(
                                  controller: filter,
                                  maxLines: 1,
                                  onChanged: (value) {
                                    Filter_Review(value);
                                  },
                                  decoration: InputDecoration(hintText: '검색어를 입력해주세요'),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.7,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: filter_review.values.toList(),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : button_num == 3
                              ? Column(
                                  children: members.values.toList(),
                                )
                              : button_num == 4
                                  ? Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height * 0.08,
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                onPressed: () {
                                                  Filter_Inquiry('all');
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '전체보기',
                                                    style: TextStyle(
                                                      color: widget.font_color,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                onPressed: () {
                                                  Filter_Inquiry('true');
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '답변완료',
                                                    style: TextStyle(
                                                      color: widget.font_color,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                onPressed: () {
                                                  Filter_Inquiry('false');
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '답변미작성',
                                                    style: TextStyle(
                                                      color: widget.font_color,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextField(
                                          controller: t_filter_inquiry,
                                          maxLines: 1,
                                          onChanged: (value) {
                                            Filter_Inquiry(value);
                                          },
                                          decoration: InputDecoration(hintText: '검색어를 입력해주세요'),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context).size.height * 0.55,
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: filter_inquires.values.toList(),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : button_num == 5
                                      ? Column(
                                          children: menus.values.toList(),
                                        )
                                      : button_num == 6
                                          ? Column(
                                              children: [
                                                TextField(
                                                  controller: t_filter_request,
                                                  maxLines: 1,
                                                  onChanged: (value) {
                                                    Filter_Request(value);
                                                  },
                                                  decoration: InputDecoration(hintText: '검색어를 입력해주세요'),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context).size.height * 0.68,
                                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                                  child: Column(
                                                    children: menu_request.values.toList(),
                                                  ),
                                                )
                                              ],
                                            )
                                          : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
