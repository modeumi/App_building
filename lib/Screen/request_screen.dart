import 'dart:io';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Data/user_data.dart';
import 'package:flutter/material.dart';

class request_screen extends StatefulWidget {
  final Color? back_color;
  final Color? button_color;
  final Color? font_color;
  final UserData userdata;

  request_screen(this.back_color, this.button_color, this.font_color, this.userdata);

  Request_Screen createState() => Request_Screen();
}

class Request_Screen extends State<request_screen> {
  int page_selct = 1;
  File? upload_image;
  File? inquire_image;
  File? change_image;
  String inquire_image_name = 'jpg, jpeg, png 만 등록가능';
  Controls controls = Controls();
  String menu_name = '';
  String menu_time = '';
  String menu_type = '';
  String menu_comment = '';
  String menu_category = '';
  bool? request_state;
  bool? inquiry_state;
  bool history_content = false;
  bool history_change = false;
  String no_check = '';
  bool check_box = false;
  Map<String, dynamic> request = {};
  Map<String, dynamic> inquiry = {};
  Map<String, dynamic> change = {};
  String inquiry_code = '';
  String title = '';
  TextEditingController? title_controller = TextEditingController();
  String content = '';
  TextEditingController? content_controller = TextEditingController();
  String imageurl = '';
  String change_imageurl = '';
  String answer = '';
  Map<String, Widget> history = {};
  OverlayEntry? request_success;
  OverlayEntry? image_viewer;
  List<OverlayEntry> overlays = [];
  TextEditingController? t_menu_name = TextEditingController();
  TextEditingController? t_menu_category = TextEditingController();
  TextEditingController? t_menu_time = TextEditingController();
  TextEditingController? t_menu_type = TextEditingController();
  TextEditingController? t_menu_comment = TextEditingController();
  TextEditingController? t_inquiry_title = TextEditingController();
  TextEditingController? t_inquiry_content = TextEditingController();

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
                    child: Image.network(
                      url,
                      fit: BoxFit.fill,
                    )),
              ),
            ));
    overlays.add(image_viewer!);
    Overlay.of(context).insert(image_viewer!);
  }

  Future<void> Inquiry_History(String email) async {
    Map<String, dynamic> result = await controls.Load_Inquiry(email);
    setState(() {
      history.clear();
    });
    for (String name in result.keys) {
      history[name] = GestureDetector(
        onTap: () {
          setState(() {
            history_content = true;
            history_change = false;
            inquiry_code = name;
            title = result[name]['title'];
            content = result[name]['content'];
            imageurl = result[name]['imageurl'];
            answer = result[name]['answer'];
          });
        },
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 5, bottom: 5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.button_color,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '제목 : ${result[name]['title']}',
                style: TextStyle(fontSize: 20, color: widget.font_color),
              ),
              Text(
                '작성일자 : ${result[name]['time']}',
                style: TextStyle(fontSize: 15, color: widget.font_color),
              ),
              Text(
                result[name]['answer'] == '' ? '답변여부 : X ' : '답변여부 : O',
                style: TextStyle(fontSize: 15, color: widget.font_color),
              )
            ],
          ),
        ),
      );
    }
  }

  void Request_Success(String type) {
    request_success = OverlayEntry(
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(10),
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
                type == 'request'
                    ? '메뉴 추가 요청이\n성공적으로 전송되었습니다.'
                    : type == 'inquiry'
                        ? '문의가 성공적으로 등록되었습니다.'
                        : type == 'change_true'
                            ? '수정이 완료되었습니다.'
                            : type == 'change_false'
                                ? '수정사항이 존재하지 않습니다.'
                                : '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'DnF',
                  decoration: TextDecoration.none,
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(request_success!);
    Future.delayed(Duration(seconds: 2), () {
      request_success!.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: widget.back_color,
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.95,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, border: Border.all(color: widget.button_color!, width: 3), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.button_color,
                                ),
                                onPressed: () {
                                  setState(() {
                                    page_selct = 1;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '메뉴 추가 요청',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.font_color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.button_color,
                                ),
                                onPressed: () {
                                  setState(() {
                                    page_selct = 2;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '문의하기',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.font_color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.button_color,
                                ),
                                onPressed: () async {
                                  await Inquiry_History(widget.userdata.email!);
                                  setState(() {
                                    page_selct = 3;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    '문의 내역',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.font_color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: page_selct == 1
                          // 메뉴 추가 요청
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              padding: EdgeInsets.all(10),
                              decoration:
                                  BoxDecoration(color: Colors.grey.withOpacity(0.3), border: Border.all(color: widget.button_color!, width: 2)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(30),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '메뉴 추가 요청서',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 3, bottom: 20),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                    ),
                                    upload_image != null
                                        ? Container(
                                            child: Image.file(upload_image!),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                            child: Center(
                                              child: Text(
                                                'No Image',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    upload_image == null
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                            onPressed: () async {
                                              File? result = await controls.Image_Select();
                                              setState(() {
                                                upload_image = result;
                                                request['image'] = upload_image;
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '사진 등록',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                            onPressed: () {
                                              setState(() {
                                                upload_image = null;
                                                request.remove('image');
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                '사진 제거',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '이름',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: TextField(
                                              controller: t_menu_name,
                                              maxLines: 1,
                                              maxLength: 20,
                                              decoration: InputDecoration(counterText: '', hintText: 'ex) 치즈 돈까스, 제육볶음 등', border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {
                                                  menu_name = text;
                                                  if (text.length != 0) {
                                                    request['name'] = menu_name;
                                                  } else {
                                                    request.remove('name');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '카테고리',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: TextField(
                                              controller: t_menu_category,
                                              maxLines: 1,
                                              maxLength: 20,
                                              decoration: InputDecoration(counterText: '', hintText: 'ex) 햄버거, 피자, 파스타 등', border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {
                                                  menu_category = text;
                                                  if (text.length != 0) {
                                                    request['category'] = menu_category;
                                                  } else {
                                                    request.remove('category');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '먹기좋은 시간',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: TextField(
                                              controller: t_menu_time,
                                              maxLines: 2,
                                              maxLength: 20,
                                              decoration: InputDecoration(
                                                  counterText: '', hintText: 'ex) 점심,저녁 과 같이 ,로\n구분 지어 여러개 작성가능', border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {
                                                  menu_time = text;
                                                  if (text.length != 0) {
                                                    request['time'] = menu_time;
                                                  } else {
                                                    request.remove('time');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '식사 타입',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: TextField(
                                              controller: t_menu_type,
                                              maxLines: 1,
                                              maxLength: 20,
                                              decoration: InputDecoration(counterText: '', hintText: 'ex) 빵, 면 등 한 종류만 기입', border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {
                                                  menu_type = text;
                                                  if (text.length != 0) {
                                                    request['type'] = menu_type;
                                                  } else {
                                                    request.remove('type');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.1,
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '한줄평',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: TextField(
                                              controller: t_menu_comment,
                                              maxLines: 2,
                                              maxLength: 100,
                                              decoration:
                                                  InputDecoration(counterText: '', hintText: '음식에 대한 설명을 간단하게 작성해주세요!', border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {
                                                  menu_comment = text;
                                                  if (text.length != 0) {
                                                    request['comment'] = menu_comment;
                                                  } else {
                                                    request.remove('comment');
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.black, width: 2),
                                          bottom: BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            value: check_box,
                                            onChanged: (value) {
                                              setState(() {
                                                check_box = value!;
                                                no_check = '';
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Text(
                                            '아래 내용에 동의합니다.',
                                            style: TextStyle(color: Colors.black, fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      no_check,
                                      style: TextStyle(color: Colors.redAccent, fontSize: 15),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '1. 작성한 내용이나 사진에 부적절한 요소가 포함 시 게시되지 않을 수 있습니다.',
                                            style: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                          Text(
                                            '2. 작성된 내용이 형식에 어긋나거나 정확하지 않을 시 수정되거나 게시되지 않을 수 있습니다.',
                                            style: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                          Text(
                                            '3. 게시된 메뉴는 회원탈퇴 후에도 삭제되지 않을 수 있습니다.',
                                            style: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                          Text(
                                            '4. 게시 후 추가적 문제 발생 시 통보 없이 삭제될 수 있습니다.',
                                            style: TextStyle(color: Colors.grey, fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(top: 10),
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: Colors.black, width: 2),
                                          bottom: BorderSide(color: Colors.black, width: 2),
                                        ),
                                      ),
                                    ),
                                    request_state != null
                                        ? request_state!
                                            ? Container()
                                            : Text(
                                                '입력되지 않은 정보가 있습니다.',
                                                style: TextStyle(color: Colors.redAccent, fontSize: 15),
                                              )
                                        : Container(),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                '요청자 : ${widget.userdata.nickname!}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                onPressed: () async {
                                                  if (check_box) {
                                                    List<String> request_list = ['image', 'name', 'time', 'type', 'comment', 'category'];
                                                    setState(() {
                                                      request_state = true;
                                                    });
                                                    for (String element in request_list) {
                                                      if (!request.containsKey(element)) {
                                                        setState(() {
                                                          request_state = false;
                                                        });
                                                      }
                                                    }
                                                    if (request_state!) {
                                                      setState(() {
                                                        request['writer'] = widget.userdata.email;
                                                      });
                                                      await controls.Menu_Request(request);
                                                      Request_Success('request');
                                                      setState(() {
                                                        upload_image = null;
                                                        t_menu_category!.text = '';
                                                        t_menu_comment!.text = '';
                                                        t_menu_name!.text = '';
                                                        t_menu_time!.text = '';
                                                        t_menu_type!.text = '';
                                                        check_box = false;
                                                        request.clear();
                                                      });
                                                    }
                                                  } else {
                                                    setState(() {
                                                      no_check = '동의란에 체크 해주세요.';
                                                    });
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                    '전송',
                                                    style: TextStyle(color: widget.font_color),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : page_selct == 2
                              // 문의하기
                              ? Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.8,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text(
                                          '문의하기',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 30, color: Colors.black),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(color: Colors.black, width: 2),
                                              bottom: BorderSide(color: Colors.black, width: 2),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(
                                            '제목',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.05,
                                          child: TextField(
                                            controller: t_inquiry_title,
                                            onChanged: (text) {
                                              setState(() {
                                                if (text.length != 0) {
                                                  inquiry['title'] = text;
                                                } else {
                                                  inquiry.remove('title');
                                                }
                                              });
                                            },
                                            maxLines: 1,
                                            maxLength: 30,
                                            decoration:
                                                InputDecoration(hintText: '제목을 입력해주세요 (최대 30자)', counterText: '', border: OutlineInputBorder()),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text(
                                            '내용',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 7,
                                                child: Text('$inquire_image_name'),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: widget.button_color,
                                                  ),
                                                  onPressed: () async {
                                                    if (inquire_image == null) {
                                                      File? result = await controls.Image_Select();
                                                      if (result != null) {
                                                        setState(() {
                                                          inquire_image = result;
                                                          inquiry['image'] = inquire_image;
                                                          inquire_image_name = result!.path.split('/').last;
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {
                                                        inquire_image = null;
                                                        inquiry.remove('image');
                                                        inquire_image_name = '(jpg, jpeg, png 만 등록가능)';
                                                      });
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Text(inquire_image != null ? '사진 제거' : '사진 등록'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextField(
                                          controller: t_inquiry_content,
                                          maxLines: 12,
                                          maxLength: 200,
                                          decoration: InputDecoration(
                                            hintText: '최대 200자 작성 가능',
                                            border: OutlineInputBorder(),
                                          ),
                                          onChanged: (text) {
                                            setState(
                                              () {
                                                if (text.length != 0) {
                                                  inquiry['content'] = text;
                                                } else {
                                                  inquiry.remove('content');
                                                }
                                              },
                                            );
                                          },
                                        ),
                                        inquiry_state != null
                                            ? inquiry_state!
                                                ? Container()
                                                : Text(
                                                    '입력하지 않은 요소가 있습니다.',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                            : Container(),
                                        Container(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(flex: 6, child: Container()),
                                              Expanded(
                                                flex: 2,
                                                child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                    onPressed: () async {
                                                      setState(() {
                                                        inquiry_state = true;
                                                        List<String> inquire_check = ['title', 'content'];
                                                        for (String check in inquire_check) {
                                                          if (!inquiry.containsKey(check)) {
                                                            inquiry_state = false;
                                                          }
                                                        }
                                                      });
                                                      if (inquiry_state!) {
                                                        inquiry.forEach((key, value) {
                                                          print('내역확인 : $key : $value');
                                                        });
                                                        setState(() {
                                                          inquiry['writer'] = widget.userdata.email;
                                                        });
                                                        await controls.Add_Inquiry(inquiry);
                                                        Request_Success('inquiry');
                                                        setState(() {
                                                          t_inquiry_title!.text = '';
                                                          t_inquiry_content!.text = '';
                                                          inquire_image = null;
                                                          inquire_image_name = '';
                                                          inquiry.clear();
                                                        });
                                                      }
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        '전송',
                                                        style: TextStyle(color: widget.font_color),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '작성하신 문의 및 답변은 문의 내역에서 확인하실 수 있습니다.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.grey, fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : page_selct == 3
                                  //문의 내역
                                  ? Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(color: Colors.black, width: 3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '문의 내역',
                                                    style: TextStyle(fontSize: 25, color: Colors.black, decoration: TextDecoration.none),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              height: MediaQuery.of(context).size.height * 0.25,
                                              width: double.infinity,
                                              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                              child: history.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        '아직 등록된 문의 내역이 없습니다.',
                                                        style: TextStyle(color: Colors.grey, fontSize: 15),
                                                      ),
                                                    )
                                                  : SingleChildScrollView(
                                                      child: Column(
                                                        children: history.values.toList(),
                                                      ),
                                                    ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              margin: EdgeInsets.only(top: 15),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(color: Colors.black, width: 3),
                                                ),
                                              ),
                                              child: Text(
                                                '문의 내용',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(fontSize: 25, color: Colors.black),
                                              ),
                                            ),
                                            history_content
                                                ? history_change
                                                    ? Container(
                                                        height: MediaQuery.of(context).size.height * 0.4,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(top: 10),
                                                        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: double.infinity,
                                                                height: MediaQuery.of(context).size.height * 0.08,
                                                                decoration:
                                                                    BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 1))),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            border: Border(right: BorderSide(color: Colors.black, width: 1))),
                                                                        child: Center(
                                                                          child: Text(
                                                                            '제목 ',
                                                                            style: TextStyle(fontSize: 20, color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 4,
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(left: 10),
                                                                        child: Text(
                                                                          title,
                                                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  width: double.infinity,
                                                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                                                  padding: EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 7,
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '등록된 사진',
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                            Text(
                                                                              change_imageurl,
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            if (change_imageurl == '') {
                                                                              File? result = await controls.Image_Select();
                                                                              setState(() {
                                                                                if (result != null) {
                                                                                  change['image'] = result;
                                                                                  change_imageurl = result.path.toString().split('/').last;
                                                                                }
                                                                              });
                                                                            } else {
                                                                              setState(() {
                                                                                change['image'] = '';
                                                                                change_imageurl = '';
                                                                              });
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            height: MediaQuery.of(context).size.height * 0.05,
                                                                            decoration: BoxDecoration(
                                                                                color: widget.button_color, borderRadius: BorderRadius.circular(5)),
                                                                            child: Center(
                                                                              child: Text(
                                                                                change_imageurl == '' ? '사진 추가' : '사진 제거',
                                                                                style: TextStyle(color: widget.font_color),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              Container(
                                                                padding: EdgeInsets.all(5),
                                                                width: double.infinity,
                                                                height: MediaQuery.of(context).size.height * 0.3,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.black, width: 1),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        '내용',
                                                                        style: TextStyle(color: Colors.black, fontSize: 15),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 9,
                                                                      child: TextField(
                                                                        maxLines: 12,
                                                                        maxLength: 200,
                                                                        controller: content_controller,
                                                                        decoration: InputDecoration(border: InputBorder.none),
                                                                        onChanged: (value) {
                                                                          if (value.length != 0) {
                                                                            setState(() {
                                                                              change['content'] = value;
                                                                            });
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(10),
                                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                                  height: MediaQuery.of(context).size.height * 0.05,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                                        onPressed: () async {
                                                                          setState(() {
                                                                            change['docid'] = inquiry_code;
                                                                          });
                                                                          if (change.containsKey('content') || change.containsKey('image')) {
                                                                            await controls.Change_Inquiry(change);
                                                                            setState(() {
                                                                              history_change = false;
                                                                              history_content = false;
                                                                              change.clear();
                                                                            });
                                                                            Request_Success('change_true');
                                                                            Inquiry_History(widget.userdata.email!);
                                                                          } else {
                                                                            Request_Success('change_false');
                                                                          }
                                                                        },
                                                                        child: Center(
                                                                          child: Text(
                                                                            '수정',
                                                                            style: TextStyle(color: widget.font_color),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            change.clear();
                                                                            history_change = false;
                                                                          });
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(top: 10),
                                                        decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: double.infinity,
                                                              padding: EdgeInsets.all(10),
                                                              decoration: BoxDecoration(
                                                                border: Border(
                                                                  bottom: BorderSide(color: Colors.black, width: 2),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '제목 : $title',
                                                                style: TextStyle(color: Colors.black, fontSize: 20),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: double.infinity,
                                                              margin: EdgeInsets.only(top: 10, bottom: 10),
                                                              padding: EdgeInsets.all(5),
                                                              decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    '등록된 사진',
                                                                    style: TextStyle(fontSize: 15, color: Colors.black),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      String url = await controls.Load_Inquiry_Image(imageurl);
                                                                      Image_Viewer(url);
                                                                    },
                                                                    child: Text(
                                                                      imageurl,
                                                                      style: TextStyle(
                                                                        color: Colors.blue,
                                                                        fontSize: 15,
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.all(5),
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(color: Colors.black, width: 1),
                                                              ),
                                                              child: Text(
                                                                '내용 \n$content',
                                                                style: TextStyle(color: Colors.black, fontSize: 15),
                                                              ),
                                                            ),
                                                            answer == ''
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            title_controller!.text = title;
                                                                            content_controller!.text = content;
                                                                            history_change = true;
                                                                            change_imageurl = imageurl;
                                                                          });
                                                                        },
                                                                        child: Container(
                                                                          width: MediaQuery.of(context).size.width * 0.1,
                                                                          child: Center(
                                                                            child: Text(
                                                                              '수정',
                                                                              style: TextStyle(color: widget.font_color),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Column(
                                                                    children: [
                                                                      Container(
                                                                        width: double.infinity,
                                                                        margin: EdgeInsets.only(top: 10, bottom: 10),
                                                                        padding: EdgeInsets.all(5),
                                                                        decoration: BoxDecoration(
                                                                            border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
                                                                        child: Text(
                                                                          '답변 내용',
                                                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: double.infinity,
                                                                        padding: EdgeInsets.all(10),
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.black, width: 1),
                                                                        ),
                                                                        child: Text(
                                                                          answer,
                                                                          style: TextStyle(
                                                                              color: Colors.black, fontSize: 15, decoration: TextDecoration.none),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                      )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
