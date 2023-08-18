import 'dart:math';

class Monster_base {
  int Hp = 0;
  int HpMax = 0;
  int attack = 0;
  String attack_effect = '';
  int defense = 0;
  int damage = 0;
  String activate = 'nomal';
  String survival = 'live';

  //point 에는 숫자만 (데미지) activate 에는 String,int의 Map
  Map<String, dynamic> attack_info = {'attack_point': [], 'activate': {}};



  void damage_process(Map<String, dynamic> attack_infos) {
    int put_damage = 0;

    // attack의 수를 가져오서 방어력의 퍼센트로 차감하는 계산 + 계산 시작시 데미지는 0으로 초기화 후 누적
    if (attack_infos['attack_point'].isNotEmpty) {
      for (int damage_p in attack_infos['attack_point']) {
        put_damage += (damage_p - (damage_p * (defense / 100))).toInt();
      }
      Hp -= put_damage;
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
      activate = 'nomal';
    if (attack_infos['activate']!.isEmpty) {
    } else {
      for (String state in attack_infos['activate'].keys) {
      // activate에 상태이상이 있을시에 status(상태이상 처리 함수) 호출 후 턴수 차감, 턴수 0일시 제거
        Status(state);
        if (attack_infos['activate'][state] >= 1) {
          attack_infos['activate'][state] -= 1;
        }
      }
    }
      attack_infos['activate'].removeWhere((key, value) => value == 0);
  }

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
    }
  }
}

class Slime extends Monster_base {
  Slime(int level) {
    HpMax = (super.Hp + 10) + (5 * level);
    Hp = HpMax;
    attack = (super.attack + 3) + level;
    defense = (super.defense + 10) + (2 * level);
    attack_effect = 'poisoned';
  }

  void attack_process() {
    if (activate == 'nomal') {
      int attack_ran = Random().nextInt(10) + 1;
      damage = this.attack;
      if (attack_ran > 4) {
        attack_info['attack_point']!.add(damage);
      } else {
        attack_info['attack_point']!.add(damage);
        attack_info['activate'] = {attack_effect: 3};
      }
    }else{
      attack_info['attack_point']!.add(0);
    }
  }
}
