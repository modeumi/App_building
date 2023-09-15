import 'package:eat_today/Controller/Data_controller.dart';
import 'package:eat_today/Screen/view_screen.dart';
import 'package:flutter/material.dart';

class entire_screen extends StatefulWidget {
  final Color? button_color;
  final Color? back_color;
  final Color? font_color;

  entire_screen(this.button_color, this.font_color, this.back_color);

  Entire_Screen createState() => Entire_Screen();
}

class Entire_Screen extends State<entire_screen> {
  bool load = false;
  Controls controls = Controls();
  Map<String, Widget> menus = {};
  Map<String, Widget> select_menus = {};

  @override
  void initState() {
    super.initState();
    Load_Data();
  }

  Future<void> Load_Data() async {
    await Load_Menu();
    setState(() {
      load = true;
    });
  }

  Future<void> Load_Menu() async {
    List<String> all_menu = await controls.Load_AllMenu();
    for (String menu in all_menu) {
      menus[menu] = GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => view_screen(widget.back_color, widget.button_color, widget.font_color, menu)));
        },
        child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: widget.button_color),
          child: Center(
            child: Text(
              menu,
              style: TextStyle(color: widget.font_color, fontSize: 20, decoration: TextDecoration.none),
            ),
          ),
        ),
      );
    }
    select_menus = menus;
  }

  void Search_Menu(String keyword) {
    select_menus = {};
    menus.forEach((key, value) {
      if (key.contains(keyword)) {
        setState(() {
          select_menus[key] = value;
        });
      }
    });
    if (keyword == '') {
      select_menus = menus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: widget.back_color,
        ),
        child: load
            ? Column(
                children: [
                  Text(
                    '전체 메뉴',
                    style: TextStyle(color: widget.font_color, fontSize: 30, decoration: TextDecoration.none),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(border: Border.all(color: widget.button_color!, width: 3), borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.07,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(color: Colors.white),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(hintText: '메뉴 검색', border: InputBorder.none),
                              onChanged: (text) {
                                setState(() {
                                  print(text);
                                  Search_Menu(text);
                                });
                              },
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: select_menus.values.toList(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            : Align(
                alignment: Alignment(0, 0),
                child: CircularProgressIndicator(
                  color: widget.button_color,
                ),
              ),
      ),
    );
  }
}
