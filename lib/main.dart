// main.dart
// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'util/dbhelper.dart';
import 'ui/showform.dart';
import 'ui/searchform.dart';
import 'ui/cardwidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  var name = 'time_list';
  await Hive.openBox(name);
  runApp(MyApp(dbname: name));
}

class MyApp extends StatelessWidget {
  String dbname;
  MyApp({Key? key, required this.dbname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ASE 456 Personal Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(dbname: dbname),
    );
  }
}

class HomePage extends StatefulWidget {
  String dbname;
  HomePage({Key? key, required this.dbname}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(dbname: dbname);
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> _items;
  late var db;
  late var show;
  late var search;
  String dbname;

  _HomePageState({required this.dbname}) {
    _items = [];
    db = Database(db: dbname);
    show = ShowForm(db: db, refreshItems: _refreshItems);
    search = SearchForm(db: db);
  }

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = db.toList();
    setState(
      () {
        _items = data.reversed.toList();
        show.updateItems(_items);
      },
    );
  }

  void deleteItem(int key) {
    db.deleteItem(key);
    _refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('ASE 456 Personal Project'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: "Query",
              onPressed: () async => await search.showForm(context),
            )
          ]),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'No Data Found',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];
                return CardWidget(currentItem, show, deleteItem);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await show.showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
