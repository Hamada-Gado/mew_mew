import 'package:flutter/material.dart';

abstract class ExceptionHandlerW extends StatelessWidget {
  final String message;
  final Function() retry;
  const ExceptionHandlerW(
      {required this.message, required this.retry, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: ListTile(
            title: SelectableText(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red,
            ),
          ),
        ),
        ElevatedButton(onPressed: retry, child: const Text("Retry"))
      ],
    );
  }
}
