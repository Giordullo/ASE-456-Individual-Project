import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import 'package:date_field/date_field.dart';
import 'search.dart';

class SearchForm extends StatelessWidget {
  Database db;
  late List<Map<String, dynamic>> items;

  SearchForm({required this.db});

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  DateTime? _date;

  void updateItems(List<Map<String, dynamic>> items) {
    this.items = items;
  }

  void showForm(BuildContext ctx) async {
    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DateTimeFormField(
              mode: DateTimeFieldPickerMode.date,
              onDateSelected: (value) => {_date = value},
              decoration: const InputDecoration(hintText: 'Date'),
            ),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(hintText: 'Task'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _tagController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Tag'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var filterList = db.toList();

                if (_date != null) {
                  filterList = filterList
                      .where((e) => e['date'] == _date!.millisecondsSinceEpoch)
                      .toList();
                  print("Date: " + _date.toString());
                }
                if (_taskController.text != "" &&
                    _taskController.text != null) {
                  filterList = filterList
                      .where((e) => e['task'] == _taskController.text)
                      .toList();
                  print("Task: " + _taskController.text);
                }
                if (_tagController.text != "" && _tagController.text != null) {
                  filterList = filterList
                      .where((e) => e['tag'] == _tagController.text)
                      .toList();
                  print("Tag: " + _tagController.text);
                }

                _date = null;
                _taskController.text = '';
                _tagController.text = '';

                Navigator.of(ctx).pop();
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: ((context) =>
                            SearchPage(results: filterList))));
              },
              child: Text('Search'),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
