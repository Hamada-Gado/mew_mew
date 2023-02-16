import 'package:flutter/material.dart';

abstract class ExceptionHandlerW extends StatefulWidget {
  final String message;
  final Function() retry;
  const ExceptionHandlerW(
      {required this.message, required this.retry, super.key});

  @override
  State<ExceptionHandlerW> createState() => _ExceptionHandlerWState();
}

class _ExceptionHandlerWState extends State<ExceptionHandlerW> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: ListTile(
            title: SelectableText(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: const Icon(
              Icons.error_outline,
              size: 40,
              color: Colors.red,
            ),
          ),
        ),
        ElevatedButton(onPressed: widget.retry, child: const Text("Retry"))
      ],
    );
  }
}
