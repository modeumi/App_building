import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_today/Data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Controls {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final FirebaseStorage fstorage = FirebaseStorage.instance;

  // 로그인
  Future<dynamic> Login(String email, String pass, bool autologin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: pass);
      DocumentSnapshot usersnapshot = await store.collection('user').doc(userCredential.user!.uid).get();
      Map<String, dynamic> userdata = usersnapshot.data() as Map<String, dynamic>;
      if (autologin) {
        preferences.setBool('autologin', autologin);
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'password', value: pass);
      }

      UserData user = UserData(userdata['email'], userdata['nickname'], userdata['gender'], userdata['birth'], userdata['backcolor'],
          userdata['buttoncolor'], userdata['level']);
      return user;
    } catch (e) {
      print('에러 정보 : $e');
      return false;
    }
  }

  // 정보 변경을 위한 비밀번호 체크
  Future<bool> Password_Check(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      return true;
    } catch (e) {
      return false;
    }
  }

  // 회원가입시 이메일 중복 체크
  Future<bool> Duplication_Email(String email) async {
    List<String> emaillist = [];
    try {
      QuerySnapshot querySnapshot = await store.collection('user').get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        emaillist.add(data['email']);
      });
      return !emaillist.contains(email);
    } catch (e) {
      print('에러 : $e');
      return false;
    }
  }

  // 회원가입 시 입력한 정보 확인
  String Join_Us(Map<String, bool> state) {
    List<String> check_list = ['email', 'email_check', 'pass', 'pass_check', 'nickname', 'gender', 'birth', 'phone'];
    for (String check in check_list) {
      if (!state.containsKey(check)) {
        return check;
      }
    }
    for (String check in state.keys) {
      if (!state[check]!) {
        return check;
      }
    }
    return 'success';
  }

  // 회원가입
  Future<void> Join(String email, String pass, String nickname, String gender, String birth) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: pass);
      String uid = userCredential.user!.uid;

      await store.collection('user').doc(uid).set({
        'email': email,
        'nickname': nickname,
        'gender': gender,
        'birth': birth,
        'backcolor': 1,
        'buttoncolor': 1,
        'level': 'member',
      });
    } catch (e) {
      print('에러 : $e');
    }
  }

  // 정보 변경시 변경된 정보 확인
  bool Change_Check(Map<String, bool> state) {
    List<String> check_list = ['pass', 'pass_check', 'nickname'];
    for (String check in check_list) {
      if (!state.containsKey(check)) {
        return false;
      } else {
        if (!state[check]!) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> Change_Information(String email, String nickname, String pass) async {
    try {
      User currentuser = auth.currentUser!;
      await currentuser.updatePassword(pass);
      await store.collection('user').doc(currentuser.uid).update({'nickname': nickname});
      await Logout();
    } catch (e) {}
  }

  Future<void> Logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    await storage.deleteAll();
    await auth.signOut();
  }

  Future<dynamic> autoLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? loginstate = preferences.getBool('autologin');
    if (loginstate != null) {
      if (loginstate) {
        try {
          String email = await storage.read(key: 'email') as String;
          String password = await storage.read(key: 'password') as String;
          dynamic result = await Login(email, password, true);
          UserData user = result;
          return user;
        } catch (e) {}
      }
    } else {
      return null;
    }
  }

  Future<void> Color_Change(int back_color, int button_color) async {
    User currentuser = auth.currentUser!;
    await store.collection('user').doc(currentuser.uid).update({'backcolor': back_color});
    await store.collection('user').doc(currentuser.uid).update({'buttoncolor': button_color});
  }

  Future<List<String>> GetCategory() async {
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      Set<String> categories = Set();
      querySnapshot.docs.forEach((element) {
        String category = element.get('category');
        categories.add(category);
      });
      return categories.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> GetEatTime() async {
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      Set<String> times = Set();
      querySnapshot.docs.forEach((element) {
        List<dynamic> time = element.get('eattime');
        for (String time_text in time) {
          times.add(time_text.toString());
        }
      });
      print('타임 결과물 : $times');
      return times.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> GetEatType() async {
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      Set<String> types = Set();
      querySnapshot.docs.forEach((element) {
        String type = element.get('eattype');
        types.add(type);
      });
      print('타입 결과물 : $types');
      return types.toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> Menu_Duplication(String name) async {
    List<String> doc_name = [];
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      querySnapshot.docs.forEach((element) {
        doc_name.add(element.id);
      });
      if (!doc_name.contains(name)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> Check_login() async {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> Menu_Add(Map<String, dynamic> menu) async {
    List<String> menu_name = [];
    try {
      if (await Menu_Duplication(menu['name'])) {
        String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
        Reference reference = fstorage.ref().child('main/$filename');
        await reference.putFile(menu['image']);
        await store.collection('menu').doc(menu['name']).set(
            {'category': menu['category'], 'eattype': menu['eattype'], 'eattime': menu['eattime'], 'comment': menu['comment'], 'imageurl': filename});
      } else {
        if (menu.containsKey('image')) {
          String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
          Reference reference = fstorage.ref().child('main/$filename');
          await reference.putFile(menu['image']);
          reference = fstorage.ref().child('main/${menu['oldimage']}');
          await reference.delete();
          await store.collection('menu').doc(menu['name']).update({
            'category': menu['category'],
            'eattype': menu['eattype'],
            'eattime': menu['eattime'],
            'comment': menu['comment'],
            'imageurl': filename
          });
        } else {
          await store.collection('menu').doc(menu['name']).update({
            'category': menu['category'],
            'eattype': menu['eattype'],
            'comment': menu['comment'],
            'eattime': menu['eattime'],
          });
        }
      }

      bool dupl = await Menu_Duplication(menu['name']);
      return !dupl;
    } catch (e) {
      print('에러 : $e');
      return false;
    }
  }

  Future<void> Menu_Request(Map<String, dynamic> menu) async {
    bool check = await Check_login();
    if (check) {
      try {
        String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
        Reference reference = fstorage.ref().child('main/$filename');
        reference.putFile(menu['image']);
        await store.collection('request').add({
          'writer': menu['writer'],
          'name': menu['name'],
          'category': menu['category'],
          'eattype': menu['type'],
          'eattime': menu['time'],
          'comment': menu['comment'],
          'imageurl': filename
        });
      } catch (e) {
        print('에러 : $e');
      }
    } else {
      print('로그인 상태 아님 ');
    }
  }

  Future<void> Add_Inquiry(Map<String, dynamic> inquiry) async {
    bool check = await Check_login();
    if (check) {
      String filename = '';
      try {
        if (inquiry.containsKey('image')) {
          filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
          Reference reference = fstorage.ref().child('inquiry/$filename');
          reference.putFile(inquiry['image']);
        }
        await store.collection('inquiry').add({
          'answer': '',
          'writer': inquiry['writer'],
          'title': inquiry['title'],
          'content': inquiry['content'],
          'imageurl': filename,
          'time': DateTime.now().toString().split('.').first
        });
      } catch (e) {
        print('에러 : $e');
      }
    } else {
      print('로그인 상태 아님 ');
    }
  }

  Future<Map<String, dynamic>> Load_Menu() async {
    Map<String, dynamic> menus = {};
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      querySnapshot.docs.forEach((element) {
        menus[element.id] = element.data();
      });

      return menus;
    } catch (e) {
      print('메뉴 호출 에러 내용 : $e');
      return menus;
    }
  }

  Future<String> Load_Main_Image(String name) async {
    try {
      Reference reference = fstorage.ref().child('main/${name}');
      String download = await reference.getDownloadURL();
      return download;
    } catch (e) {
      print('이미지 로드 : $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> Load_Member() async {
    Map<String, dynamic> member = {};
    try {
      QuerySnapshot querySnapshot = await store.collection('user').get();
      querySnapshot.docs.forEach((element) {
        member[element.id] = element.data();
      });
      return member;
    } catch (e) {
      print('멤버 호출 에러 : $e');
      return member;
    }
  }

  Future<List<String>> Select_Set(Map<String, String> set) async {
    List<String> result = [];
    try {
      Query<Map<String, dynamic>> filter = await store.collection('menu');

      if (set.containsKey('category')) {
        filter = filter.where('category', isEqualTo: set['category']);
      }
      if (set.containsKey('eattime')) {
        filter = filter.where('eattime', arrayContains: set['eattime']);
      }
      if (set.containsKey('eattype')) {
        filter = filter.where('eattype', isEqualTo: set['eattype']);
      }

      QuerySnapshot fillter_success = await filter.get();

      fillter_success.docs.forEach((element) {
        result.add(element.id);
      });

      return result;
    } catch (e) {
      print('세팅호출 에러 :  $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> Select_menu(String name) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> document = await store.collection('menu').doc(name).get();
      final result = document.data();
      String url = await Load_Main_Image(result?['imageurl']);
      result?['imageurl'] = url;
      return result ?? {};
    } catch (e) {
      print('메뉴 선택 에러 :$e');
      return {};
    }
  }

  Future<void> Upload_Review(String message, dynamic image, String name) async {
    bool check = await Check_login();
    String filename = '';
    if (check) {
      try {
        User? user = auth.currentUser;
        String uid = user!.uid;
        String upload_time = DateFormat('yyyyMMddHHmmssSSSS').format(DateTime.now());
        if (image != null) {
          filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
          Reference reference = fstorage.ref().child('review/$filename');
          reference.putFile(image);
        }
        await store.collection('review').add({'image': filename, 'text': message, 'time': upload_time, 'user': uid, 'menu': name});
      } catch (e) {
        print('리뷰 등록 에러 : $e');
      }
    } else {
      print('로그인 상태 아님');
    }
  }

  Future<Map<String, dynamic>> Load_Review(String name) async {
    try {
      Map<String, dynamic> reviews = {};
      Query<Map<String, dynamic>> filter = await store.collection('review').where('menu', isEqualTo: name);
      QuerySnapshot querySnapshot = await filter.get();
      querySnapshot.docs.forEach((element) {
        reviews[element.id] = element.data();
      });
      for (String docu in reviews.keys) {
        if (reviews[docu]['image'] != '') {
          try {
            Reference reference = await fstorage.ref().child('review/${reviews[docu]['image']}');
            String download = await reference.getDownloadURL();
            reviews[docu]['image'] = download;
          } catch (j) {}
        }
      }
      return reviews;
    } catch (e) {
      print('리뷰 로드 에러 : $e');
      return {};
    }
  }

  Future<String> Get_UID() async {
    User? user = auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      return uid;
    } else {
      return '';
    }
  }

  Future<bool> Update_Review(String document, String text, File? image, bool state) async {
    try {
      bool check = await Check_login();
      if (check) {
        // 전 사진 제거 했을 경우
        if (state) {
          // 사진을 정보에서 제거
          DocumentSnapshot documentSnapshot = await store.collection('review').doc(document).get();
          if (documentSnapshot['image'] != '') {
            String imagename = documentSnapshot['image'];
            Reference reference = fstorage.ref().child('review/$imagename');
            await reference.delete();
          }
          // 전 사진 제거 하고 새로운 사진 올렷을 경우
          if (image != null) {
            String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
            Reference reference = fstorage.ref().child('review/$filename');
            reference.putFile(image);

            await store.collection('review').doc(document).update({
              'text': text,
              'image': filename,
            });
          } else {
            // 전 사진 제가 하고 새로운 사진 없이 텍스트만 변경했을경우
            await store.collection('review').doc(document).update({
              'image': '',
              'text': text,
            });
          }
          // 전사진이 없어서 새로운 사진을 올리거나 텍스트만 변경했을경우
        }else{
          // 새로운 사진을 올렷을 경우
          if (image != null) {
            String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
            Reference reference = fstorage.ref().child('review/$filename');
            reference.putFile(image);
            await store.collection('review').doc(document).update({
              'text': text,
              'image': filename,
            });
            // 텍스트만 변경했을 경우
          }else{
            await store.collection('review').doc(document).update({
              'text': text,
            });
          }

        }
        return true;
      } else {
        print('로그인 상태 아님');
        return false;
      }
    } catch (e) {
      print('리뷰 업데이트 에러 : $e');
      return false;
    }
  }

  Future<void> Delete_Review(String document) async {
    try {
      bool check = await Check_login();
      if (check) {
        DocumentSnapshot documentSnapshot = await store.collection('review').doc(document).get();
        String imagename = documentSnapshot['image'];
        if (imagename != '') {
          Reference reference = fstorage.ref().child('review/$imagename');
          await reference.delete();
        }
        await store.collection('review').doc(document).delete();
      }
    } catch (e) {
      print('리뷰 삭제 에러 : $e');
    }
  }

  Future<void> Delete_menu(String document) async {
    try {
      bool check = await Check_login();
      if (check) {
        DocumentSnapshot documentSnapshot = await store.collection('menu').doc(document).get();
        String imagename = documentSnapshot['imageurl'];
        if (imagename != '') {
          Reference reference = fstorage.ref().child('main/$imagename');
          await reference.delete();
        }
        await store.collection('menu').doc(document).delete();
      }
    } catch (e) {
      print('리뷰 삭제 에러 : $e');
    }
  }

  Future<File?> Image_Select() async {
    final ImagePicker imagePicker = ImagePicker();
    final file_select = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file_select != null) {
      if (file_select.path.endsWith('.jpg') || file_select.path.endsWith('.jpeg') || file_select.path.endsWith('.png')) {
        return File(file_select.path);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> Delete_User(String uid) async {
    try {
      QuerySnapshot querySnapshot = await store.collection('review').where('user', isEqualTo: uid).get();
      querySnapshot.docs.forEach((element) async {
        await Delete_Review(element.id);
      });
      await store.collection('user').doc(uid).delete();
      final user = await auth.currentUser;
      if (user != null) {
        user.delete();
        await Logout();
      }
    } catch (e) {
      print('유저 삭제 에러 : $e');
    }
  }

  Future<List<String>> Load_AllMenu() async {
    List<String> result = [];
    try {
      QuerySnapshot querySnapshot = await store.collection('menu').get();
      querySnapshot.docs.forEach((element) {
        result.add(element.id);
      });
      return result;
    } catch (e) {
      print('전체 메뉴 호출 에러 : $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> Load_AllReview() async {
    Map<String, dynamic> result = {};
    try {
      QuerySnapshot querySnapshot = await store.collection('review').get();
      querySnapshot.docs.forEach((element) {
        result[element.id] = element.data();
      });
      return result;
    } catch (e) {
      print('전체 리뷰 호출 에러 : $e');
      return {};
    }
  }

  Future<String> Load_Review_Image(String name) async {
    try {
      Reference reference = fstorage.ref().child('review/${name}');
      String download = await reference.getDownloadURL();
      return download;
    } catch (e) {
      print('이미지 로드 : $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> Load_AllInquiry() async {
    Map<String, dynamic> result = {};
    try {
      QuerySnapshot querySnapshot = await store.collection('inquiry').get();
      querySnapshot.docs.forEach((element) {
        result[element.id] = element.data();
      });
      return result;
    } catch (e) {
      print('전체 리뷰 호출 에러 : $e');
      return {};
    }
  }

  Future<String> Randum_Menu() async {
    try {
      List<String> menus = await Load_AllMenu();
      int ran = Random().nextInt(menus.length);
      String menu = menus[ran];
      return menu;
    } catch (e) {
      print('랜덤 호출 에러 : $e');
      return '';
    }
  }

  Future<bool> Admin_Change_Information(String uid, String name, String level) async {
    try {
      await store.collection('user').doc(uid).update({'nickname': name, 'level': level});
      return true;
    } catch (e) {
      print('유저 정보 변경 에러 : $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> Load_Inquiry(String email) async {
    try {
      Map<String, dynamic> result = {};
      QuerySnapshot querySnapshot = await store.collection('inquiry').where('writer', isEqualTo: email).get();
      querySnapshot.docs.forEach((element) {
        result[element.id] = element;
      });
      return result;
    } catch (e) {
      print('문의 내역 호출 에러 : $e ');
      return {};
    }
  }

  Future<String> Load_Inquiry_Image(String name) async {
    try {
      Reference reference = fstorage.ref().child('inquiry/${name}');
      String download = await reference.getDownloadURL();
      return download;
    } catch (e) {
      print('이미지 로드 에러 : $e');
      return '';
    }
  }

  Future<void> Change_Inquiry(Map<String, dynamic> change) async {
    try {
      if (change.containsKey('image')) {
        DocumentSnapshot documentSnapshot = await store.collection('inquiry').doc(change['docid']).get();
        String imagename = documentSnapshot['imageurl'];
        if (imagename != '') {
          Reference reference = fstorage.ref().child('inquiry/$imagename');
          await reference.delete();
        }
        if (change['image'] == '') {
          await store.collection('inquiry').doc(change['docid']).update({'imageurl': ''});
        } else {
          String filename = DateTime.now().microsecondsSinceEpoch.toString() + '.jpg';
          Reference reference = fstorage.ref().child('inquiry/$filename');
          reference.putFile(change['image']);

          await store.collection('inquiry').doc(change['docid']).update({'imageurl': filename});
        }
      }

      if (change.containsKey('content')) {
        await store.collection('inquiry').doc(change['docid']).update({'content': change['content']});
      }
    } catch (e) {
      print('문의 변경 에러 :$e');
    }
  }

  Future<void> Insert_Answer(String docid, String text) async {
    await store.collection('inquiry').doc(docid).update({
      'answer': text,
    });
    print('답변 등록완료');
  }

  Future<Map<String, dynamic>> Load_Menu_Request() async {
    Map<String, dynamic> result = {};
    try {
      QuerySnapshot querySnapshot = await store.collection('request').get();
      querySnapshot.docs.forEach((element) {
        result[element.id] = element.data();
      });
      return result;
    } catch (e) {
      print('요청 호출 에러 : $e');
      return {};
    }
  }

  Future<void> Delete_Request(String docid) async {
    try {
      DocumentSnapshot documentSnapshot = await store.collection('request').doc(docid).get();
      String imagename = documentSnapshot['imageurl'];
      Reference reference = fstorage.ref().child('main/$imagename');
      await reference.delete();
      await store.collection('request').doc(docid).delete();
    } catch (e) {
      print('요청 삭제 에러 : $e');
    }
  }

  Future<String> Load_Request_Image(String name) async {
    try {
      Reference reference = fstorage.ref().child('main/${name}');
      String download = await reference.getDownloadURL();
      return download;
    } catch (e) {
      print('이미지 로드 에러 : $e');
      return '';
    }
  }

  Future<bool> Request_To_Menu(Map<String, dynamic> result) async {
    try {
      await store.collection('menu').doc(result['name']).set({
        'category': result['category'],
        'eattype': result['eattype'],
        'eattime': result['eattime'],
        'comment': result['comment'],
        'imageurl': result['image']
      });
      return true;
    } catch (e) {
      print('요청 메뉴 추가 에러 : $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> Get_Location() async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Map<String, dynamic> result = {'위도': position.latitude, '경도': position.longitude};
        return result;
      } else if (status.isDenied) {
        return {};
      }
      return {};
    } catch (e) {
      print('위치 에러 : $e');
      return {};
    }
  }

  Future<Set<Marker>> Get_Restaurants(String name) async {
    Set<Marker> makers = {};
    Map<String, dynamic> result_location = await Get_Location();
    String location = result_location.values.join(',');
    String radius = '1000';
    String keyword = name;
    String apikey = 'AIzaSyCiPd1vFtWr8oogxu3y2lX6TmaOhjxs2fM';
    final url =
        Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&keyword=$keyword&key=$apikey');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final List<dynamic> restaurant = data['results'];
    for (var rest in restaurant) {
      final name = rest['name'];
      final lat = rest['geometry']['location']['lat'];
      final lng = rest['geometry']['location']['lng'];
      makers.add(
        Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
        ),
      );
    }
    return makers;
  }
}
