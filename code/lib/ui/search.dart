import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../util/dbhelper.dart';
import 'showform.dart';
import 'searchform.dart';
import 'searchcardwidget.dart';

class SearchPage extends StatefulWidget {
  List<dynamic> results;
  SearchPage({required this.results});

  @override
  _SearchPageState createState() => _SearchPageState(results: results);
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> results;

  _SearchPageState({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                'No Data',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (_, index) {
                final currentItem = results[index];
                return SearchCardWidget(currentItem);
              },
            ),
    );
  }
}
