import 'dart:math';

class User {
  int Hp = 40;
  int HpMax = 40;
  int defense = 40;
  int MpMax = 100;
  int Mp = 0;
  String activate = 'nomal';
  String survival = 'live';
  Map<String, dynamic> attack_info = {'attack_point': [], 'activate': {}};
  Map<String, int> buff_info = {};
  String Mp_leftover = '';


  User(int level) {
    HpMax += (5 * level).toInt();
    Hp = HpMax;
    defense += (2 * level).toInt();
    MpMax += 10 * level;
    Mp = MpMax;
  }

  void meditation() {
    buff_info['meditation'] = 1;
    defense += 40;
    Mp += 35;
    if (Mp > MpMax) {
      Mp = MpMax;
    }
  }

  void attack_process(String soul, int level) {
      Mp_leftover = '';
    if (soul == 'goblin') {
      if (Mp >= 20) {
        Mp -= 20;
        attack_info['attack_point']!.add(10+(2*level));
      } else {
        Mp_leftover = 'Empty';
      }
    } else if (soul == 'skeleton') {
      if (Mp >= 25) {
        Mp -= 25;
        attack_info['attack_point']!.add(8+(level));
        int ran = Random().nextInt(5)+1;
        if(ran ==1){
        attack_info['activate']!['stoncurse'] = 1;
        }
      } else {
        Mp_leftover = 'Empty';
      }
    } else if (soul == 'wolf') {
      if (Mp >= 25) {
        Mp -= 25;
        attack_info['attack_point']!.add(10+(2*level));
        int ran = Random().nextInt(5)+1;
        if(ran <=3){
        attack_info['activate']!['blooding'] = 2;
        }
      } else {
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'slime'){
      if(Mp >= 15){
        Mp -= 15;
        attack_info['attack_point']!.add(5+level);
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'bibat'){
      if(Mp >= 20){
        Mp -= 20;
        Hp += 2;
        if (Hp >= HpMax){
          Hp = HpMax;
        }
        attack_info['attack_point']!.add(5+level);
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'durahan'){
      if(Mp >= 25){
        Mp -= 25;
        attack_info['attack_point']!.add(15 +(2*level));
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'nepenthes'){
      if(Mp>= 15){
        Mp -= 15;
        attack_info['attack_point']!.add(7+level);
        int ran = Random().nextInt(5)+1;
        if( ran ==1){
          attack_info['activate']!['poisoned'] = 2;
        }
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'snakuble'){
      if (Mp >=20){
        Mp -=20;
        attack_info['attack_point']!.add(10+(2*level));
        int ran = Random().nextInt(5)+1;
        if (ran <=3){
        attack_info['activate']!['poisoned'] = 3;
        }
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'gargoyle'){
      if(Mp >=30){
        Mp -= 30;
        attack_info['attack_point']!.add(15+(2*level));
        int ran = Random().nextInt(5)+1;
        if(ran != 5){
        attack_info['activate']!['stoncurse'] = 1;
        }
      }else{
        Mp_leftover = 'Empty';
      }
    }else if (soul == 'woonst'){
      if(Mp >=30){
        Mp -= 30;
        attack_info['attack_point']!.add(15+(2*level));
        int ran = Random().nextInt(5)+1;
        if(ran !=5){
          attack_info['activate']!['blooding'] = 3;
        }
      }
    }
  }

  // 데미지 계산식 처리
  void damage_process(Map<String, dynamic> attack_infos) {
    int damage = 0;

    // attack의 수를 가져오서 방어력의 퍼센트로 차감하는 계산 + 계산 시작시 데미지는 0으로 초기화 후 누적
    if (attack_infos['attack_point'].isNotEmpty) {
      for (int damage_p in attack_infos['attack_point']) {
        damage += (damage_p - (damage_p * (defense / 100))).toInt();
      }
      Hp -= damage;
    }
    // survival 을 공격마다 체크해서 사망시 전투 종료
    if (Hp <= 0) {
      survival = 'death';
    }
    // 공격 계산이 끝난후에는 데미지 리스트를 초기화
    attack_infos['attack_point'].clear();
  }

  // infos 에 activate는 Map<String,int>의 형태
  void status_process(Map<String, dynamic> attack_infos) {
    if (attack_infos['activate']!.isEmpty) {
      activate = 'nomal';
      // activate에 상태이상이 있을시에 status(상태이상 처리 함수) 호출 후 턴수 차감, 턴수 0일시 제거
    } else {
      for (String state in attack_infos['activate'].keys) {
        Status(state);
        if (attack_infos['activate'][state] >= 1) {
          attack_infos['activate'][state] -= 1;
        } else {
          attack_infos['activate'].remove(state);
        }
      }
    }
      if (buff_info.isNotEmpty) {
        for (String buff in buff_info.keys) {
          if (buff_info[buff]! >= 1) {
            buff_info[buff] =  (buff_info[buff] ?? 0) - 1;
            if (buff_info[buff] == 0){
              if (buff == 'meditation'){
                defense -= 40;
              }
            }
          }
        }
        buff_info.removeWhere((key, value) => value == 0);
      }
    }



  // 상태 이상 처리 - 데미지나 진행불가 상태이상만 처리하고 턴수는 호출시 처리
  void Status(String state) {
    if (state == 'blooding') {
      Hp -= (HpMax / 8).toInt();
    } else if (state == 'poisoned') {
      Hp -= (HpMax / 10).toInt();
    } else if (state == 'burning') {
      Hp -= (HpMax / 12).toInt();
    } else if (state == 'stoncurse') {
      activate = 'stoncurse';
    } else if (state == 'frozen') {
      activate = 'frozen';
    } else if (state == 'fascination') {
      activate == 'fascination';
    } else if (state == 'stun') {
      activate == 'stun';
    } else {

    }
  }
}

