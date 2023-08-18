class user_information {
  late int user_id;
  late String user_name;
  late int user_level;
  late Map<String, int> user_inventory;
  late Map<String, int> user_souls;
  late Map<String, bool> user_clear;
  late int user_pick_count;
  late int user_exp;
  late int user_max_exp;

  user_information(int id,String name, int level, Map<String, int> inven,
      Map<String,int> souls, Map<String, bool> clear, int count, int exp) {
    user_id =id;
    user_name = name;
    user_level = level;
    user_inventory = inven;
    user_souls = souls;
    user_clear = clear;
    user_pick_count = count;
    user_exp = exp;
    for (int i = 1; i <= 50; i++) {
      if (user_level == i) {
        user_max_exp = 100 + (25 * i);
      }
    }
  }

  void levelup() {
    if (user_exp >= user_max_exp) {
      user_exp = user_exp - user_max_exp;
      user_level += 1;
    }
  }
}
