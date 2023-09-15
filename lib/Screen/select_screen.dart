import 'dart:async';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Screen/entire_screen.dart';
import 'package:eat_today/Screen/view_screen.dart';
import 'package:flutter/material.dart';

class select_screen extends StatefulWidget {
  final Color? back_color;
  final Color? button_color;
  final Color? font_color;

  select_screen(this.back_color, this.button_color, this.font_color);

  Select_Screen createState() => Select_Screen();
}

class Select_Screen extends State<select_screen> {
  Controls controls = Controls();

  Map<String, Widget> categories = {};
  Map<String, Widget> categories_view = {};
  Map<String, bool> categories_bool = {};
  List<String> category = [];
  String search_category = '';

  Map<String, Widget> types = {};
  Map<String, Widget> types_view = {};
  Map<String, bool> types_bool = {};
  List<String> type = [];
  String search_type = '';

  Map<String, Widget> times = {};
  Map<String, bool> times_bool = {};
  List<String> eattime = [];

  OverlayEntry? addmenu;
  Map<String, String> select_set = {};
  Map<String, Widget> select_result = {};
  double containerHeight = 0;
  bool page_load = false;
  bool load_success = false;

  OverlayEntry? select_viewer;
  OverlayEntry? false_select;
  OverlayEntry? all_select;
  List<OverlayEntry> overlays = [];

  @override
  void initState() {
    super.initState();
    Load_data();
  }

  void Load_data() async {
    category = await controls.GetCategory();
    for (String name in category) {
      categories_bool[name] = false;
    }
    eattime = await controls.GetEatTime();
    for (String time in eattime) {
      times_bool[time] = false;
    }
    type = await controls.GetEatType();
    for (String ty in type) {
      types_bool[ty] = false;
    }
    await View_Category();
    await View_Time();
    await View_Type();
    setState(() {
      page_load = true;
    });
  }

  void False_Select(BuildContext context) {
    false_select = OverlayEntry(
        builder: (context) =>Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0)
          ),
          child:Center(
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.15,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      '한가지 이상의 조건을\n선택해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) );
    Overlay.of(context).insert(false_select!);
    Timer(Duration(seconds: 1), () {
      false_select!.remove();
    });
  }

