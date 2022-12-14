import 'package:flutter/material.dart';
import 'showform.dart';

class SearchCardWidget extends StatelessWidget {
  Map<String, dynamic> currentItem;

  SearchCardWidget(this.currentItem);

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(currentItem['date']);
    DateTime _from = DateTime.fromMillisecondsSinceEpoch(currentItem['from']);
    DateTime _to = DateTime.fromMillisecondsSinceEpoch(currentItem['to']);
    return Card(
      color: Colors.orange.shade100,
      margin: const EdgeInsets.all(10),
      elevation: 3,
      child: ListTile(
        isThreeLine: true,
        title: Text(currentItem['task']),
        subtitle: Text(currentItem['tag'].toString() +
            "\n${_date.month}/${_date.day}/${_date.year} | " +
            "${_from.hour}:${_from.minute} - " +
            "${_to.hour}:${_to.minute}"),
      ),
    );
  }
}
