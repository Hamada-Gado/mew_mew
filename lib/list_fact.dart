import 'package:flutter/material.dart';

class ListFact extends StatelessWidget {
  late final Map<String, dynamic> json;

  ListFact({required this.json, super.key});

  @override
  Widget build(BuildContext context) {
    String fact = json['text'];
    bool? verified = json['status']['verified'];

    return Card(
      color: Colors.black38,
      margin: const EdgeInsets.all(2),
      child: ListTile(
        title:
            SelectableText(fact, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Container(
          decoration: BoxDecoration(
              color: verified == null
                  ? Colors.black26
                  : verified == false
                      ? Colors.red
                      : Colors.green,
              shape: BoxShape.circle),
          child: Icon(
            verified == null
                ? Icons.question_mark
                : verified == false
                    ? Icons.close
                    : Icons.check,
            size: 40,
            color: Colors.white,
          ),
        ),
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
