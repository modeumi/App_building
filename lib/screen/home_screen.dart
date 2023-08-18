import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tamer/screen/main_screen.dart';
import 'package:tamer/model/user_information.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  OverlayEntry? select_user;
  OverlayEntry? messege;
  OverlayEntry? delete_overlay;
  OverlayEntry? complete;
  TextEditingController inputtext = TextEditingController();
  Map<String, Widget> slot = {};
  Map<String, bool> slot_on = {};
  Map<String, bool> select_slot = {};
  late user_information user_on;
  String name = '';
  int id = 0;
  int select_id = 0;
  bool delete_character = false;
  bool click_1 = true;
  bool click_2 = true;
  bool click_3 = true;
  late AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  //데이터 관련 객체들
  List<Map<String, dynamic>> _dataList = [];
  List<int> _selectid = [];
  List<Map<String, dynamic>> _id_to_data = [];
  List<Map<String, dynamic>> select_one_data = [];

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 5; i++) {
      slot_on['slot_$i'] = false;
      select_slot['slot_$i'] = false;
    }
    audioPlayer.open(Audio('asset/audio/home.mp3'),
        loopMode: LoopMode.single, autoStart: true, showNotification: false);
    _loadData();
    _selectId();
  }

  Future<Database> _initeDB() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, 'tamer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tamer(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        level INTEGER DEFAULT '1',
        inventory_name TEXT DEFAULT 'slime,nomal',
        inventory_amount TEXT DEFAULT '10,200',
        souls_name TEXT DEFAULT 'slime',
        souls_level TEXT DEFAULT '1',
        map_name TEXT DEFAULT '',
        map_clear TEXT DEFAULT '',
        pick_count INTEGER DEFAULT '0',
        exp INTEGER DEFAULT '0',
        save_time TEXT DEFAULT CURRENT_TIMESTAMP)
        ''');
      },
    );
  }

  // 데이터 로드
  Future<void> _loadData() async {
    final db = await _initeDB();
    final datalist = await db.query('tamer');
    setState(() {
      _dataList = datalist;
    });
  }

  // id에 맞는 데이터만 고르기
  Future<void> _loadUserData(int id) async {
    final db = await _initeDB();
    final datalist = await db.query('tamer', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _id_to_data = datalist;
    });
  }

  // 전체 데이터에서 id만 가져오기
  Future<void> _selectId() async {
    final db = await _initeDB();
    final datalist = await db.query('tamer', columns: ['id']);
    final idList = datalist.map((element) => element['id'] as int).toList();
    setState(() {
      _selectid = idList;
      print('셀렉 아이디 : $_selectid');
      for (int i = 1; i <= _selectid.length; i++) {
        slot_on['slot_$i'] = true;
        select_slot['slot_$i'] = false;
      }
    });
  }

  //데이터 추가
  Future<void> _addData(String name) async {
    final db = await _initeDB();
    await db.insert('tamer',{'name': name,},);
    setState(() {
      inputtext.clear();
    });
    await _selectId();
    await _loadData();
  }

  // 데이터 삭제
  Future<void> _deleteData(int id, int slot_id) async {
    final db = await _initeDB();
    await db.delete('tamer', where: 'id=?', whereArgs: [id],);
    setState(() {
      for (String key in slot_on.keys) {
        slot_on[key] = false;
      }
      slot.clear();
      select_one_data.clear();
    });
    await _selectId();
    await _loadData();
  }

// 데이터 변형 (자르기)
  void _filter(int id) {
    select_one_data =
        _dataList.where((element) => element['id'] == id).toList();
  }

// 유저 데이터 불러서 형태변형
  Future<void> conversion(List<Map<String, dynamic>> info) async {
    Map<String, int> inven = {};
    Map<String, int> souls = {};
    Map<String, bool> map = {};
    List<String> map_name = [];
    List<String> map_clear = [];
    // 인벤토리 형변환 설정 (list화)
    List<String> inven_name = info[0]['inventory_name'].split(',');
    String inven_am_st = info[0]['inventory_amount'];
    List<int> inven_amount = inven_am_st.split(',').map((value) => int.parse(value.trim())).toList();
    // 소울 형변환 설정 (list화)
    List<String> souls_name = info[0]['souls_name'].split(',');
    String souls_level_st = info[0]['souls_level'];
    List<int> souls_level = souls_level_st.split(',').map((value) => int.parse(value.trim())).toList();

    // 맵 형변환 설정 (list화)
    if (info[0]['map_name'] != '') {
      map_name = info[0]['map_name'].split(',');
    }
    if (info[0]['map_clear'] != '') {
      map_clear = info[0]['map_clear'].split(',');
    }

    //인벤토리 Map 화
    for (int i = 0; i < inven_name.length; i++) {
      inven['${inven_name[i]}'] = inven_amount[i];
    }
    // 소울 Map 화
    for (int i = 0; i < souls_name.length; i++) {
      souls['${souls_name[i]}'] = souls_level[i];
      print('확인용 : $souls');
    }
    // 맵 Map 화
    for (int i = 0; i < map_name.length; i++) {
      if(map_clear[i] == 'true'){
      map['${map_name[i]}'] = true;
      }else{
      map['${map_name[i]}'] = false;
      }
    }
    user_on = user_information(info[0]['id'], info[0]['name'], info[0]['level'],
        inven, souls, map, info[0]['pick_count'], info[0]['exp']);
  }

  // 캐릭터 생성 완료
  Future<void> mission_complete(BuildContext context, String messege) async {
    complete = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('asset/image/state_panel3.png'),
          )),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 5,
          child: Center(
            child: Text(
              '${messege} 완료!',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(complete!);
    await Timer(Duration(seconds: 1), () {
      complete!.remove();
    });
  }

  // 데이터 선택 슬롯
  // slot_on 의 객체들이 true냐 false 냐에 따라 다른 화면을 띄워줄것
  void SelectSlot(BuildContext context) {
    for (int i = 1; i <= slot_on.length; i++) {
      if (!slot_on['slot_$i']!) {
        slot['slot_$i'] = GestureDetector(
          onTap: () {
            if(click_2){
            select_user!.remove();
            Messeges(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height / 8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('asset/image/new_user.png'),
                    fit: BoxFit.fill)),
          ),
        );
      } else if (slot_on['slot_$i']!) {
        _filter(_selectid[i - 1]);
        slot['slot_$i'] = GestureDetector(
          onTap: () {
            if(click_2) {
              setState(() {
                select_slot.forEach((key, value) {
                  select_slot[key] = false;
                });
                select_slot['slot_$i'] = true;
                id = _selectid[i - 1];
                select_id = i;
              });
              SelectSlot(context);
              select_user!.remove();
              SelectUser(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width / 2.2,
            height: MediaQuery.of(context).size.height / 8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: select_slot['slot_$i']!
                        ? AssetImage('asset/image/choise_slot.png')
                        : AssetImage('asset/image/state_panel3.png'),
                    fit: BoxFit.fill)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${select_one_data[0]['name']} \n등급 : ${select_one_data[0]['level']}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                Text(
                  '마지막 저장 - \n ${select_one_data[0]['save_time'].split(' ')[0]}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  // 삭제 창
  void DeleteWidget(BuildContext context, int id, int select_id) {
    delete_overlay = OverlayEntry(
        builder: (context) => Align(
              alignment: Alignment(0, 0),
              child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/image/state_panel.png'),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: EdgeInsets.all(13),
                    child: Column(
                      children: [
                        Text(
                          ' 정말 캐릭터를 \n삭제하겠습니까?',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() async {
                                    await _deleteData(id, select_id);
                                    await mission_complete(context, '삭제');
                                    SelectSlot(context);
                                    select_user!.remove();
                                    delete_overlay!.remove();
                                    Timer(Duration(milliseconds: 1200), () {
                                    click_1 = true;
                                    click_2 = true;
                                    });
                                  });
                                },
                                child: Image.asset(
                                  'asset/image/okay_button.png',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  delete_overlay!.remove();
                                  setState(() {
                                    click_2 = true; 
                                  });
                                },
                                child: Image.asset(
                                  'asset/image/cancel_button.png',
                                  fit: BoxFit.fitWidth,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ));
    Overlay.of(context).insert(delete_overlay!);
  }

//  선택창 틀
  void SelectUser(BuildContext context) {
    select_user = OverlayEntry(
        builder: (context) => Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Container(
                    color: Colors.blue,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: slot.values.toList(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if(click_2){
                                    await _loadUserData(id);
                                    await conversion(_id_to_data);
                                    if (id != 0) {
                                      audioPlayer.stop();
                                      select_user?.remove();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Main_screen(user_on)));
                                    }
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          'asset/image/okay_button.png'),
                                      fit: BoxFit.fill,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(click_2){
                                      setState(() {
                                        click_2 = false;
                                      });
                                    DeleteWidget(context, id, select_id);
                                    SelectSlot(context);
                                    }
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 8,
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          'asset/image/delete_button.png'),
                                      fit: BoxFit.fill,
                                    )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                )
              ],
            ));
    Overlay.of(context).insert(select_user!);
  }

  void Messeges(BuildContext context) {
    messege = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment(0, 0),
        child: Container(
          color: Colors.blue,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Material(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: TextField(
                      controller: inputtext,
                      maxLength: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(hintText: '이름 입력(최대 8자)'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() async {
                    await _addData(inputtext.text);
                    SelectSlot(context);
                    await mission_complete(context, '생성');
                    messege?.remove();
                    Timer(Duration(milliseconds: 1200), () {
                    click_1 = true;
                    });
                  });
                },
                child: Image.asset('asset/image/create_button.png'),
              ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(messege!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if(click_1){
              SelectSlot(context);
              SelectUser(context);
              setState(() {
                click_1 = false;
              });
              }
            },
            child: Image.asset(
              'asset/image/first_back.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/image/logo_2.png',
                  height: 150,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(0.0, 0.7),
            child: Text(
              '> 빈곳을 눌러 게임 시작 <',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