  void Select_Viewer(BuildContext context) {
    select_viewer = OverlayEntry(
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
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // 색상
                    spreadRadius: 5, // 음영 범위
                    blurRadius: 7, // 블러 범위
                    offset: Offset(0, 3), // 음영 위치
                  )
                ],
              ),
              child: load_success
                  ? Column(
                      children: [
                        Text(
                          '검색 결과',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30, color: Colors.black, decoration: TextDecoration.none),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SingleChildScrollView(
                            child: Column(children: select_result.values.toList()),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.button_color,
                            ),
                            onPressed: () {
                              select_viewer!.remove();
                              overlays.remove(select_viewer!);
                            },
                            child: Text(
                              '닫기',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: widget.font_color),
                            ))
                      ],
                    )
                  : Container(
                      child: Align(
                        alignment: Alignment(0, 0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
            )),
          );
        },
      ),
    );
    overlays.add(select_viewer!);
    Overlay.of(context).insert(select_viewer!);
  }

  void Search_Category(String keyword) {
    categories_view = {};
    categories.forEach((key, value) {
      if (key.contains(keyword)) {
        setState(() {
          categories_view[key] = value;
        });
      }
    });
    if (keyword == '') {
      categories_view = categories;
    }
  }

  void Search_Type(String keyword) {
    types_view = {};
    types.forEach((key, value) {
      if (key.contains(keyword)) {
        setState(() {
          types_view[key] = value;
        });
      }
    });
    if (keyword == '') {
      types_view = types;
    }
  }

  Future<void> View_Category() async {
    for (String name in category) {
      categories['$name'] = GestureDetector(
        onTap: () {
          setState(() {
            if (categories_bool[name]!) {
              select_set.remove('category');
              for (String cate in categories_bool.keys) {
                categories_bool[cate] = false;
              }
            } else {
              select_set['category'] = name;
              for (String cate in categories_bool.keys) {
                categories_bool[cate] = false;
              }
              categories_bool[name] = !categories_bool[name]!;
            }
          });
          View_Category();
        },
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              color: widget.button_color,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: categories_bool[name]! ? Colors.grey : Colors.white, width: categories_bool[name]! ? 3 : 0)),
          child: Text(
            name,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: widget.font_color,
            ),
          ),
        ),
      );
    }
    categories_view = categories;
  }

  Future<void> View_Time() async {
    for (String time in eattime) {
      times['$time'] = GestureDetector(
        onTap: () {
          setState(() {
            if (times_bool[time]!) {
              select_set.remove('eattime');
              for (String eat in times_bool.keys) {
                times_bool[eat] = false;
              }
            } else {
              select_set['eattime'] = time;
              for (String eat in times_bool.keys) {
                times_bool[eat] = false;
              }
              times_bool[time] = !times_bool[time]!;
            }
          });
          View_Time();
        },
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              color: widget.button_color,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: times_bool[time]! ? Colors.grey : Colors.white, width: times_bool[time]! ? 3 : 0)),
          child: Text(
            time,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: widget.font_color,
            ),
          ),
        ),
      );
    }
  }

  Future<void> View_Type() async {
    for (String name in type) {
      types['$name'] = GestureDetector(
        onTap: () {
          setState(() {
            if (types_bool[name]!) {
              select_set.remove('eattype');
              for (String type_name in types_bool.keys) {
                types_bool[type_name] = false;
              }
            } else {
              select_set['eattype'] = name;
              for (String type_name in types_bool.keys) {
                types_bool[type_name] = false;
              }
              types_bool[name] = !types_bool[name]!;
            }
          });
          View_Type();
        },
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              color: widget.button_color,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: types_bool[name]! ? Colors.grey : Colors.white, width: types_bool[name]! ? 3 : 0)),
          child: Text(
            name,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 25,
              color: widget.font_color,
            ),
          ),
        ),
      );
    }
    types_view = types;
  }

  Future<void> Select_Result(Map<String, String> result) async {
    List<String> results = await controls.Select_Set(result);
    select_result = {};
    for (String key in results) {
      select_result[key] = GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => view_screen(widget.back_color, widget.button_color, widget.font_color, key)));
          select_viewer!.remove();
          overlays.remove(select_viewer!);
        },
        child: Container(
          margin: EdgeInsets.all(5),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height / 15,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            color: widget.button_color,
          ),
          child: Center(
            child: Text(
              key,
              textAlign: TextAlign.center,
              style: TextStyle(color: widget.font_color, fontSize: 20, decoration: TextDecoration.none),
            ),
          ),
        ),
      );
    }
    setState(() {
      load_success = true;
    });
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
        child: page_load
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: widget.back_color,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
                child: Column(
                  children: [
                    Text(
                      '메뉴 골라보기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: widget.font_color,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: containerHeight,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: widget.button_color!, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '카테고리',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 3)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: TextField(
                                  maxLines: 1,
                                  decoration: InputDecoration(hintText: '카테고리 검색'),
                                  onChanged: (text) {
                                    setState(() {
                                      search_category = text;
                                      Search_Category(search_category);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: categories_view.values.toList(),
                                ),
                              ),
                            ),
                            Text(
                              '식사 시간',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 3)),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.2,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: times.values.toList(),
                                ),
                              ),
                            ),
                            Text(
                              '식사 타입',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 3)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: TextField(
                                  maxLines: 1,
                                  decoration: InputDecoration(hintText: '타입 검색'),
                                  onChanged: (text) {
                                    setState(() {
                                      search_type = text;
                                      Search_Type(search_type);
                                    });
                                  },
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 2)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: types_view.values.toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                              onPressed: () async {
                                if (!select_set.isEmpty) {
                                  await Select_Result(select_set);
                                  Select_Viewer(context);
                                } else {
                                  False_Select(context);
                                }
                              },
                              child: Text(
                                '결과보기',
                                style: TextStyle(
                                  color: widget.font_color,
                                ),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: widget.button_color),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => entire_screen(widget.button_color, widget.font_color, widget.back_color)));
                              },
                              child: Text(
                                '전체보기',
                                style: TextStyle(color: widget.font_color),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(
                decoration: BoxDecoration(color: widget.back_color),
                child: Align(
                  alignment: Alignment(0, 0),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
