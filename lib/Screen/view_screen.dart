import 'dart:async';
import 'dart:io';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Screen/map_screen.dart';
import 'package:flutter/material.dart';

class view_screen extends StatefulWidget {
  final Color? back_color;
  final Color? button_color;
  final Color? font_color;
  final String menu_name;

  view_screen(this.back_color, this.button_color, this.font_color, this.menu_name);

  View_Screen createState() => View_Screen();
}

class View_Screen extends State<view_screen> {
  bool load_page = false;
  late bool login_state;
  Controls controls = Controls();
  TextEditingController review = TextEditingController();
  Map<String, dynamic> menu = {};
  List<OverlayEntry> overlays = [];
  OverlayEntry? review_message;
  OverlayEntry? change_review;
  OverlayEntry? delete_overlay;
  OverlayEntry? image_viewer;
  int message_num = 0;

  File? image_select;
  String review_text = '';

  Map<String, Widget> reviews = {};

  bool? delete_decision;
  bool working = true;

  @override
  void initState() {
    super.initState();
    Load_Prepa();
  }

  void Load_Prepa() async {
    Map<String, dynamic> result = await controls.Select_menu(widget.menu_name);
    bool login = await controls.Check_login();
    await Load_Reviews();
    setState(() {
      login_state = login;
      menu = result;
      menu['name'] = widget.menu_name;
      load_page = true;
    });
  }

