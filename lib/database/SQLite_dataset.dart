class User_Data {
  int? id;
  String? name;
  int? level;
  String? inventory_name;
  String? inventory_amount;
  String? souls_name;
  String? souls_level;
  String? map_name;
  String? map_clear;
  int? pick_count;
  int? exp;
  String? save_time;
  int? exp_max;

  User_Data({
    this.id,
    this.name,
    this.level,
    this.inventory_name,
    this.inventory_amount,
    this.souls_name,
    this.souls_level,
    this.map_name,
    this.map_clear,
    this.pick_count,
    this.exp,
    this.save_time}):exp_max = 100 + (level! * 25).toInt();



  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
      'inventory_name': inventory_name,
      'inventory_amount' :inventory_amount,
      'souls_name' :souls_name,
      'souls_level' :souls_level,
      'map_name' : map_name,
      'map_clear' : map_clear,
      'pick_count' :pick_count,
      'exp' :exp,
      'save_time' : save_time
    };
  }
  void levelup() {
    if (exp! >= exp_max!) {
      exp = exp! - exp_max!;
      level = level! + 1;
    }
  }
}