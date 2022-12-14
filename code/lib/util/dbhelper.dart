import 'package:hive_flutter/hive_flutter.dart';

class Database {
  String db;
  late Box<dynamic> savedTime;
  Database({required this.db}) {
    savedTime = Hive.box(db);
  }

  List<Map<String, dynamic>> toList() {
    final data = savedTime.keys.map((key) {
      final value = savedTime.get(key);
      return {
        "key": key,
        "date": value["date"],
        "from": value['from'],
        "to": value['to'],
        "task": value['task'],
        "tag": value['tag']
      };
    }).toList();
    return data;
  }

  // Create new item
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await savedTime.add(newItem);
  }

  Map<String, dynamic> readItem(int key) {
    final item = savedTime.get(key);
    return item;
  }

  Future<void> updateItem(int itemKey, Map<String, dynamic> item) async {
    await savedTime.put(itemKey, item);
  }

  Future<void> deleteItem(int itemKey) async {
    await savedTime.delete(itemKey);
  }
}