  void Delete_Overlay(String document) {
    delete_overlay = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '정말로 삭제할까요?',
                      style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await controls.Delete_Review(document);
                              setState(() {
                                message_num = 5;
                              });
                              Review_Message(message_num);
                              await Load_Reviews();
                              delete_overlay!.remove();
                              overlays.remove(delete_overlay!);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: double.infinity,
                              decoration: BoxDecoration(color: widget.button_color),
                              child: Center(
                                child: Text(
                                  '삭제',
                                  style: TextStyle(fontSize: 20, color: widget.font_color, decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              delete_overlay!.remove();
                              overlays.remove(delete_overlay!);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: double.infinity,
                              decoration: BoxDecoration(color: widget.button_color),
                              child: Center(
                                child: Text(
                                  '취소',
                                  style: TextStyle(fontSize: 20, color: widget.font_color, decoration: TextDecoration.none),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(delete_overlay!);
    overlays.add(delete_overlay!);
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
                child: Image.network(
                  url,
                  fit: BoxFit.fill,
                ),
              )),
            ));
    Overlay.of(context).insert(image_viewer!);
    overlays.add(image_viewer!);
  }

  void Change_Review(String docuid, String text, String image) {
    TextEditingController text_review = TextEditingController();
    text_review.text = text;
    File? change_image;
    bool delete_image = false;
    change_review = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 50, bottom: 50, left: 15, right: 15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Center(
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0),
                body: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: widget.button_color!, width: 3)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: widget.button_color!, width: 2),
                            ),
                          ),
                          child: Text(
                            '리뷰 수정',
                            style: TextStyle(color: Colors.black, fontSize: 25, decoration: TextDecoration.none),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: image != ''
                                  ? Image.network(image, fit: BoxFit.fill)
                                  : change_image != null
                                      ? Image.file(
                                          change_image!,
                                          fit: BoxFit.fill,
                                        )
                                      : Center(
                                          child: Text(
                                            'no image',
                                            style: TextStyle(color: Colors.grey, fontSize: 15, decoration: TextDecoration.none),
                                          ),
                                        ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (image != '') {
                                  setState(() {
                                    image = '';
                                    delete_image = true;
                                  });
                                } else if (change_image != null) {
                                  setState(() {
                                    change_image = null;
                                  });
                                } else {
                                  File? result = await controls.Image_Select();
                                  setState(() {
                                    change_image = result;
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 15),
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: widget.button_color,
                                ),
                                child: Center(
                                  child: Text(
                                    image != ''
                                        ? '사진 제거'
                                        : change_image != null
                                            ? '사진 제거'
                                            : '사진 등록',
                                    style: TextStyle(color: widget.font_color, fontSize: 15, fontFamily: 'DnF', decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                          child: TextField(
                            controller: text_review,
                            maxLength: 100,
                            maxLines: 6,
                            onChanged: (value) {
                              text = value;
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  bool result = await controls.Update_Review(docuid, text, change_image,delete_image);
                                  if (result) {
                                    setState(() {
                                      message_num = 4;
                                    });
                                    Review_Message(message_num);
                                    change_review!.remove();
                                    overlays.remove(change_review!);
                                    await Load_Reviews();
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: double.infinity,
                                  decoration: BoxDecoration(color: widget.button_color),
                                  child: Center(
                                    child: Text(
                                      '수정',
                                      style: TextStyle(color: widget.font_color, fontSize: 15, decoration: TextDecoration.none),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  change_review!.remove();
                                  overlays.remove(change_review!);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  height: double.infinity,
                                  decoration: BoxDecoration(color: widget.button_color),
                                  child: Center(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(color: widget.font_color, fontSize: 15, decoration: TextDecoration.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    Overlay.of(context).insert(change_review!);
    overlays.add(change_review!);
  }

  Future<void> Load_Reviews() async {
    Map<String, dynamic> load_reviews = await controls.Load_Review(widget.menu_name);
    String uid = await controls.Get_UID();
    setState(() {
      reviews = {};
      for (String docu in load_reviews.keys) {
        String time = load_reviews[docu]['time'];
        String format = '${time.substring(0, 4)}/${time.substring(4, 6)}/${time.substring(6, 8)}';
        reviews[docu] = Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
          width: double.infinity,
          height: 100,
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    height: double.infinity,
                    child: Center(
                      child: load_reviews[docu]['image'] != ''
                          ? GestureDetector(
                              onTap: () {
                                Image_Viewer(load_reviews[docu]['image']);
                              },
                              child: Container(
                                child: Image.network(
                                  load_reviews[docu]['image'],
                                ),
                              ),
                            )
                          : Text('no image'),
                    ),
                  )),
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        child: Text(
                          load_reviews[docu]['text'],
                          style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            format,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          uid == load_reviews[docu]['user']
                              ? Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Delete_Overlay(docu);
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: 50,
                                          decoration: BoxDecoration(color: widget.button_color),
                                          child: Center(
                                            child: Text(
                                              '삭제',
                                              style: TextStyle(fontSize: 15, color: widget.font_color, decoration: TextDecoration.none),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Change_Review(docu, load_reviews[docu]['text'], load_reviews[docu]['image']);
                                        },
                                        child: Container(
                                          height: double.infinity,
                                          width: 50,
                                          decoration: BoxDecoration(color: widget.button_color),
                                          child: Center(
                                            child: Text(
                                              '수정',
                                              style: TextStyle(fontSize: 15, color: widget.font_color, decoration: TextDecoration.none),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: double.infinity,
                                  width: 50,
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  void Review_Message(int num) {
    review_message = OverlayEntry(
        builder: (context) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: widget.button_color!, width: 2)),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 2)),
                    child: Center(
                      child: Text(
                        message_num == 1
                            ? '리뷰를 등록했습니다.\n게시까지 약간의 시간이 소요될 수 있습니다.'
                            : message_num == 2
                                ? '로그인이 필요한 기능입니다.'
                                : message_num == 3
                                    ? '리뷰는 최소 6자 최대 100자 입니다.'
                                    : message_num == 4
                                        ? '수정이 완료되었습니다.'
                                        : message_num == 5
                                            ? '삭제가 완료되었습니다.'
                                            : '오류 - 처음부터 다시 시도해주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 20, decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              ),
            ));
    Overlay.of(context).insert(review_message!);
    Timer(Duration(seconds: 1), () {
      review_message!.remove();
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
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: widget.back_color,
          ),
          child: load_page
              ? Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.white, border: Border.all(color: widget.button_color!, width: 2)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          child: Center(
                            child: Text(menu['name'], style: TextStyle(fontSize: 30, color: Colors.black, decoration: TextDecoration.none)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 3)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Image_Viewer(menu['imageurl']);
                          },
                          child: Container(
                            margin: EdgeInsets.all(15),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.network(
                              menu['imageurl'],
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => map_screen(menu['name'])));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(color: widget.button_color),
                                child: Center(
                                  child: Text(
                                    '주변 맛집 검색',
                                    style: TextStyle(color: widget.font_color),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  '- 한줄평 -',
                                  style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 2)),
                                child: Center(
                                  child: Text(
                                    '" ${menu['comment']} "',
                                    style: TextStyle(fontSize: 20, color: Colors.black, decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: widget.button_color!, width: 3))),
                          child: Center(
                            child: Text(
                              '리뷰 작성',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 2)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: image_select != null
                                            ? Container(
                                                height: MediaQuery.of(context).size.height * 0.1,
                                                decoration: BoxDecoration(image: DecorationImage(image: FileImage(image_select!), fit: BoxFit.fill)),
                                              )
                                            : Container(
                                                height: MediaQuery.of(context).size.height * 0.1,
                                              ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (image_select != null) {
                                              setState(() {
                                                image_select = null;
                                              });
                                            } else {
                                              File? result = await controls.Image_Select();
                                              setState(() {
                                                image_select = result;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.button_color),
                                            child: Center(
                                              child: image_select != null
                                                  ? Text(
                                                      '사진 제거',
                                                      style: TextStyle(color: widget.font_color),
                                                    )
                                                  : Text(
                                                      '사진 등록',
                                                      style: TextStyle(color: widget.font_color),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(border: Border(left: BorderSide(width: 2, color: Colors.black))),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: EdgeInsets.all(1),
                                          child: TextField(
                                            onChanged: (text) {
                                              setState(() {
                                                review_text = text;
                                              });
                                            },
                                            maxLength: 100,
                                            maxLines: 5,
                                            controller: review,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(),
                                                hintMaxLines: 5,
                                                hintText: login_state ? '불적절한 언어가 포함될 시 리뷰가 삭제될 수 있습니다.' : '로그인이 필요한 서비스 입니다'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          decoration: BoxDecoration(border: Border(top: BorderSide(width: 2, color: Colors.black))),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    if (login_state) {
                                                      message_num = 1;
                                                    } else {
                                                      message_num = 2;
                                                    }
                                                    if (review_text.length < 6) {
                                                      message_num = 3;
                                                    }
                                                  });
                                                  if (message_num == 1) {
                                                    await controls.Upload_Review(review_text, image_select, widget.menu_name);
                                                    setState(() {
                                                      image_select = null;
                                                      review.text = '';
                                                    });
                                                  }
                                                  Review_Message(message_num);
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.button_color),
                                                  child: Center(
                                                    child: Text(
                                                      '등록',
                                                      style: TextStyle(color: widget.font_color),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 3, color: widget.button_color!))),
                          child: Center(
                            child: Text(
                              '리뷰',
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        Column(
                          children: reviews.values.toList(),
                        )
                      ],
                    ),
                  ),
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
