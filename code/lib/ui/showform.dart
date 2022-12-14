import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import 'package:date_field/date_field.dart';

class ShowForm extends StatelessWidget {
  void Function() refreshItems;
  Database db;
  late List<Map<String, dynamic>> items;

  ShowForm({required this.db, required this.refreshItems});

  final TextEditingController taskController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  DateTime? date;
  DateTime? from;
  DateTime? to;

  void updateItems(List<Map<String, dynamic>> items) {
    this.items = items;
  }

  void onPressed(ctx, itemKey) async {
    if (itemKey == null) {
      db.createItem(
        {
          "date": date!.millisecondsSinceEpoch,
          "from": from!.millisecondsSinceEpoch,
          "to": to!.millisecondsSinceEpoch,
          "task": taskController.text,
          "tag": tagController.text
        },
      );
    } else {
      db.updateItem(
        itemKey,
        {
          'date': date!.millisecondsSinceEpoch,
          'from': from!.millisecondsSinceEpoch,
          'to': to!.millisecondsSinceEpoch,
          'task': taskController.text.trim(),
          'tag': tagController.text.trim()
        },
      );
    }
    refreshItems();

    taskController.text = '';
    tagController.text = '';

    Navigator.of(ctx).pop();
  }

  void showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          items.firstWhere((element) => element['key'] == itemKey);
      taskController.text = existingItem['task'];
      tagController.text = existingItem['tag'];
    }

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
              onDateSelected: (value) => {date = value},
              decoration: const InputDecoration(hintText: 'Date'),
            ),
            DateTimeFormField(
              mode: DateTimeFieldPickerMode.time,
              onDateSelected: (value) => {from = value},
              decoration: const InputDecoration(hintText: 'From'),
            ),
            DateTimeFormField(
              mode: DateTimeFieldPickerMode.time,
              onDateSelected: (value) => {to = value},
              decoration: const InputDecoration(hintText: 'To'),
            ),
            TextField(
              controller: taskController,
              decoration: const InputDecoration(hintText: 'Task'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: tagController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Tag'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                onPressed(ctx, itemKey);
              },
              child: Text(itemKey == null ? 'Create New' : 'Update'),
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
